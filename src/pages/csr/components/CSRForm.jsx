import { createSignal, createResource, Show } from "solid-js";
import { useQueryClient } from "@tanstack/solid-query";
import { fetchQuery } from "../../../lib/surreal";
import { useUI } from "../../../store/ui";
import toast from "solid-toast";

function unwrap(r) {
  return r?.[0]?.result ?? r?.[0] ?? [];
}

export default function CSRForm(props) {
  const { closeDrawer } = useUI();
  const qc = useQueryClient();
  const isUpdate = !!props.baseCSR;

  const [name, setName] = createSignal(isUpdate ? props.baseCSR.a_name : "");
  const [xpReward, setXpReward] = createSignal(
    isUpdate ? props.baseCSR.a_xp_reward : 100,
  );
  const [status, setStatus] = createSignal(
    isUpdate ? props.baseCSR.a_status : "Active",
  );
  const [category, setCategory] = createSignal(
    isUpdate ? props.baseCSR.a_category?.id || "" : "",
  );
  const [loading, setLoading] = createSignal(false);

  // STRICT TAXONOMY: Only fetch categories meant for csr_activity
  const [categories] = createResource(async () => {
    return unwrap(
      await fetchQuery(
        `SELECT id, a_name FROM category WHERE a_target_table = 'csr_activity'`,
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
            a_name: $name, a_xp_reward: $xpReward, a_status: $status, a_category: ${catVal} 
          };
        `,
          {
            id: props.baseCSR.id,
            name: name(),
            xpReward: Number(xpReward()),
            status: status(),
          },
        );
        toast.success("Initiative updated.");
      } else {
        await fetchQuery(
          `
          CREATE csr_activity SET 
            a_name = $name, a_xp_reward = $xpReward, a_status = $status, a_category = ${catVal};
        `,
          { name: name(), xpReward: Number(xpReward()), status: status() },
        );
        toast.success("Initiative deployed.");
      }

      qc.invalidateQueries({ queryKey: ["esg_csr"] });
      closeDrawer();
    } catch (err) {
      toast.error(err.message || "Mutation rejected by graph taxonomy.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} class="flex flex-col gap-4 h-full pb-4">
      <div class="form-control">
        <label class="label">
          <span class="label-text font-bold">Initiative Name</span>
        </label>
        <input
          type="text"
          class="input input-bordered"
          value={name()}
          onInput={(e) => setName(e.target.value)}
          required
        />
      </div>

      <div class="form-control">
        <label class="label">
          <span class="label-text font-bold">XP Reward (Vector: +1)</span>
        </label>
        <input
          type="number"
          class="input input-bordered font-mono"
          value={xpReward()}
          onInput={(e) => setXpReward(e.target.value)}
          min="1"
          step="0.01"
          required
        />
      </div>

      <div class="grid grid-cols-2 gap-4">
        <div class="form-control">
          <label class="label">
            <span class="label-text font-bold">Taxonomy</span>
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
            <span class="label-text font-bold">State</span>
          </label>
          <select
            class="select select-bordered"
            value={status()}
            onChange={(e) => setStatus(e.target.value)}
          >
            <option value="Active">Active</option>
            <option value="Draft">Draft</option>
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
          <Show when={loading()} fallback="Deploy Initiative">
            <span class="loading loading-spinner"></span>
          </Show>
        </button>
      </div>
    </form>
  );
}
