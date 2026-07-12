import { createSignal, Show } from "solid-js";
import { useQueryClient } from "@tanstack/solid-query";
import { fetchQuery } from "../../../lib/surreal";
import { useUI } from "../../../store/ui";
import toast from "solid-toast";
import { ShieldCheck, Mail, User } from "lucide-solid";

export default function UserForm(props) {
  const { closeDrawer } = useUI();
  const qc = useQueryClient();

  const isUpdate = !!props.baseUser;
  const [name, setName] = createSignal(isUpdate ? props.baseUser.name : "");
  const [email, setEmail] = createSignal(isUpdate ? props.baseUser.email : "");
  const [loading, setLoading] = createSignal(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      if (isUpdate) {
        // MUTATION SEQUENCE: Update profile -> Refresh DAG Permissions
        await fetchQuery(
          `
          BEGIN TRANSACTION;
          LET $upd = (UPDATE type::thing($id) MERGE { name: $name, email: $email });
          UPDATE $auth SET last_refreshed_at = time::now();
          COMMIT TRANSACTION;
          `,
          { id: props.baseUser.id, name: name(), email: email() },
        );
        toast.success("User node updated successfully.");
      } else {
        // CREATION SEQUENCE: Create -> Refresh DAG -> Fire Token Email Event
        await fetchQuery(
          `
          BEGIN TRANSACTION;
          LET $new_user = (CREATE user SET name = $name, email = $email)[0];
          UPDATE $auth SET last_refreshed_at = time::now();
          UPDATE $new_user.id SET last_send_token_at = time::now();
          COMMIT TRANSACTION;
          `,
          { name: name(), email: email() },
        );
        toast.success("User deployed and invite token dispatched.");
      }

      // Invalidate frontend O(1) cache
      qc.invalidateQueries({ queryKey: ["rbac_users"] });
      qc.invalidateQueries({ queryKey: ["rbac_graph"] });
      closeDrawer();
    } catch (err) {
      toast.error(err.message || "Mutation rejected by graph guards.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} class="flex flex-col gap-6 h-full pb-4">
      <div class="bg-base-200/50 p-4 rounded-box border border-base-300">
        <h3 class="text-sm font-bold flex items-center gap-2 mb-4">
          <ShieldCheck class="text-primary" size={18} />
          {isUpdate ? "Edit Identity Node" : "Deploy New User Node"}
        </h3>

        <div class="form-control w-full">
          <label class="label">
            <span class="label-text font-bold text-base-content/70 flex items-center gap-2">
              <User size={14} /> Full Name
            </span>
          </label>
          <input
            type="text"
            class="input input-bordered w-full focus:border-primary"
            value={name()}
            onInput={(e) => setName(e.target.value)}
            required
            placeholder="e.g. John Doe"
          />
        </div>

        <div class="form-control w-full mt-4">
          <label class="label">
            <span class="label-text font-bold text-base-content/70 flex items-center gap-2">
              <Mail size={14} /> Access Email
            </span>
          </label>
          <input
            type="email"
            class="input input-bordered w-full focus:border-primary"
            value={email()}
            onInput={(e) => setEmail(e.target.value)}
            required
            placeholder="user@organization.com"
          />
          <Show when={!isUpdate}>
            <label class="label mt-1">
              <span class="label-text-alt text-base-content/50">
                An activation token will be dispatched to this address via
                Brevo.
              </span>
            </label>
          </Show>
        </div>
      </div>

      <div class="mt-auto flex gap-3 pt-4 border-t border-base-300">
        <button
          type="button"
          class="btn btn-ghost flex-1"
          onClick={closeDrawer}
          disabled={loading()}
        >
          Abort
        </button>
        <button
          type="submit"
          class="btn btn-primary flex-1"
          disabled={loading()}
        >
          <Show
            when={loading()}
            fallback={isUpdate ? "Update Node" : "Deploy & Dispatch"}
          >
            <span class="loading loading-spinner"></span> Propagating...
          </Show>
        </button>
      </div>
    </form>
  );
}
