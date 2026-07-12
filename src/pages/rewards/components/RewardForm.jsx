import { createSignal, createResource, Show } from "solid-js";
import { useQueryClient } from "@tanstack/solid-query";
import { fetchQuery } from "../../../lib/surreal";
import { useUI } from "../../../store/ui";
import toast from "solid-toast";

function unwrap(r) {
  return r?.[0]?.result ?? r?.[0] ?? [];
}

export default function RewardForm(props) {
  const { closeDrawer } = useUI();
  const qc = useQueryClient();
  const isUpdate = !!props.baseReward;

  const [name, setName] = createSignal(isUpdate ? props.baseReward.a_name : "");
  const [xpCost, setXpCost] = createSignal(
    isUpdate ? props.baseReward.a_xp_cost : 100,
  );
  const [stock, setStock] = createSignal(
    isUpdate ? props.baseReward.a_total_stock : 10,
  );
  const [status, setStatus] = createSignal(
    isUpdate ? props.baseReward.a_status : "Active",
  );
  const [category, setCategory] = createSignal(
    isUpdate ? props.baseReward.a_category?.id || "" : "",
  );
  const [loading, setLoading] = createSignal(false);

  // Fetch only categories meant for 'reward'
  const [categories] = createResource(async () => {
    return unwrap(
      await fetchQuery(
        `SELECT id, a_name FROM category WHERE a_target_table = 'reward'`,
      ),
    );
  });

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      const catVal = category() ? `type::thing('${category()}')` : `NONE`;
      if (isUpdate) {
        await fetchQuery(
          `
          UPDATE type::thing($id) MERGE { 
            a_name: $name, a_xp_cost: $xpCost, a_total_stock: $stock, a_status: $status, a_category: ${catVal} 
          };
        `,
          {
            id: props.baseReward.id,
            name: name(),
            xpCost: Number(xpCost()),
            stock: Number(stock()),
            status: status(),
          },
        );
        toast.success("Reward node updated.");
      } else {
        await fetchQuery(
          `
          CREATE reward SET 
            a_name = $name, a_xp_cost = $xpCost, a_total_stock = $stock, a_status = $status, a_category = ${catVal};
        `,
          {
            name: name(),
            xpCost: Number(xpCost()),
            stock: Number(stock()),
            status: status(),
          },
        );
        toast.success("Reward deployed.");
      }

      qc.invalidateQueries({ queryKey: ["esg_rewards"] });
      closeDrawer();
    } catch (err) {
      toast.error(err.message || "Mutation rejected by graph guards.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} class="flex flex-col gap-4 h-full pb-4">
      <div class="form-control">
        <label class="label">
          <span class="label-text font-bold">Reward Name</span>
        </label>
        <input
          type="text"
          class="input input-bordered"
          value={name()}
          onInput={(e) => setName(e.target.value)}
          required
        />
      </div>

      <div class="grid grid-cols-2 gap-4">
        <div class="form-control">
          <label class="label">
            <span class="label-text font-bold">XP Cost (Math Vector)</span>
          </label>
          <input
            type="number"
            class="input input-bordered font-mono"
            value={xpCost()}
            onInput={(e) => setXpCost(e.target.value)}
            min="1"
            step="0.01"
            required
          />
        </div>
        <div class="form-control">
          <label class="label">
            <span class="label-text font-bold">Total Stock (Physics)</span>
          </label>
          <input
            type="number"
            class="input input-bordered font-mono"
            value={stock()}
            onInput={(e) => setStock(e.target.value)}
            min="0"
            step="1"
            required
          />
        </div>
      </div>

      <div class="grid grid-cols-2 gap-4">
        <div class="form-control">
          <label class="label">
            <span class="label-text font-bold">Taxonomy Category</span>
          </label>
          <select
            class="select select-bordered"
            value={category()}
            onChange={(e) => setCategory(e.target.value)}
          >
            <option value="">No Category</option>
            <Show when={categories()}>
              {categories().map((c) => (
                <option value={c.id}>{c.a_name}</option>
              ))}
            </Show>
          </select>
        </div>
        <div class="form-control">
          <label class="label">
            <span class="label-text font-bold">Node Status</span>
          </label>
          <select
            class="select select-bordered"
            value={status()}
            onChange={(e) => setStatus(e.target.value)}
          >
            <option value="Active">Active</option>
            <option value="Draft">Draft</option>
            <option value="Archived">Archived</option>
          </select>
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
          disabled={loading()}
        >
          <Show when={loading()} fallback="Execute Mutation">
            <span class="loading loading-spinner"></span>
          </Show>
        </button>
      </div>
    </form>
  );
}
