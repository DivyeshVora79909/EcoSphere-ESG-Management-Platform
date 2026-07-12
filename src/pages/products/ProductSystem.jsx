import { createEffect, createSignal, createMemo, Show } from "solid-js";
import { createQuery } from "@tanstack/solid-query";
import { useUI } from "../../store/ui";
import { fetchQuery } from "../../lib/surreal";
import ModuleLayout from "../ModuleLayout";
import { Search, Plus, Box, Leaf, AlertTriangle } from "lucide-solid";
import ProductForm from "./components/ProductForm";

function unwrap(r) {
  return r?.[0]?.result ?? r?.[0] ?? [];
}

export default function ProductSystem() {
  const { setPageMeta, openDrawer } = useUI();
  createEffect(() => setPageMeta("Product ESG Profiles", "products"));

  const [search, setSearch] = createSignal("");
  const [statusFilter, setStatusFilter] = createSignal("Active");

  const profilesQuery = createQuery(() => ({
    queryKey: ["esg_profiles"],
    queryFn: async () => {
      const res = await fetchQuery(`
        SELECT 
          id, 
          a_product.a_name AS product_name,
          a_emission_factor.a_name AS ef_name,
          a_emission_factor.a_co2e_per_unit AS ef_rate,
          a_xp_penalty_per_unit,
          a_status,
          (SELECT VALUE total_co2e FROM type::record('v_tx_to', [id, -1]))[0] AS generated_co2e
        FROM product_esg_profile 
        ORDER BY a_status ASC, product_name ASC;
      `);
      return unwrap(res);
    },
  }));

  const filteredProfiles = createMemo(() => {
    let nodes = profilesQuery.data || [];
    if (statusFilter() !== "All")
      nodes = nodes.filter((n) => n.a_status === statusFilter());
    if (search().trim()) {
      const s = search().toLowerCase();
      nodes = nodes.filter((n) => n.product_name?.toLowerCase().includes(s));
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
          placeholder="Query ESG profiles..."
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
          onClick={() => openDrawer("Map ESG Profile", () => <ProductForm />)}
        >
          <Plus size={16} /> <Box size={16} /> New Profile
        </button>
      </div>
    </div>
  );

  return (
    <ModuleLayout
      tabs={[{ label: "Mapped Profiles", href: "/products", active: true }]}
      toolbar={Toolbar}
    >
      <div class="flex flex-col h-full overflow-y-auto layout-pad bg-base-200/30 gap-[var(--app-pad)]">
        <Show
          when={!profilesQuery.isLoading}
          fallback={
            <div class="loading loading-spinner text-primary mx-auto"></div>
          }
        >
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-[var(--app-pad)]">
            {filteredProfiles().map((prof) => (
              <div
                class={`card bg-base-100 shadow-sm border hover:shadow-md transition-all cursor-pointer group ${prof.a_status !== "Active" ? "opacity-70 border-base-300" : "border-primary/30 hover:border-primary"}`}
                onClick={() =>
                  openDrawer("Edit Profile", () => (
                    <ProductForm baseProfile={prof} />
                  ))
                }
              >
                <div class="card-body p-4 flex flex-col gap-3">
                  <div class="flex items-center justify-between">
                    <span
                      class={`badge badge-sm ${prof.a_status === "Active" ? "badge-success" : "badge-ghost"}`}
                    >
                      {prof.a_status}
                    </span>
                    <span class="text-xs font-mono text-base-content/50">
                      {prof.ef_name}
                    </span>
                  </div>
                  <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-box bg-error/10 flex items-center justify-center text-error shrink-0">
                      <Box size={20} />
                    </div>
                    <div class="min-w-0 flex-1">
                      <h3 class="font-bold text-sm truncate group-hover:text-primary transition-colors">
                        {prof.product_name || "Unnamed Product"}
                      </h3>
                      <p class="text-[10px] font-mono text-base-content/50 truncate">
                        Rate: {prof.ef_rate} kg/unit
                      </p>
                    </div>
                  </div>
                  <div class="grid grid-cols-2 gap-2 mt-2 pt-2 border-t border-base-200">
                    <div class="flex flex-col">
                      <span class="text-[10px] uppercase text-base-content/50 flex items-center gap-1">
                        <AlertTriangle size={10} /> XP Burn
                      </span>
                      <span class="font-mono font-bold text-error">
                        -{prof.a_xp_penalty_per_unit}
                      </span>
                    </div>
                    <div class="flex flex-col items-end">
                      <span class="text-[10px] uppercase text-base-content/50 flex items-center gap-1">
                        <Leaf size={10} /> Global CO2e
                      </span>
                      <span class="font-mono font-bold text-base-content">
                        {prof.generated_co2e ?? 0} kg
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
