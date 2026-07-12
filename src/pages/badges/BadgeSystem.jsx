import { createEffect, createSignal, createMemo, Show } from "solid-js";
import { createQuery } from "@tanstack/solid-query";
import { useUI } from "../../store/ui";
import { fetchQuery } from "../../lib/surreal";
import ModuleLayout from "../ModuleLayout";
import { Search, Plus, Medal, Users } from "lucide-solid";
import BadgeForm from "./components/BadgeForm";

function unwrap(r) {
  return r?.[0]?.result ?? r?.[0] ?? [];
}

export default function BadgeSystem() {
  const { setPageMeta, openDrawer } = useUI();
  createEffect(() => setPageMeta("Gamification Badges", "badges"));

  const [search, setSearch] = createSignal("");

  // Queries badges and counts mathematically how many users qualify based on upward propagated d1_net_xp
  const badgeQuery = createQuery(() => ({
    queryKey: ["esg_badges"],
    queryFn: async () => {
      const res = await fetchQuery(`
        SELECT 
          id, a_name, a_required_xp, a_status,
          a_category.a_name AS category_name,
          (SELECT count() FROM user WHERE d1_net_xp >= $parent.a_required_xp)[0].count AS qualified_users
        FROM badge 
        ORDER BY a_required_xp ASC;
      `);
      return unwrap(res);
    },
  }));

  const filteredBadges = createMemo(() => {
    let nodes = badgeQuery.data || [];
    if (search().trim()) {
      const s = search().toLowerCase();
      nodes = nodes.filter((n) => n.a_name.toLowerCase().includes(s));
    }
    return nodes;
  });

  const Toolbar = () => (
    <div class="flex items-center justify-between gap-4 w-full">
      <div class="relative w-full max-w-sm">
        <Search
          class="absolute left-3 top-1/2 -translate-y-1/2 text-base-content/50"
          size={16}
        />
        <input
          type="text"
          placeholder="Query badges..."
          class="input input-sm input-ghost w-full pl-9"
          value={search()}
          onInput={(e) => setSearch(e.target.value)}
        />
      </div>
      <button
        class="btn btn-sm btn-primary"
        onClick={() => openDrawer("Deploy Badge", () => <BadgeForm />)}
      >
        <Plus size={16} /> <Medal size={16} /> New Badge
      </button>
    </div>
  );

  return (
    <ModuleLayout
      tabs={[{ label: "Badge Milestones", href: "/badges", active: true }]}
      toolbar={Toolbar}
    >
      <div class="flex flex-col h-full overflow-y-auto layout-pad bg-base-200/30 gap-[var(--app-pad)]">
        <Show
          when={!badgeQuery.isLoading}
          fallback={
            <div class="loading loading-spinner text-primary mx-auto"></div>
          }
        >
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-[var(--app-pad)]">
            {filteredBadges().map((badge) => (
              <div
                class={`card bg-base-100 shadow-sm border hover:shadow-md transition-all cursor-pointer group ${badge.a_status !== "Active" ? "opacity-70 border-base-300" : "border-warning/30 hover:border-warning"}`}
                onClick={() =>
                  openDrawer("Edit Badge", () => (
                    <BadgeForm baseBadge={badge} />
                  ))
                }
              >
                <div class="card-body p-4 flex flex-col gap-3">
                  <div class="flex items-center justify-between">
                    <span
                      class={`badge badge-sm ${badge.a_status === "Active" ? "badge-success" : "badge-ghost"}`}
                    >
                      {badge.a_status}
                    </span>
                  </div>
                  <div class="flex flex-col items-center justify-center gap-2 py-4">
                    <div class="w-16 h-16 rounded-full bg-warning/20 border-2 border-warning/50 flex items-center justify-center text-warning shadow-inner">
                      <Medal size={32} />
                    </div>
                    <h3 class="font-bold text-lg text-center group-hover:text-warning transition-colors">
                      {badge.a_name}
                    </h3>
                  </div>
                  <div class="grid grid-cols-2 gap-2 mt-2 pt-2 border-t border-base-200">
                    <div class="flex flex-col">
                      <span class="text-[10px] uppercase text-base-content/50 flex items-center gap-1">
                        Threshold
                      </span>
                      <span class="font-mono font-bold text-warning">
                        {badge.a_required_xp} XP
                      </span>
                    </div>
                    <div class="flex flex-col items-end">
                      <span class="text-[10px] uppercase text-base-content/50 flex items-center gap-1">
                        <Users size={10} /> Unlocked By
                      </span>
                      <span class="font-mono font-bold text-base-content">
                        {badge.qualified_users ?? 0}
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </Show>
      </div>
    </ModuleLayout>
  );
}
