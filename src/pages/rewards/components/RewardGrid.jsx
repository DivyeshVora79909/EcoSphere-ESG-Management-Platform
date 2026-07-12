import { Gift, Box, Zap } from "lucide-solid";
import { useUI } from "../../../store/ui";
import RewardForm from "./RewardForm";

export default function RewardGrid(props) {
  const { openDrawer } = useUI();

  return (
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-[var(--app-pad)]">
      {props.rewards.map((reward) => (
        <div
          class={`card bg-base-100 shadow-sm border hover:shadow-md transition-all cursor-pointer group ${reward.a_status !== "Active" ? "opacity-70 border-base-300" : "border-primary/30 hover:border-primary"}`}
          onClick={() =>
            openDrawer("Edit Reward Anchor", () => (
              <RewardForm baseReward={reward} />
            ))
          }
        >
          <div class="card-body p-4 flex flex-col gap-3">
            <div class="flex items-center justify-between">
              <span
                class={`badge badge-sm ${reward.a_status === "Active" ? "badge-success" : "badge-ghost"}`}
              >
                {reward.a_status}
              </span>
              <span class="text-xs font-mono text-base-content/40">
                {reward.category_name || "No Category"}
              </span>
            </div>

            <div class="flex items-center gap-3">
              <div class="w-10 h-10 rounded-box bg-primary/10 flex items-center justify-center text-primary shrink-0">
                <Gift size={20} />
              </div>
              <div class="min-w-0 flex-1">
                <h3 class="font-bold text-sm truncate group-hover:text-primary transition-colors">
                  {reward.a_name}
                </h3>
              </div>
            </div>

            <div class="grid grid-cols-2 gap-2 mt-2 pt-2 border-t border-base-200">
              <div class="flex flex-col">
                <span class="text-[10px] uppercase text-base-content/50 flex items-center gap-1">
                  <Zap size={10} /> XP Cost
                </span>
                <span class="font-mono font-bold text-warning">
                  {reward.a_xp_cost}
                </span>
              </div>
              <div class="flex flex-col items-end">
                <span class="text-[10px] uppercase text-base-content/50 flex items-center gap-1">
                  <Box size={10} /> In Stock
                </span>
                <span
                  class={`font-mono font-bold ${reward.d1_remaining_stock <= 0 ? "text-error" : "text-success"}`}
                >
                  {reward.d1_remaining_stock}{" "}
                  <span class="opacity-40 text-xs">
                    / {reward.a_total_stock}
                  </span>
                </span>
              </div>
            </div>
          </div>
        </div>
      ))}
    </div>
  );
}
