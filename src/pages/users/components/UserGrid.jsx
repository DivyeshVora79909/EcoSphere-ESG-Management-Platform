import { useUI } from "../../../store/ui";
import { ShieldAlert, ShieldCheck, Network } from "lucide-solid";
import UserProfile from "./UserProfile";

export default function UserGrid(props) {
  const { openDrawer } = useUI();

  return (
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-[var(--app-pad)]">
      {props.users.map((user) => (
        <div
          class="card bg-base-100 shadow-sm hover:shadow-md transition-all cursor-pointer border border-base-300 hover:border-primary/50 group"
          onClick={() =>
            openDrawer("Node Matrix", () => <UserProfile baseUser={user} />)
          }
        >
          <div class="card-body p-4 flex flex-col gap-3">
            {/* Header: Identity & Status */}
            <div class="flex items-center gap-3">
              <div class="avatar placeholder relative shrink-0">
                <div
                  class={`w-10 rounded-full border-2 ${user.login_access ? "border-success" : "border-error"} bg-base-200 text-base-content`}
                >
                  <span class="font-bold">
                    {user.name.charAt(0).toUpperCase()}
                  </span>
                </div>
                <div class="absolute -bottom-1 -right-1 bg-base-100 rounded-full p-[2px]">
                  {user.login_access ? (
                    <ShieldCheck size={14} class="text-success" />
                  ) : (
                    <ShieldAlert size={14} class="text-error" />
                  )}
                </div>
              </div>
              <div class="min-w-0 flex-1">
                <h3 class="font-bold text-sm truncate group-hover:text-primary transition-colors">
                  {user.name}
                </h3>
                <p class="text-xs text-base-content/60 truncate font-mono">
                  {user.email}
                </p>
              </div>
            </div>

            {/* Sub-Header: Topology Info */}
            <div class="flex items-center gap-2 mt-1">
              <Network size={14} class="text-base-content/40" />
              <div class="flex flex-wrap gap-1">
                {user.parents && user.parents.length > 0 ? (
                  <span class="badge badge-xs badge-primary badge-outline">
                    {user.parents[0]}
                  </span>
                ) : (
                  <span class="badge badge-xs badge-ghost">Leaf Node</span>
                )}
                {user.dominates && user.dominates.length > 0 && (
                  <span class="badge badge-xs badge-secondary badge-outline">
                    +{user.dominates.length} subs
                  </span>
                )}
              </div>
            </div>
          </div>
        </div>
      ))}
    </div>
  );
}
