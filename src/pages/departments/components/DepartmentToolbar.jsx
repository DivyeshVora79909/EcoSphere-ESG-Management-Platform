import { Search, Plus, Building2 } from "lucide-solid";
import { useUI } from "../../../store/ui";
import DepartmentForm from "./DepartmentForm";

export default function DepartmentToolbar(props) {
  const { openDrawer } = useUI();

  return (
    <div class="flex items-center gap-4 w-full">
      <div class="relative w-full max-w-sm">
        <Search
          class="absolute left-3 top-1/2 -translate-y-1/2 text-base-content/50"
          size={16}
        />
        <input
          type="text"
          placeholder="Query department..."
          class="input input-sm input-ghost w-full pl-9 focus:bg-base-200 focus:outline-none"
          value={props.search()}
          onInput={(e) => props.setSearch(e.target.value)}
        />
      </div>

      <button
        class="btn btn-sm btn-primary ml-auto"
        onClick={() =>
          openDrawer("Deploy Department", () => <DepartmentForm />)
        }
      >
        <Plus size={16} /> <Building2 size={16} /> New Dept
      </button>
    </div>
  );
}
