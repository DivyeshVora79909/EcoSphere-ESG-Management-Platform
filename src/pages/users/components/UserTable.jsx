import { useUI } from "../../../store/ui";
import { ShieldAlert, ShieldCheck } from "lucide-solid";
import UserProfile from "./UserProfile";

export default function UserTable(props) {
  const { openDrawer } = useUI();

  return (
    <div class="overflow-x-auto bg-base-100 rounded-box border border-base-300 shadow-sm w-full">
      <table class="table table-sm md:table-md w-full">
        <thead>
          <tr class="bg-base-200/50 text-base-content/70">
            <th>Identity</th>
            <th>Topological Parents</th>
            <th>Network State</th>
            <th>Sub-Nodes</th>
            <th class="text-right">Action</th>
          </tr>
        </thead>
        <tbody>
          {props.users.map((user) => (
            <tr
              class="hover cursor-pointer"
              onClick={() =>
                openDrawer("Node Matrix", () => <UserProfile baseUser={user} />)
              }
            >
              <td>
                <div class="flex items-center gap-3">
                  <div class="avatar placeholder">
                    <div
                      class={`w-8 rounded-full border ${user.login_access ? "border-success" : "border-error"} bg-base-200`}
                    >
                      <span class="font-bold text-xs">
                        {user.name.charAt(0)}
                      </span>
                    </div>
                  </div>
                  <div>
                    <div class="font-bold text-sm">{user.name}</div>
                    <div class="text-[10px] font-mono text-base-content/50">
                      {user.email}
                    </div>
                  </div>
                </div>
              </td>

              <td>
                <div class="flex gap-1 flex-wrap">
                  {user.parents && user.parents.length > 0 ? (
                    user.parents.map((p) => (
                      <span class="badge badge-xs badge-primary badge-outline">
                        {p}
                      </span>
                    ))
                  ) : (
                    <span class="badge badge-xs badge-ghost">None</span>
                  )}
                </div>
              </td>

              <td>
                <div class="flex items-center gap-1.5">
                  {user.login_access ? (
                    <ShieldCheck size={14} class="text-success" />
                  ) : (
                    <ShieldAlert size={14} class="text-error" />
                  )}
                  <span
                    class={`text-xs font-bold ${user.login_access ? "text-success" : "text-error"}`}
                  >
                    {user.login_access ? "Active" : "Suspended"}
                  </span>
                </div>
              </td>

              <td>
                <span class="text-xs font-bold text-secondary">
                  {user.dominates ? user.dominates.length : 0}
                </span>
              </td>

              <td class="text-right">
                <button class="btn btn-ghost btn-xs">Inspect</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
