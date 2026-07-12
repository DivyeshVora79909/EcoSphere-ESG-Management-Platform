import { createEffect, createSignal, createMemo, Show } from "solid-js";
import { createQuery } from "@tanstack/solid-query";
import { useUI } from "../../store/ui";
import { fetchQuery } from "../../lib/surreal";
import ModuleLayout from "../ModuleLayout";
import { Search, Plus, HeartHandshake, Zap, Users } from "lucide-solid";
import CSRForm from "./components/CSRForm";

function unwrap(r) {
  return r?.[0]?.result ?? r?.[0] ?? [];
}

export default function CSRSystem() {
  const { setPageMeta, openDrawer } = useUI();
  createEffect(() => setPageMeta("CSR Activities", "csr"));

  const [search, setSearch] = createSignal("");
  const [statusFilter, setStatusFilter] = createSignal("Active");

  const csrQuery = createQuery(() => ({
    queryKey: ["esg_csr"],
    queryFn: async () => {
      const res = await fetchQuery(`
        SELECT 
          id, a_name, a_xp_reward, a_status, 
          a_category.a_name AS category_name,
          (SELECT VALUE total_qty FROM type::record('v_tx_to', [id, 1]))[0] AS participations
        FROM csr_activity 
        ORDER BY a_status ASC, a_name ASC;
      `);
      return unwrap(res);
    },
  }));

  const filteredCSR = createMemo(() => {
    let nodes = csrQuery.data || [];
    if (statusFilter() !== "All")
      nodes = nodes.filter((n) => n.a_status === statusFilter());
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
          placeholder="Query CSR initiatives..."
          class="input input-sm input-ghost w-full pl-9"
          value={search()}
          onInput={(e) => setSearch(e.target.value)}
        />
      </div>
      <div class="flex items-center gap-2">
        <select
          class="select select-sm select-bordered"
          value={statusFilter()}
          onChange={(e) => setStatusFilter(e.target.value)}
        >
          <option value="All">All States</option>
          <option value="Active">Active</option>
          <option value="Draft">Draft</option>
        </select>
        <button
          class="btn btn-sm btn-primary"
          onClick={() => openDrawer("Deploy CSR Initiative", () => <CSRForm />)}
        >
          <Plus size={16} /> <HeartHandshake size={16} /> New CSR
        </button>
      </div>
    </div>
  );

  return (
    <ModuleLayout
      tabs={[{ label: "Initiatives", href: "/csr", active: true }]}
      toolbar={Toolbar}
    >
      <div class="flex flex-col h-full overflow-y-auto layout-pad bg-base-200/30 gap-[var(--app-pad)]">
        <Show
          when={!csrQuery.isLoading}
          fallback={
            <div class="loading loading-spinner text-primary mx-auto"></div>
          }
        >
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-[var(--app-pad)]">
            {filteredCSR().map((csr) => (
              <div
                class={`card bg-base-100 shadow-sm border hover:shadow-md transition-all cursor-pointer group ${csr.a_status !== "Active" ? "opacity-70 border-base-300" : "border-primary/30 hover:border-primary"}`}
                onClick={() =>
                  openDrawer("Edit Initiative", () => <CSRForm baseCSR={csr} />)
                }
              >
                <div class="card-body p-4 flex flex-col gap-3">
                  <div class="flex items-center justify-between">
                    <span
                      class={`badge badge-sm ${csr.a_status === "Active" ? "badge-success" : "badge-ghost"}`}
                    >
                      {csr.a_status}
                    </span>
                    <span class="text-xs font-mono text-base-content/40">
                      {csr.category_name || "No Category"}
                    </span>
                  </div>
                  <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-box bg-success/10 flex items-center justify-center text-success shrink-0">
                      <HeartHandshake size={20} />
                    </div>
                    <div class="min-w-0 flex-1">
                      <h3 class="font-bold text-sm truncate group-hover:text-primary transition-colors">
                        {csr.a_name}
                      </h3>
                    </div>
                  </div>
                  <div class="grid grid-cols-2 gap-2 mt-2 pt-2 border-t border-base-200">
                    <div class="flex flex-col">
                      <span class="text-[10px] uppercase text-base-content/50 flex items-center gap-1">
                        <Zap size={10} /> Mint XP
                      </span>
                      <span class="font-mono font-bold text-success">
                        +{csr.a_xp_reward}
                      </span>
                    </div>
                    <div class="flex flex-col items-end">
                      <span class="text-[10px] uppercase text-base-content/50 flex items-center gap-1">
                        <Users size={10} /> Participations
                      </span>
                      <span class="font-mono font-bold text-info">
                        {csr.participations ?? 0}
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
