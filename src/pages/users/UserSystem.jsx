import { createEffect, createSignal, createMemo, Show } from "solid-js";
import { createQuery } from "@tanstack/solid-query";
import { useUI } from "../../store/ui";
import { fetchQuery } from "../../lib/surreal";
import ModuleLayout from "../ModuleLayout";
import UserStats from "./components/UserStats";
import UserToolbar from "./components/UserToolbar";
import UserGrid from "./components/UserGrid";
import UserTable from "./components/UserTable";

export default function UserSystem() {
  const { setPageMeta } = useUI();

  // Claim topological identity
  createEffect(() => setPageMeta("Access & Users", "users"));

  // --- STATE MACHINES ---
  const [viewMode, setViewMode] = createSignal("grid");
  const [search, setSearch] = createSignal("");
  const [statusFilter, setStatusFilter] = createSignal("all");

  // --- NETWORK GRAPH (Strict RBAC Query) ---
  const usersQuery = createQuery(() => ({
    queryKey: ["rbac_users"],
    queryFn: async () => {
      const [users] = await fetchQuery(`
        SELECT 
          id, name, email, login_access, created_at, 
          total_suspensions, parents, dominates, permissions 
        FROM user 
        ORDER BY created_at DESC;
      `);
      return users || [];
    },
  }));

  // --- O(1) MEMORY SLICER ---
  const filteredUsers = createMemo(() => {
    let nodes = usersQuery.data || [];

    if (search().trim()) {
      const s = search().toLowerCase();
      nodes = nodes.filter(
        (n) =>
          n.name.toLowerCase().includes(s) || n.email.toLowerCase().includes(s),
      );
    }

    if (statusFilter() !== "all") {
      const isActive = statusFilter() === "active";
      nodes = nodes.filter((n) => n.login_access === isActive);
    }
    return nodes;
  });

  return (
    <ModuleLayout
      tabs={[{ label: "User Management", href: "/users", active: true }]}
    >
      <div class="flex flex-col h-full overflow-y-auto layout-pad bg-base-200/30 gap-[var(--app-pad)]">
        {/* Phase 2: Metrics */}
        <UserStats users={usersQuery.data || []} />

        {/* Phase 2: Controls */}
        <UserToolbar
          search={search}
          setSearch={setSearch}
          status={statusFilter}
          setStatus={setStatusFilter}
          viewMode={viewMode}
          setViewMode={setViewMode}
        />

        {/* Phase 3: The View Matrix */}
        <Show
          when={!usersQuery.isLoading}
          fallback={
            <div class="loading loading-spinner text-primary mx-auto mt-8"></div>
          }
        >
          <Show
            when={filteredUsers().length > 0}
            fallback={
              <div class="flex items-center justify-center h-48 text-base-content/50 bg-base-100 rounded-box border border-base-300">
                <p class="font-bold">
                  No users match the current filter matrix.
                </p>
              </div>
            }
          >
            <Show when={viewMode() === "grid"}>
              <UserGrid users={filteredUsers()} />
            </Show>
            <Show when={viewMode() === "table"}>
              <UserTable users={filteredUsers()} />
            </Show>
          </Show>
        </Show>
      </div>
    </ModuleLayout>
  );
}
