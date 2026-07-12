import { createSignal, Show } from "solid-js";
import { useQueryClient } from "@tanstack/solid-query";
import { fetchQuery } from "../../../lib/surreal";
import { useUI } from "../../../store/ui";
import toast from "solid-toast";

export default function BadgeForm(props) {
  const { closeDrawer } = useUI();
  const qc = useQueryClient();
  const isUpdate = !!props.baseBadge;

  const [name, setName] = createSignal(isUpdate ? props.baseBadge.a_name : "");
  const [xp, setXp] = createSignal(
    isUpdate ? props.baseBadge.a_required_xp : 500,
  );
  const [status, setStatus] = createSignal(
    isUpdate ? props.baseBadge.a_status : "Active",
  );
  const [loading, setLoading] = createSignal(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    try {
      if (isUpdate) {
        await fetchQuery(
          `UPDATE type::thing($id) MERGE { a_name: $name, a_required_xp: $xp, a_status: $status };`,
          {
            id: props.baseBadge.id,
            name: name(),
            xp: Number(xp()),
            status: status(),
          },
        );
        toast.success("Badge updated.");
      } else {
        await fetchQuery(
          `CREATE badge SET a_name = $name, a_required_xp = $xp, a_status = $status;`,
          { name: name(), xp: Number(xp()), status: status() },
        );
        toast.success("Badge deployed.");
      }
      qc.invalidateQueries({ queryKey: ["esg_badges"] });
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
          <span class="label-text font-bold">Badge Name</span>
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
          <span class="label-text font-bold">Required Net XP (Threshold)</span>
        </label>
        <input
          type="number"
          class="input input-bordered font-mono text-warning"
          value={xp()}
          onInput={(e) => setXp(e.target.value)}
          min="1"
          step="1"
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
          class="btn btn-warning flex-1"
          disabled={loading()}
        >
          <Show when={loading()} fallback="Deploy Badge">
            <span class="loading loading-spinner"></span>
          </Show>
        </button>
      </div>
    </form>
  );
}
