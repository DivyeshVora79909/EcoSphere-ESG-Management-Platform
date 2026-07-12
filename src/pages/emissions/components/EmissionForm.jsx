import { createSignal, createResource, Show } from "solid-js";
import { useQueryClient } from "@tanstack/solid-query";
import { fetchQuery } from "../../../lib/surreal";
import { useUI } from "../../../store/ui";
import toast from "solid-toast";

function unwrap(r) {
  return r?.[0]?.result ?? r?.[0] ?? [];
}

export default function EmissionForm(props) {
  const { closeDrawer } = useUI();
  const qc = useQueryClient();
  const isUpdate = !!props.baseFactor;

  const [name, setName] = createSignal(isUpdate ? props.baseFactor.a_name : "");
  const [rate, setRate] = createSignal(
    isUpdate ? props.baseFactor.a_co2e_per_unit : 1,
  );
  const [status, setStatus] = createSignal(
    isUpdate ? props.baseFactor.a_status : "Active",
  );
  const [category, setCategory] = createSignal(
    isUpdate ? props.baseFactor.a_category?.id || "" : "",
  );
  const [loading, setLoading] = createSignal(false);

  const [categories] = createResource(async () => {
    return unwrap(
      await fetchQuery(
        `SELECT id, a_name FROM category WHERE a_target_table = 'emission_factor'`,
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
            a_name: $name, a_co2e_per_unit: $rate, a_status: $status, a_category: ${catVal} 
          };
        `,
          {
            id: props.baseFactor.id,
            name: name(),
            rate: Number(rate()),
            status: status(),
          },
        );
        toast.success("Factor updated.");
      } else {
        await fetchQuery(
          `
          CREATE emission_factor SET 
            a_name = $name, a_co2e_per_unit = $rate, a_status = $status, a_category = ${catVal};
        `,
          { name: name(), rate: Number(rate()), status: status() },
        );
        toast.success("Factor deployed.");
      }
      qc.invalidateQueries({ queryKey: ["esg_emissions"] });
      closeDrawer();
    } catch (err) {
      toast.error(err.message || "Mutation rejected.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} class="flex flex-col gap-4 h-full pb-4">
      <div class="form-control">
        <label class="label">
          <span class="label-text font-bold">Factor Name</span>
        </label>
        <input
          type="text"
          class="input input-bordered"
          value={name()}
          onInput={(e) => setName(e.target.value)}
          required
          placeholder="e.g. Diesel Fuel (Liters)"
        />
      </div>
      <div class="form-control">
        <label class="label">
          <span class="label-text font-bold">CO2e per Unit (kg)</span>
        </label>
        <input
          type="number"
          class="input input-bordered font-mono text-error"
          value={rate()}
          onInput={(e) => setRate(e.target.value)}
          min="0"
          step="0.001"
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
          <Show when={loading()} fallback="Deploy Node">
            <span class="loading loading-spinner"></span>
          </Show>
        </button>
      </div>
    </form>
  );
}
