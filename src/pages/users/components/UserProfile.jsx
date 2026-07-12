import { Show } from "solid-js";
import { useQueryClient } from "@tanstack/solid-query";
import { fetchQuery } from "../../../lib/surreal";
import { useUI } from "../../../store/ui";
import { ShieldAlert, Clock, Key, Network, Power } from "lucide-solid";
import toast from "solid-toast";

export default function UserProfile(props) {
  const { closeModal } = useUI();
  const queryClient = useQueryClient();
  const { baseUser } = props;

  // DB Math Action: Mutate state and force Network refresh
  const handleToggleAccess = async () => {
    try {
      await fetchQuery(
        `UPDATE ${baseUser.id} SET login_access = ${!baseUser.login_access}`,
      );
      await queryClient.invalidateQueries({ queryKey: ["rbac_users"] });
      toast.success(`Node ${baseUser.login_access ? "Suspended" : "Restored"}`);
      closeModal();
    } catch (err) {
      toast.error(`Mutation rejected: ${err.message}`);
    }
  };

  return (
    <div class="flex flex-col gap-6 h-full">
      {/* 1. Identity Matrix */}
      <div class="flex items-center gap-4 p-4 bg-base-200 rounded-box border border-base-300">
        <div class="avatar placeholder">
          <div
            class={`w-16 rounded-full border-4 ${baseUser.login_access ? "border-success" : "border-error"} bg-base-100`}
          >
            <span class="text-2xl font-black">{baseUser.name.charAt(0)}</span>
          </div>
        </div>
        <div class="flex-1 min-w-0">
          <h2 class="text-xl font-bold truncate">{baseUser.name}</h2>
          <p class="text-xs font-mono text-base-content/50 truncate mb-2">
            {baseUser.id}
          </p>
          <span
            class={`badge badge-sm ${baseUser.login_access ? "badge-success" : "badge-error"}`}
          >
            {baseUser.login_access ? "Graph Edge Active" : "Edge Severed"}
          </span>
        </div>
      </div>

      {/* 2. Structural Topology */}
      <div class="bg-base-100 border border-base-300 rounded-box p-4">
        <h3 class="text-xs font-bold text-base-content/50 uppercase tracking-widest mb-4 flex items-center gap-2">
          <Network size={14} /> Topological Vectors
        </h3>

        <div class="grid grid-cols-2 gap-4">
          <div>
            <p class="text-xs text-base-content/60 mb-1">Parent Groups</p>
            <div class="flex flex-wrap gap-1">
              <Show
                when={baseUser.parents?.length > 0}
                fallback={
                  <span class="text-sm font-bold opacity-50">None</span>
                }
              >
                {baseUser.parents.map((g) => (
                  <span class="badge badge-primary badge-outline badge-sm">
                    {g}
                  </span>
                ))}
              </Show>
            </div>
          </div>
          <div>
            <p class="text-xs text-base-content/60 mb-1">Dominated Nodes</p>
            <p class="text-lg font-bold text-secondary">
              {baseUser.dominates?.length || 0}
            </p>
          </div>
        </div>
      </div>

      {/* 3. RBAC Permissions Matrix */}
      <div class="bg-base-100 border border-base-300 rounded-box p-4">
        <h3 class="text-xs font-bold text-base-content/50 uppercase tracking-widest mb-4 flex items-center gap-2">
          <Key size={14} /> Evaluated Permissions Array
        </h3>
        <div class="flex flex-wrap gap-1 max-h-48 overflow-y-auto p-2 bg-base-200 rounded-box border border-base-300 inset-shadow-sm">
          <Show
            when={baseUser.permissions?.length > 0}
            fallback={
              <span class="text-sm font-mono opacity-50 px-2 py-1">
                [] Null Vector
              </span>
            }
          >
            {baseUser.permissions.map((p) => (
              <span class="badge badge-sm badge-ghost font-mono text-[10px] whitespace-nowrap">
                {p}
              </span>
            ))}
          </Show>
        </div>
      </div>

      {/* 4. Audit Telemetry */}
      <div class="mt-auto flex items-center justify-between text-[10px] text-base-content/50 font-mono pt-4">
        <span class="flex items-center gap-1">
          <Clock size={12} /> Genesis:{" "}
          {new Date(baseUser.created_at).toLocaleDateString()}
        </span>
        <span class="flex items-center gap-1 text-error">
          <ShieldAlert size={12} /> Suspensions:{" "}
          {baseUser.total_suspensions || 0}
        </span>
      </div>

      {/* 5. Action Context */}
      <div class="flex gap-2 pt-4 border-t border-base-300">
        <button class="btn btn-outline flex-1">Edit Properties</button>
        <button
          class={`btn flex-1 ${baseUser.login_access ? "btn-error btn-outline" : "btn-success"}`}
          onClick={handleToggleAccess}
        >
          <Power size={16} />
          {baseUser.login_access ? "Suspend Node" : "Restore Node"}
        </button>
      </div>
    </div>
  );
}
