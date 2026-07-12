import { createSignal, createResource, Show, For } from "solid-js";
import { useQueryClient } from "@tanstack/solid-query";
import { fetchQuery } from "../../../lib/surreal";
import { useUI } from "../../../store/ui";
import toast from "solid-toast";

function unwrap(r) {
  return r?.[0]?.result ?? r?.[0] ?? [];
}

export default function LedgerForm() {
  const { closeDrawer } = useUI();
  const qc = useQueryClient();

  // Field State
  const [fromUser, setFromUser] = createSignal("");
  const [targetTable, setTargetTable] = createSignal("reward");
  const [toTarget, setToTarget] = createSignal("");
  const [qty, setQty] = createSignal(1);
  const [status, setStatus] = createSignal("Posted"); // Defaults to posted for immediate vector math
  const [loading, setLoading] = createSignal(false);

  // Fetch all active users
  const [users] = createResource(async () => {
    return unwrap(
      await fetchQuery(`SELECT id, name FROM user WHERE login_access = true`),
    );
  });

  // Dynamically fetch targets based on selected table (L0/L1 anchors)
  const [targets] = createResource(targetTable, async (tb) => {
    if (!tb) return [];
    return unwrap(
      await fetchQuery(
        `SELECT id, a_name FROM type::table($tb) WHERE a_status = 'Active'`,
        { tb },
      ),
    );
  });

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      // Creation triggers internal guards natively in File 06.
      await fetchQuery(
        `
        CREATE esg_tx SET 
          a_from = type::thing($from), 
          a_to = type::thing($to), 
          a_qty = $qty, 
          a_status = $status;
      `,
        {
          from: fromUser(),
          to: toTarget(),
          qty: Number(qty()),
          status: status(),
        },
      );

      toast.success("Transaction accepted by graph vectors.");
      qc.invalidateQueries({ queryKey: ["esg_ledger"] });
      qc.invalidateQueries({ queryKey: ["dashboard_real_metrics"] });
      closeDrawer();
    } catch (err) {
      toast.error(err.message || "Mutation rejected by Matrix Guard.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} class="flex flex-col gap-5 h-full pb-4">
      <div class="bg-base-200/50 p-4 rounded-box border border-base-300 flex flex-col gap-4">
        <div class="form-control">
          <label class="label">
            <span class="label-text font-bold">Actor (From)</span>
          </label>
          <select
            class="select select-bordered"
            value={fromUser()}
            onChange={(e) => setFromUser(e.target.value)}
            required
          >
            <option value="" disabled>
              Select User Node...
            </option>
            <For each={users()}>
              {(u) => <option value={u.id}>{u.name}</option>}
            </For>
          </select>
        </div>

        <div class="form-control">
          <label class="label">
            <span class="label-text font-bold">Target Vector Type</span>
          </label>
          <div class="join w-full">
            <button
              type="button"
              class={`btn btn-sm join-item flex-1 ${targetTable() === "reward" ? "btn-active text-error" : ""}`}
              onClick={() => {
                setTargetTable("reward");
                setToTarget("");
              }}
            >
              Reward (-1)
            </button>
            <button
              type="button"
              class={`btn btn-sm join-item flex-1 ${targetTable() === "challenge" ? "btn-active text-success" : ""}`}
              onClick={() => {
                setTargetTable("challenge");
                setToTarget("");
              }}
            >
              Challenge (+1)
            </button>
            <button
              type="button"
              class={`btn btn-sm join-item flex-1 ${targetTable() === "csr_activity" ? "btn-active text-success" : ""}`}
              onClick={() => {
                setTargetTable("csr_activity");
                setToTarget("");
              }}
            >
              CSR (+1)
            </button>
          </div>
        </div>

        <div class="form-control">
          <label class="label">
            <span class="label-text font-bold">Specific Anchor (To)</span>
          </label>
          <select
            class="select select-bordered"
            value={toTarget()}
            onChange={(e) => setToTarget(e.target.value)}
            required
            disabled={targets.loading}
          >
            <option value="" disabled>
              Select Target Node...
            </option>
            <For each={targets()}>
              {(t) => <option value={t.id}>{t.a_name}</option>}
            </For>
          </select>
        </div>

        <div class="grid grid-cols-2 gap-4">
          <div class="form-control">
            <label class="label">
              <span class="label-text font-bold">Quantity / Multiplier</span>
            </label>
            <input
              type="number"
              class="input input-bordered font-mono"
              value={qty()}
              onInput={(e) => setQty(e.target.value)}
              min="0.01"
              step="0.01"
              required
            />
          </div>
          <div class="form-control">
            <label class="label">
              <span class="label-text font-bold">Initial State</span>
            </label>
            <select
              class="select select-bordered"
              value={status()}
              onChange={(e) => setStatus(e.target.value)}
            >
              <option value="Posted">Posted (Execute Math)</option>
              <option value="Draft">Draft (Hold)</option>
            </select>
          </div>
        </div>
      </div>

      <div class="mt-auto flex gap-3 pt-4 border-t border-base-300">
        <button
          type="button"
          class="btn btn-ghost flex-1"
          onClick={closeDrawer}
        >
          Abort
        </button>
        <button
          type="submit"
          class="btn btn-primary flex-1"
          disabled={loading() || !fromUser() || !toTarget()}
        >
          <Show when={loading()} fallback="Execute Vector Transaction">
            <span class="loading loading-spinner"></span>
          </Show>
        </button>
      </div>
    </form>
  );
}
