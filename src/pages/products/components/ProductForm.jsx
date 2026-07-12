import { createSignal, createResource, Show, For } from "solid-js";
import { useQueryClient } from "@tanstack/solid-query";
import { fetchQuery } from "../../../lib/surreal";
import { useUI } from "../../../store/ui";
import toast from "solid-toast";

function unwrap(r) {
  return r?.[0]?.result ?? r?.[0] ?? [];
}

export default function ProductForm(props) {
  const { closeDrawer } = useUI();
  const qc = useQueryClient();
  const isUpdate = !!props.baseProfile;

  const [product, setProduct] = createSignal(
    isUpdate ? props.baseProfile.a_product : "",
  );
  const [emissionFactor, setEmissionFactor] = createSignal(
    isUpdate ? props.baseProfile.a_emission_factor : "",
  );
  const [xpPenalty, setXpPenalty] = createSignal(
    isUpdate ? props.baseProfile.a_xp_penalty_per_unit : 5,
  );
  const [status, setStatus] = createSignal(
    isUpdate ? props.baseProfile.a_status : "Active",
  );
  const [loading, setLoading] = createSignal(false);

  // Fetch underlying L0 Anchors
  const [products] = createResource(async () =>
    unwrap(
      await fetchQuery(
        `SELECT id, a_name FROM product WHERE a_status = 'Active'`,
      ),
    ),
  );
  const [factors] = createResource(async () =>
    unwrap(
      await fetchQuery(
        `SELECT id, a_name, a_co2e_per_unit FROM emission_factor WHERE a_status = 'Active'`,
      ),
    ),
  );

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      if (isUpdate) {
        await fetchQuery(
          `
          UPDATE type::thing($id) MERGE { 
            a_product: type::thing($product), 
            a_emission_factor: type::thing($ef), 
            a_xp_penalty_per_unit: $penalty, 
            a_status: $status 
          };
        `,
          {
            id: props.baseProfile.id,
            product: product(),
            ef: emissionFactor(),
            penalty: Number(xpPenalty()),
            status: status(),
          },
        );
        toast.success("Profile mapped updated.");
      } else {
        await fetchQuery(
          `
          CREATE product_esg_profile SET 
            a_product = type::thing($product), 
            a_emission_factor = type::thing($ef), 
            a_xp_penalty_per_unit = $penalty, 
            a_status = $status;
        `,
          {
            product: product(),
            ef: emissionFactor(),
            penalty: Number(xpPenalty()),
            status: status(),
          },
        );
        toast.success("ESG Profile mapped & deployed.");
      }

      qc.invalidateQueries({ queryKey: ["esg_profiles"] });
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
          <span class="label-text font-bold">Physical Product Node</span>
        </label>
        <select
          class="select select-bordered"
          value={product()}
          onChange={(e) => setProduct(e.target.value)}
          required
          disabled={isUpdate}
        >
          <option value="" disabled>
            Select Core Product...
          </option>
          <For each={products()}>
            {(p) => <option value={p.id}>{p.a_name}</option>}
          </For>
        </select>
      </div>

      <div class="form-control">
        <label class="label">
          <span class="label-text font-bold">Emission Factor Node</span>
        </label>
        <select
          class="select select-bordered"
          value={emissionFactor()}
          onChange={(e) => setEmissionFactor(e.target.value)}
          required
        >
          <option value="" disabled>
            Select Emission Baseline...
          </option>
          <For each={factors()}>
            {(f) => (
              <option value={f.id}>
                {f.a_name} ({f.a_co2e_per_unit} kg)
              </option>
            )}
          </For>
        </select>
      </div>

      <div class="grid grid-cols-2 gap-4">
        <div class="form-control">
          <label class="label">
            <span class="label-text font-bold">XP Penalty (Vector: -1)</span>
          </label>
          <input
            type="number"
            class="input input-bordered font-mono text-error"
            value={xpPenalty()}
            onInput={(e) => setXpPenalty(e.target.value)}
            min="0"
            step="0.01"
            required
          />
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
          disabled={loading() || !product() || !emissionFactor()}
        >
          <Show when={loading()} fallback="Map Nodes">
            <span class="loading loading-spinner"></span>
          </Show>
        </button>
      </div>
    </form>
  );
}
