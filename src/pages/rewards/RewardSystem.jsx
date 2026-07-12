import { createEffect, createSignal, createMemo, Show } from "solid-js";
import { createQuery } from "@tanstack/solid-query";
import { useUI } from "../../store/ui";
import { fetchQuery } from "../../lib/surreal";
import ModuleLayout from "../ModuleLayout";
import RewardToolbar from "./components/RewardToolbar";
import RewardGrid from "./components/RewardGrid";

function unwrap(r) {
  return r?.[0]?.result ?? r?.[0] ?? [];
}

export default function RewardSystem() {
  const { setPageMeta } = useUI();
  createEffect(() => setPageMeta("Reward Catalog", "rewards"));

  const [search, setSearch] = createSignal("");
  const [statusFilter, setStatusFilter] = createSignal("Active");

  // Pulls Rewards & dynamically resolves their computed remaining stock
  const rewardsQuery = createQuery(() => ({
    queryKey: ["esg_rewards"],
    queryFn: async () => {
      const res = await fetchQuery(`
        SELECT id, a_name, a_xp_cost, a_total_stock, a_status, 
               a_category.a_name AS category_name, d1_remaining_stock 
        FROM reward 
        ORDER BY a_status ASC, a_name ASC;
      `);
      return unwrap(res);
    },
  }));

  const filteredRewards = createMemo(() => {
    let nodes = rewardsQuery.data || [];
    if (statusFilter() !== "All")
      nodes = nodes.filter((n) => n.a_status === statusFilter());
    if (search().trim()) {
      const s = search().toLowerCase();
      nodes = nodes.filter((n) => n.a_name.toLowerCase().includes(s));
    }
    return nodes;
  });

  return (
    <ModuleLayout
      tabs={[{ label: "Catalog Array", href: "/rewards", active: true }]}
      toolbar={() => (
        <RewardToolbar
          search={search}
          setSearch={setSearch}
          status={statusFilter}
          setStatus={setStatusFilter}
        />
      )}
    >
      <div class="flex flex-col h-full overflow-y-auto layout-pad bg-base-200/30 gap-[var(--app-pad)]">
        <Show
          when={!rewardsQuery.isLoading}
          fallback={
            <div class="loading loading-spinner text-primary mx-auto mt-8"></div>
          }
        >
          <RewardGrid rewards={filteredRewards()} />
        </Show>
      </div>
    </ModuleLayout>
  );
}
