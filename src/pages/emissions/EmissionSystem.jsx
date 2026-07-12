import { createEffect, createSignal, createMemo, Show } from "solid-js";
import { createQuery } from "@tanstack/solid-query";
import { useUI } from "../../store/ui";
import { fetchQuery } from "../../lib/surreal";
import ModuleLayout from "../ModuleLayout";
import { Search, Plus, Factory, Cloud } from "lucide-solid";
import EmissionForm from "./components/EmissionForm";

function unwrap(r) {
  return r?.[0]?.result ?? r?.[0] ?? [];
}

export default function EmissionSystem() {
  const { setPageMeta, openDrawer } = useUI();
  createEffect(() => setPageMeta("Emission Factors", "emissions"));

  const [search, setSearch] = createSignal("");
  const [statusFilter, setStatusFilter] = createSignal("Active");

  const emissionQuery = createQuery(() => ({
    queryKey: ["esg_emissions"],
    queryFn: async () => {
      const res = await fetchQuery(`
        SELECT 
          id, a_name, a_co2e_per_unit, a_status,
          a_category.a_name AS category_name
        FROM emission_factor 
        ORDER BY a_status ASC, a_name ASC;
      `);
      return unwrap(res);
    },
  }));

  const filteredEmissions = createMemo(() => {
    let nodes = emissionQuery.data || [];
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
          placeholder="Query factors..."
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
          onClick={() => openDrawer("Deploy Factor", () => <EmissionForm />)}
        >
          <Plus size={16} /> <Factory size={16} /> New Factor
        </button>
      </div>
    </div>
  );

  return (
    <ModuleLayout
      tabs={[{ label: "Global Multipliers", href: "/emissions", active: true }]}
      toolbar={Toolbar}
    >
      <div class="flex flex-col h-full overflow-y-auto layout-pad bg-base-200/30 gap-[var(--app-pad)]">
        <Show
          when={!emissionQuery.isLoading}
          fallback={
            <div class="loading loading-spinner text-primary mx-auto"></div>
          }
        >
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-[var(--app-pad)]">
            {filteredEmissions().map((ef) => (
              <div
                class={`card bg-base-100 shadow-sm border hover:shadow-md transition-all cursor-pointer group ${ef.a_status !== "Active" ? "opacity-70 border-base-300" : "border-primary/30 hover:border-primary"}`}
                onClick={() =>
                  openDrawer("Edit Factor", () => (
                    <EmissionForm baseFactor={ef} />
                  ))
                }
              >
                <div class="card-body p-4 flex flex-col gap-3">
                  <div class="flex items-center justify-between">
                    <span
                      class={`badge badge-sm ${ef.a_status === "Active" ? "badge-success" : "badge-ghost"}`}
                    >
                      {ef.a_status}
                    </span>
                    <span class="text-xs font-mono text-base-content/40">
                      {ef.category_name || "No Category"}
                    </span>
                  </div>
                  <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-box bg-error/10 flex items-center justify-center text-error shrink-0">
                      <Cloud size={20} />
                    </div>
                    <div class="min-w-0 flex-1">
                      <h3 class="font-bold text-sm truncate group-hover:text-primary transition-colors">
                        {ef.a_name}
                      </h3>
                    </div>
                  </div>
                  <div class="mt-2 pt-2 border-t border-base-200 flex flex-col">
                    <span class="text-[10px] uppercase text-base-content/50 flex items-center gap-1">
                      Multiplier Rate
                    </span>
                    <span class="font-mono font-bold text-error">
                      {ef.a_co2e_per_unit} kg CO2e / unit
                    </span>
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
