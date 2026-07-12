import { createEffect, createSignal, createMemo, Show, For } from "solid-js";
import { createQuery } from "@tanstack/solid-query";
import { useUI } from "../../store/ui";
import { fetchQuery } from "../../lib/surreal";
import ModuleLayout from "../ModuleLayout";
import {
  Search,
  Plus,
  Activity,
  ArrowRight,
  XCircle,
  CheckCircle,
} from "lucide-solid";
import LedgerForm from "./components/LedgerForm";
import toast from "solid-toast";

function unwrap(r) {
  return r?.[0]?.result ?? r?.[0] ?? [];
}

export default function LedgerSystem() {
  const { setPageMeta, openDrawer } = useUI();
  createEffect(() => setPageMeta("Universal Vector Ledger", "ledger"));

  const [statusFilter, setStatusFilter] = createSignal("All");

  const ledgerQuery = createQuery(() => ({
    queryKey: ["esg_ledger"],
    queryFn: async () => {
      const res = await fetchQuery(`
        SELECT 
          id, a_qty, a_status, created_at,
          d1_target_tb, d2_vector, d3_raw_xp, d4_net_xp, d5_raw_co2e,
          a_from.name AS user_name,
          a_to.a_name AS target_name
        FROM esg_tx 
        ORDER BY created_at DESC LIMIT 100;
      `);
      return unwrap(res);
    },
  }));

  const filteredTx = createMemo(() => {
    let tx = ledgerQuery.data || [];
    if (statusFilter() !== "All")
      tx = tx.filter((t) => t.a_status === statusFilter());
    return tx;
  });

  const handlePost = async (id) => {
    try {
      await fetchQuery(`UPDATE type::thing($id) SET a_status = 'Posted';`, {
        id,
      });
      ledgerQuery.refetch();
      toast.success("Ledger transaction posted. Math vectors propagated.");
    } catch (err) {
      toast.error(`Graph rejected post: ${err.message}`);
    }
  };

  const Toolbar = () => (
    <div class="flex items-center justify-end gap-4 w-full">
      <div class="join bg-base-200 p-1 rounded-btn">
        <button
          class={`btn btn-xs join-item ${statusFilter() === "All" ? "btn-active" : "btn-ghost"}`}
          onClick={() => setStatusFilter("All")}
        >
          All
        </button>
        <button
          class={`btn btn-xs join-item ${statusFilter() === "Posted" ? "btn-active text-success" : "btn-ghost"}`}
          onClick={() => setStatusFilter("Posted")}
        >
          Posted
        </button>
        <button
          class={`btn btn-xs join-item ${statusFilter() === "Draft" ? "btn-active text-warning" : "btn-ghost"}`}
          onClick={() => setStatusFilter("Draft")}
        >
          Draft
        </button>
      </div>
      <button
        class="btn btn-sm btn-primary"
        onClick={() => openDrawer("Execute Ledger Tx", () => <LedgerForm />)}
      >
        <Plus size={16} /> <Activity size={16} /> New Transaction
      </button>
    </div>
  );

  return (
    <ModuleLayout
      tabs={[{ label: "Immutable Stream", href: "/ledger", active: true }]}
      toolbar={Toolbar}
    >
      <div class="flex flex-col h-full overflow-y-auto layout-pad bg-base-200/30 gap-[var(--app-pad)]">
        <div class="bg-base-100 rounded-box border border-base-300 shadow-sm w-full overflow-x-auto">
          <table class="table table-sm md:table-md w-full">
            <thead>
              <tr class="bg-base-200/50 text-base-content/70">
                <th>Vector State</th>
                <th>Identity Node (From)</th>
                <th>Target Anchor (To)</th>
                <th class="text-right">Qty</th>
                <th class="text-right">Net XP</th>
                <th class="text-right">CO2e</th>
                <th class="text-right">Action</th>
              </tr>
            </thead>
            <tbody>
              <Show
                when={!ledgerQuery.isLoading}
                fallback={
                  <tr>
                    <td colspan="7" class="text-center py-4">
                      <span class="loading loading-spinner text-primary"></span>
                    </td>
                  </tr>
                }
              >
                <For each={filteredTx()}>
                  {(tx) => (
                    <tr class="hover">
                      <td>
                        <div class="flex items-center gap-2">
                          <span
                            class={`badge badge-sm font-bold ${tx.a_status === "Posted" ? "badge-success" : tx.a_status === "Draft" ? "badge-warning" : "badge-error"}`}
                          >
                            {tx.a_status}
                          </span>
                          <span
                            class={`font-mono text-xs font-bold ${tx.d2_vector > 0 ? "text-success" : tx.d2_vector < 0 ? "text-error" : "text-base-content/50"}`}
                          >
                            [VEC:{" "}
                            {tx.d2_vector > 0
                              ? "+1"
                              : tx.d2_vector < 0
                                ? "-1"
                                : "0"}
                            ]
                          </span>
                        </div>
                      </td>
                      <td class="font-bold">{tx.user_name}</td>
                      <td>
                        <div class="flex items-center gap-2">
                          <ArrowRight size={14} class="text-base-content/40" />
                          <span class="badge badge-ghost badge-sm">
                            {tx.d1_target_tb}
                          </span>
                          <span class="font-bold text-sm truncate max-w-[200px]">
                            {tx.target_name}
                          </span>
                        </div>
                      </td>
                      <td class="text-right font-mono">{tx.a_qty}</td>
                      <td
                        class={`text-right font-mono font-bold ${tx.d4_net_xp > 0 ? "text-success" : tx.d4_net_xp < 0 ? "text-error" : ""}`}
                      >
                        {tx.d4_net_xp > 0 ? "+" : ""}
                        {tx.d4_net_xp}
                      </td>
                      <td class="text-right font-mono text-error">
                        {tx.d5_raw_co2e > 0 ? tx.d5_raw_co2e : "-"}
                      </td>
                      <td class="text-right">
                        <Show when={tx.a_status === "Draft"}>
                          <button
                            class="btn btn-xs btn-success btn-outline"
                            onClick={() => handlePost(tx.id)}
                          >
                            <CheckCircle size={14} /> Post
                          </button>
                        </Show>
                      </td>
                    </tr>
                  )}
                </For>
              </Show>
            </tbody>
          </table>
        </div>
      </div>
    </ModuleLayout>
  );
}
