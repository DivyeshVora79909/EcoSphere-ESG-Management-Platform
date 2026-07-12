import { Search, Plus, Gift } from "lucide-solid";
import { useUI } from "../../../store/ui";
import RewardForm from "./RewardForm";

export default function RewardToolbar(props) {
  const { openDrawer } = useUI();

  return (
    <div class="flex flex-col md:flex-row items-center justify-between gap-4 w-full">
      <div class="relative w-full md:max-w-sm">
        <Search
          class="absolute left-3 top-1/2 -translate-y-1/2 text-base-content/50"
          size={16}
        />
        <input
          type="text"
          placeholder="Query reward catalog..."
          class="input input-sm input-ghost w-full pl-9 focus:bg-base-200 focus:outline-none"
          value={props.search()}
          onInput={(e) => props.setSearch(e.target.value)}
        />
      </div>

      <div class="flex items-center gap-2">
        <select
          class="select select-sm select-bordered"
          value={props.status()}
          onChange={(e) => props.setStatus(e.target.value)}
        >
          <option value="All">All States</option>
          <option value="Active">Active</option>
          <option value="Draft">Draft</option>
          <option value="Archived">Archived</option>
        </select>

        <button
          class="btn btn-sm btn-primary"
          onClick={() => openDrawer("Deploy Reward", () => <RewardForm />)}
        >
          <Plus size={16} /> <Gift size={16} /> New Reward
        </button>
      </div>
    </div>
  );
}
