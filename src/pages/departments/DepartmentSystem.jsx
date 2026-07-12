import { createEffect, createSignal, createMemo, Show } from "solid-js";
import { createQuery } from "@tanstack/solid-query";
import { useUI } from "../../store/ui";
import { fetchQuery } from "../../lib/surreal";
import ModuleLayout from "../ModuleLayout";
import DepartmentToolbar from "./components/DepartmentToolbar";
import DepartmentGrid from "./components/DepartmentGrid";

export default function DepartmentSystem() {
  const { setPageMeta } = useUI();

  // Claim topological identity
  createEffect(() => setPageMeta("Departments (Groups)", "departments"));

  const [search, setSearch] = createSignal("");

  // --- NETWORK GRAPH (Strict ESG Group Query) ---
  const departmentsQuery = createQuery(() => ({
    queryKey: ["esg_departments"],
    queryFn: async () => {
      // Pulling the native RBAC group + The File 07 ESG Rollups (d1_net_xp, d2_total_co2e)
      const [groups] = await fetchQuery(`
        SELECT 
          id, name, created_at, role,
          d1_net_xp, d2_total_co2e 
        FROM groups 
        ORDER BY created_at DESC;
      `);
      return groups || [];
    },
  }));

  // --- O(1) MEMORY SLICER ---
  const filteredDepartments = createMemo(() => {
    let nodes = departmentsQuery.data || [];
    if (search().trim()) {
      const s = search().toLowerCase();
      nodes = nodes.filter((n) => n.name.toLowerCase().includes(s));
    }
    return nodes;
  });

  return (
    <ModuleLayout
      tabs={[
        { label: "Department Matrix", href: "/departments", active: true },
      ]}
      toolbar={() => (
        <DepartmentToolbar search={search} setSearch={setSearch} />
      )}
    >
      <div class="flex flex-col h-full overflow-y-auto layout-pad bg-base-200/30 gap-[var(--app-pad)]">
        <Show
          when={!departmentsQuery.isLoading}
          fallback={
            <div class="loading loading-spinner text-primary mx-auto mt-8"></div>
          }
        >
          <Show
            when={filteredDepartments().length > 0}
            fallback={
              <div class="flex items-center justify-center h-48 text-base-content/50 bg-base-100 rounded-box border border-base-300">
                <p class="font-bold">
                  No departments match the current filter.
                </p>
              </div>
            }
          >
            <DepartmentGrid departments={filteredDepartments()} />
          </Show>
        </Show>
      </div>
    </ModuleLayout>
  );
}
