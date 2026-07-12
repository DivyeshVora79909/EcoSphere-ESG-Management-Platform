import { Users, UserCheck, UserX } from "lucide-solid";

export default function UserStats(props) {
  return (
    <div class="grid grid-cols-1 md:grid-cols-3 gap-[var(--app-pad)]">
      <div class="card bg-base-100 shadow-sm border border-base-300">
        <div class="card-body p-4 flex flex-row items-center justify-between">
          <div>
            <h3 class="text-xs font-bold text-base-content/50 uppercase tracking-widest">
              Total Users
            </h3>
            <p class="text-2xl font-black mt-1">{props.users.length}</p>
          </div>
          <div class="p-3 bg-base-200 rounded-box text-primary">
            <Users size={20} />
          </div>
        </div>
      </div>

      <div class="card bg-base-100 shadow-sm border border-base-300">
        <div class="card-body p-4 flex flex-row items-center justify-between">
          <div>
            <h3 class="text-xs font-bold text-base-content/50 uppercase tracking-widest">
              Active Users
            </h3>
            <p class="text-2xl font-black mt-1 text-success">
              {props.users.filter((u) => u.login_access).length}
            </p>
          </div>
          <div class="p-3 bg-success/10 rounded-box text-success">
            <UserCheck size={20} />
          </div>
        </div>
      </div>

      <div class="card bg-base-100 shadow-sm border border-base-300">
        <div class="card-body p-4 flex flex-row items-center justify-between">
          <div>
            <h3 class="text-xs font-bold text-base-content/50 uppercase tracking-widest">
              Suspended
            </h3>
            <p class="text-2xl font-black mt-1 text-error">
              {props.users.filter((u) => !u.login_access).length}
            </p>
          </div>
          <div class="p-3 bg-error/10 rounded-box text-error">
            <UserX size={20} />
          </div>
        </div>
      </div>
    </div>
  );
}
