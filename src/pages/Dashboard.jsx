import { Show, createEffect, For } from "solid-js";
import { createQuery } from "@tanstack/solid-query";
import { useUI } from "../store/ui";
import { fetchQuery } from "../lib/surreal";
import { Leaf, Zap, Users, Building2, Activity } from "lucide-solid";

function unwrap(r) {
  return r?.[0]?.result ?? r?.[0] ?? [];
}

export default function Dashboard() {
  const { setPageMeta } = useUI();
  createEffect(() => setPageMeta("ESG Dashboard Matrix", "dashboard"));

  const dashQuery = createQuery(() => ({
    queryKey: ["dashboard_real_metrics"],
    queryFn: async () => {
      const [metrics, recentTx, topUsers] = await Promise.all([
        fetchQuery(`
          RETURN {
            users: (SELECT count() FROM user GROUP ALL)[0].count ?? 0,
            depts: (SELECT count() FROM groups GROUP ALL)[0].count ?? 0,
            co2e: (SELECT math::sum(d5_raw_co2e) AS total FROM esg_tx WHERE a_status = 'Posted' GROUP ALL)[0].total ?? 0dec,
            xp_minted: (SELECT math::sum(d4_net_xp) AS total FROM esg_tx WHERE a_status = 'Posted' AND d2_vector = 1 GROUP ALL)[0].total ?? 0dec
          };
        `),
        fetchQuery(`
          SELECT id, a_from.name AS user_name, record::tb(a_to) AS target_type, 
                 a_qty, d4_net_xp, d5_raw_co2e, a_status, created_at 
          FROM esg_tx 
          ORDER BY created_at DESC LIMIT 6;
        `),
        fetchQuery(`
          SELECT id, name, d1_net_xp, d2_total_co2e 
          FROM user 
          ORDER BY d1_net_xp DESC LIMIT 5;
        `),
      ]);
      return {
        metrics: unwrap(metrics),
        recentTx: unwrap(recentTx),
        topUsers: unwrap(topUsers),
      };
    },
  }));

  const StatCard = (props) => (
    <div class="card bg-base-100 shadow-sm border border-base-300">
      <div class="card-body p-5">
        <div class="flex items-center justify-between">
          <h3 class="text-xs font-bold text-base-content/50 uppercase tracking-widest">
            {props.title}
          </h3>
          <div class={`p-2 rounded-box ${props.colorClass}`}>{props.icon}</div>
        </div>
        <div class="mt-2 flex items-end gap-2">
          <span class="text-3xl font-black">{props.value}</span>
        </div>
      </div>
    </div>
  );

  return (
    <div class="flex flex-col h-full gap-[var(--app-pad)] pb-8">
      <Show
        when={!dashQuery.isLoading}
        fallback={<div class="skeleton h-32 w-full rounded-box"></div>}
      >
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-[var(--app-pad)]">
          <StatCard
            title="Total CO2e Emitted"
            value={`${dashQuery.data?.metrics.co2e || 0} kg`}
            icon={<Leaf size={20} />}
            colorClass="bg-success/10 text-success"
          />
          <StatCard
            title="Global XP Minted"
            value={dashQuery.data?.metrics.xp_minted || 0}
            icon={<Zap size={20} />}
            colorClass="bg-warning/10 text-warning"
          />
          <StatCard
            title="Active Users"
            value={dashQuery.data?.metrics.users || 0}
            icon={<Users size={20} />}
            colorClass="bg-info/10 text-info"
          />
          <StatCard
            title="Departments"
            value={dashQuery.data?.metrics.depts || 0}
            icon={<Building2 size={20} />}
            colorClass="bg-secondary/10 text-secondary"
          />
        </div>
      </Show>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-[var(--app-pad)] flex-1">
        <div class="card bg-base-100 shadow-sm border border-base-300 lg:col-span-2">
          <div class="card-body p-6">
            <h2 class="card-title text-lg border-b border-base-200 pb-2 flex items-center justify-between">
              Top ESG Performers
              <span class="text-xs font-normal text-base-content/50">
                Ranked by Net XP
              </span>
            </h2>
            <div class="overflow-x-auto mt-2">
              <table class="table table-sm w-full">
                <thead>
                  <tr class="text-base-content/60">
                    <th>Identity Node</th>
                    <th class="text-right">Net XP Balance</th>
                    <th class="text-right">CO2e Footprint</th>
                  </tr>
                </thead>
                <tbody>
                  <For each={dashQuery.data?.topUsers || []}>
                    {(user) => (
                      <tr class="hover">
                        <td class="font-bold">{user.name}</td>
                        <td class="text-right font-mono text-warning font-bold">
                          {user.d1_net_xp}
                        </td>
                        <td class="text-right font-mono text-error">
                          {user.d2_total_co2e} kg
                        </td>
                      </tr>
                    )}
                  </For>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <div class="card bg-base-100 shadow-sm border border-base-300">
          <div class="card-body p-6">
            <h2 class="card-title text-lg border-b border-base-200 pb-2 flex items-center gap-2">
              <Activity size={18} /> Ledger Stream
            </h2>
            <ul class="mt-4 flex flex-col gap-4">
              <For each={dashQuery.data?.recentTx || []}>
                {(tx) => (
                  <li class="flex items-start gap-3 border-b border-base-200 pb-2 last:border-0">
                    <div
                      class={`w-8 h-8 rounded-full flex items-center justify-center shrink-0 mt-1 ${tx.d4_net_xp > 0 ? "bg-success/20 text-success" : tx.d4_net_xp < 0 ? "bg-error/20 text-error" : "bg-base-200"}`}
                    >
                      <span class="text-[10px] font-bold">
                        {tx.d4_net_xp > 0 ? "+" : tx.d4_net_xp < 0 ? "-" : ""}
                      </span>
                    </div>
                    <div>
                      <p class="text-xs font-bold truncate">
                        {tx.user_name} → {tx.target_type.replace("_", " ")}
                      </p>
                      <div class="flex gap-2 text-[10px] font-mono mt-1 opacity-70">
                        <span>XP: {tx.d4_net_xp}</span>
                        <span>CO2e: {tx.d5_raw_co2e}</span>
                        <span
                          class={
                            tx.a_status === "Posted"
                              ? "text-success"
                              : "text-warning"
                          }
                        >
                          {tx.a_status}
                        </span>
                      </div>
                    </div>
                  </li>
                )}
              </For>
            </ul>
          </div>
        </div>
      </div>
    </div>
  );
}
