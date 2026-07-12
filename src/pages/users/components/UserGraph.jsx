import { createSignal, createMemo, For, Show, onMount } from "solid-js";
import { createQuery, useQueryClient } from "@tanstack/solid-query";
import { fetchQuery } from "../../../lib/surreal";
import { useUI } from "../../../store/ui";
import UserProfile from "./UserProfile";
import toast from "solid-toast";

function unwrap(r) {
  return r?.[0]?.result ?? r?.[0] ?? [];
}

export default function UserGraph() {
  const { openDrawer } = useUI();
  const qc = useQueryClient();
  const [selected, setSelected] = createSignal(null);
  const [linkMode, setLinkMode] = createSignal(null); // {from}
  const [scale, setScale] = createSignal(1);

  const graphQuery = createQuery(() => ({
    queryKey: ["rbac_graph"],
    queryFn: async () => {
      const [users, groups, links] = await Promise.all([
        fetchQuery(`SELECT id, name, email, login_access FROM user`),
        fetchQuery(`SELECT id, name FROM groups`),
        fetchQuery(`SELECT in, out FROM link`),
      ]);
      return {
        users: unwrap(users),
        groups: unwrap(groups),
        links: unwrap(links),
      };
    },
  }));

  const layout = createMemo(() => {
    const data = graphQuery.data;
    if (!data) return { nodes: [], edges: [] };
    const nodes = [
      ...data.groups.map((g) => ({ ...g, kind: "group" })),
      ...data.users.map((u) => ({ ...u, kind: "user" })),
    ];
    const idToNode = Object.fromEntries(nodes.map((n) => [String(n.id), n]));
    const indeg = {};
    nodes.forEach((n) => (indeg[String(n.id)] = 0));
    data.links.forEach((l) => {
      const t = String(l.out);
      if (indeg[t] !== undefined) indeg[t]++;
    });
    const levels = {};
    const queue = nodes
      .filter((n) => indeg[String(n.id)] === 0)
      .map((n) => ({ id: String(n.id), d: 0 }));
    const visited = new Set();
    let maxD = 0;
    while (queue.length) {
      const { id, d } = queue.shift();
      if (visited.has(id)) continue;
      visited.add(id);
      levels[id] = d;
      maxD = Math.max(maxD, d);
      const outs = data.links
        .filter((l) => String(l.in) === id)
        .map((l) => String(l.out));
      outs.forEach((o) => {
        if (!visited.has(o)) queue.push({ id: o, d: d + 1 });
      });
    }
    const byLevel = {};
    Object.entries(levels).forEach(([id, d]) => {
      (byLevel[d] = byLevel[d] || []).push(id);
    });
    const positioned = nodes.map((n) => {
      const lvl = levels[String(n.id)] ?? maxD + 1;
      const idx = (byLevel[lvl] || []).indexOf(String(n.id));
      return { ...n, x: lvl * 300 + 80, y: idx * 110 + 80, level: lvl };
    });
    return {
      nodes: positioned,
      edges: data.links,
      idToNode: Object.fromEntries(positioned.map((n) => [String(n.id), n])),
    };
  });

  const handleNodeClick = (n) => {
    if (linkMode()?.from) {
      const from = linkMode().from;
      if (String(from.id) === String(n.id)) {
        setLinkMode(null);
        return;
      }
      fetchQuery(`RELATE $from -> link -> $to`, { from: from.id, to: n.id })
        .then(() => {
          toast.success(`Linked ${from.name} → ${n.name}`);
          setLinkMode(null);
          qc.invalidateQueries({ queryKey: ["rbac_graph"] });
          qc.invalidateQueries({ queryKey: ["rbac_users"] });
        })
        .catch((e) => toast.error(e.message));
      return;
    }
    setSelected(n);
    if (n.kind === "user")
      openDrawer("Node Inspector", () => <UserProfile baseUser={n} />, "lg");
  };

  return (
    <div class="relative w-full h- bg-base-100 border rounded-box overflow-hidden">
      <div class="absolute top-2 left-2 z-20 flex gap-2">
        <button
          class={`btn btn-sm ${linkMode() ? "btn-primary" : "btn-outline"}`}
          onClick={() => setLinkMode(linkMode() ? null : { from: null })}
        >
          {linkMode() ? "Cancel Link" : "Create Link"}
        </button>
        <button
          class="btn btn-sm btn-ghost"
          onClick={() => setScale((s) => Math.min(1.6, s + 0.1))}
        >
          +
        </button>
        <button
          class="btn btn-sm btn-ghost"
          onClick={() => setScale((s) => Math.max(0.5, s - 0.1))}
        >
          -
        </button>
        <Show when={linkMode()}>
          <span class="badge badge-info badge-sm mt-1">
            {linkMode().from
              ? `Select target for ${linkMode().from.name}`
              : "Select source node"}
          </span>
        </Show>
      </div>

      <Show
        when={!graphQuery.isLoading}
        fallback={
          <div class="grid place-items-center h-full">
            <span class="loading loading-spinner loading-lg" />
          </div>
        }
      >
        <div
          class="w-full h-full overflow-auto bg-[radial-gradient(circle_at_1px_1px,theme(colors.base-300)_1px,transparent_0)] bg-[size:24px_24px]"
          style={{
            transform: `scale(${scale()})`,
            "transform-origin": "0 0",
            width: `${100 / scale()}%`,
            height: `${100 / scale()}%`,
          }}
        >
          <svg class="absolute inset-0 w- h- pointer-events-none">
            <For each={layout().edges}>
              {(e) => {
                const a = layout().idToNode[String(e.in)];
                const b = layout().idToNode[String(e.out)];
                if (!a || !b) return null;
                return (
                  <path
                    d={`M ${a.x + 48} ${a.y + 20} C ${a.x + 180} ${a.y + 20}, ${b.x - 60} ${b.y + 20}, ${b.x} ${b.y + 20}`}
                    fill="none"
                    stroke="hsl(var(--bc)/0.2)"
                    stroke-width="1.5"
                    marker-end="url(#arrow)"
                  />
                );
              }}
            </For>
            <defs>
              <marker
                id="arrow"
                viewBox="0 0 10 10"
                refX="10"
                refY="5"
                markerWidth="6"
                markerHeight="6"
                orient="auto-start-reverse"
              >
                <path d="M 0 0 L 10 5 L 0 10 z" fill="hsl(var(--bc)/0.3)" />
              </marker>
            </defs>
          </svg>

          <For each={layout().nodes}>
            {(n) => (
              <div
                class={`absolute w-48 h-14 rounded-box border-2 bg-base-100 shadow-sm flex items-center gap-2 px-3 cursor-pointer select-none transition hover:shadow-md hover:border-primary ${selected()?.id === n.id ? "border-primary ring-2 ring-primary/20" : n.kind === "group" ? "border-secondary/50" : n.login_access === false ? "border-error/60" : "border-base-300"}`}
                style={{ left: `${n.x}px`, top: `${n.y}px` }}
                onClick={() => {
                  if (!linkMode()?.from) handleNodeClick(n);
                  else if (!linkMode().from) setLinkMode({ from: n });
                  else handleNodeClick(n);
                }}
                onDblClick={() => {
                  if (!linkMode()) setLinkMode({ from: n });
                }}
              >
                <div
                  class={`w-8 h-8 rounded-full grid place-items-center text-xs font-black ${n.kind === "group" ? "bg-secondary text-secondary-content" : "bg-primary/15"}`}
                >
                  {n.name[0]}
                </div>
                <div class="min-w-0 flex-1">
                  <div class="text-xs font-bold truncate">{n.name}</div>
                  <div class="text- opacity-50 truncate">{String(n.id)}</div>
                </div>
              </div>
            )}
          </For>
        </div>
      </Show>
    </div>
  );
}
