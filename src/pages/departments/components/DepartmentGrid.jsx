import { Building2, Leaf, Zap } from "lucide-solid";
import { useUI } from "../../../store/ui";
import DepartmentForm from "./DepartmentForm";

export default function DepartmentGrid(props) {
  const { openDrawer } = useUI();

  return (
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-[var(--app-pad)]">
      {props.departments.map((dept) => (
        <div
          class="card bg-base-100 shadow-sm border border-base-300 hover:border-primary/50 transition-colors cursor-pointer group"
          onClick={() =>
            openDrawer("Edit Department", () => (
              <DepartmentForm baseDept={dept} />
            ))
          }
        >
          <div class="card-body p-5">
            <div class="flex items-center gap-3 border-b border-base-200 pb-3 mb-2">
              <div class="w-10 h-10 rounded-box bg-secondary/10 flex items-center justify-center text-secondary shrink-0">
                <Building2 size={20} />
              </div>
              <div class="min-w-0">
                <h3 class="font-bold text-lg truncate group-hover:text-primary transition-colors">
                  {dept.name}
                </h3>
                <p class="text-xs font-mono text-base-content/50 truncate">
                  {dept.id}
                </p>
              </div>
            </div>

            {/* Derived ESG Ledger Metrics (From File 07 Propagations) */}
            <div class="grid grid-cols-2 gap-4 mt-2">
              <div class="bg-base-200/50 p-3 rounded-box border border-base-200">
                <p class="text-[10px] font-bold uppercase tracking-widest text-base-content/50 flex items-center gap-1 mb-1">
                  <Zap size={12} class="text-warning" /> Dept XP
                </p>
                <p class="text-lg font-black text-base-content">
                  {dept.d1_net_xp?.toLocaleString() || 0}
                </p>
              </div>
              <div class="bg-base-200/50 p-3 rounded-box border border-base-200">
                <p class="text-[10px] font-bold uppercase tracking-widest text-base-content/50 flex items-center gap-1 mb-1">
                  <Leaf size={12} class="text-success" /> CO2e (kg)
                </p>
                <p class="text-lg font-black text-base-content">
                  {dept.d2_total_co2e?.toLocaleString() || 0}
                </p>
              </div>
            </div>
          </div>
        </div>
      ))}
    </div>
  );
}
