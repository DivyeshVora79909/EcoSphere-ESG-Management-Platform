import { createSignal, Show } from "solid-js";
import { useQueryClient } from "@tanstack/solid-query";
import { fetchQuery } from "../../../lib/surreal";
import { useUI } from "../../../store/ui";
import toast from "solid-toast";
import { Building2 } from "lucide-solid";

export default function DepartmentForm(props) {
  const { closeDrawer } = useUI();
  const qc = useQueryClient();

  const isUpdate = !!props.baseDept;
  const [name, setName] = createSignal(isUpdate ? props.baseDept.name : "");
  const [loading, setLoading] = createSignal(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      if (isUpdate) {
        // Handle Escalation Errors Natively via SurQL
        await fetchQuery(
          `
          BEGIN TRANSACTION;
          UPDATE type::thing($id) MERGE { name: $name };
          UPDATE $auth SET last_refreshed_at = time::now();
          COMMIT TRANSACTION;
          `,
          { id: props.baseDept.id, name: name() },
        );
        toast.success("Department parameters updated.");
      } else {
        await fetchQuery(
          `
          BEGIN TRANSACTION;
          CREATE groups SET name = $name;
          UPDATE $auth SET last_refreshed_at = time::now();
          COMMIT TRANSACTION;
          `,
          { name: name() },
        );
        toast.success("New Department deployed to graph.");
      }

      qc.invalidateQueries({ queryKey: ["esg_departments"] });
      // Invalidate users too, in case DAG roles updated
      qc.invalidateQueries({ queryKey: ["rbac_users"] });
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
          <Building2 class="text-secondary" size={18} />
          {isUpdate ? "Edit Department Anchor" : "Deploy Department Anchor"}
        </h3>

        <div class="form-control w-full">
          <label class="label">
            <span class="label-text font-bold text-base-content/70">
              Department Name
            </span>
          </label>
          <input
            type="text"
            class="input input-bordered w-full focus:border-secondary"
            value={name()}
            onInput={(e) => setName(e.target.value)}
            required
            placeholder="e.g. Operations & Logistics"
          />
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
          class="btn btn-secondary flex-1"
          disabled={loading()}
        >
          <Show
            when={loading()}
            fallback={isUpdate ? "Update Anchor" : "Deploy Anchor"}
          >
            <span class="loading loading-spinner"></span> Synthesizing...
          </Show>
        </button>
      </div>
    </form>
  );
}
