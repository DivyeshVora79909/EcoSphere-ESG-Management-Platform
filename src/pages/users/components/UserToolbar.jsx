import { Search, LayoutGrid, List, Plus } from "lucide-solid";
import { useUI } from "../../../store/ui";
import UserForm from "./UserForm";

export default function UserToolbar(props) {
  const { openDrawer } = useUI();

  return (
    <div class="flex flex-col md:flex-row items-center justify-between gap-4 bg-base-100 p-2 rounded-box border border-base-300 shadow-sm">
      {/* Search Vector */}
      <div class="relative w-full md:max-w-sm">
        <Search
          class="absolute left-3 top-1/2 -translate-y-1/2 text-base-content/50"
          size={16}
        />
        <input
          type="text"
          placeholder="Query user identity or email..."
          class="input input-sm input-ghost w-full pl-9 focus:bg-base-200 focus:outline-none"
          value={props.search()}
          onInput={(e) => props.setSearch(e.target.value)}
        />
      </div>

      {/* Action Controls */}
      <div class="flex items-center gap-2 w-full md:w-auto overflow-x-auto">
        {/* State Filter */}
        <div class="join bg-base-200 p-1 rounded-btn">
          <button
            class={`btn btn-xs join-item ${props.status() === "all" ? "btn-active" : "btn-ghost"}`}
            onClick={() => props.setStatus("all")}
          >
            All
          </button>
          <button
            class={`btn btn-xs join-item ${props.status() === "active" ? "btn-active text-success" : "btn-ghost"}`}
            onClick={() => props.setStatus("active")}
          >
            Active
          </button>
          <button
            class={`btn btn-xs join-item ${props.status() === "suspended" ? "btn-active text-error" : "btn-ghost"}`}
            onClick={() => props.setStatus("suspended")}
          >
            Suspended
          </button>
        </div>

        {/* View Toggles */}
        <div class="join bg-base-200 p-1 rounded-btn">
          <button
            class={`btn btn-xs join-item px-2 ${props.viewMode() === "grid" ? "btn-active" : "btn-ghost"}`}
            onClick={() => props.setViewMode("grid")}
            title="Grid View"
          >
            <LayoutGrid size={14} />
          </button>
          <button
            class={`btn btn-xs join-item px-2 ${props.viewMode() === "table" ? "btn-active" : "btn-ghost"}`}
            onClick={() => props.setViewMode("table")}
            title="Table View"
          >
            <List size={14} />
          </button>
        </div>

        {/* Deploy Form Trigger */}
        <button
          class="btn btn-sm btn-primary ml-auto"
          onClick={() => openDrawer("Deploy User", () => <UserForm />)}
        >
          <Plus size={16} /> New User
        </button>
      </div>
    </div>
  );
}
