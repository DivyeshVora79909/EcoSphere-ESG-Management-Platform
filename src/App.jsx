import { lazy } from "solid-js";
import { Route } from "@solidjs/router";
import AuthGuard from "./components/AuthGuard";

const AuthLayout = lazy(() => import("./pages/auth/AuthLayout"));
const MainLayout = lazy(() => import("./pages/MainLayout"));

const Login = lazy(() => import("./pages/auth/Login"));
const Forgot = lazy(() => import("./pages/auth/Forgot"));
const Verify = lazy(() => import("./pages/auth/Verify"));
const SignUp = lazy(() => import("./pages/auth/SignUp"));

const Dashboard = lazy(() => import("./pages/Dashboard"));
const UserSystem = lazy(() => import("./pages/users/UserSystem"));
const DepartmentSystem = lazy(
  () => import("./pages/departments/DepartmentSystem"),
);

// New ESG Modules
const RewardSystem = lazy(() => import("./pages/rewards/RewardSystem"));
const ChallengeSystem = lazy(
  () => import("./pages/challenges/ChallengeSystem"),
);
const LedgerSystem = lazy(() => import("./pages/ledger/LedgerSystem"));

export default function App() {
  return (
    <>
      <Route path="/auth" component={AuthLayout}>
        <Route path="/login" component={Login} />
        <Route path="/signup" component={SignUp} />
        <Route path="/forgot" component={Forgot} />
        <Route path="/verify" component={Verify} />
      </Route>

      <Route path="/" component={AuthGuard}>
        <Route path="/" component={MainLayout}>
          <Route path="/" component={Dashboard} />
          <Route path="/users" component={UserSystem} />
          <Route path="/departments" component={DepartmentSystem} />
          <Route path="/rewards" component={RewardSystem} />
          <Route path="/challenges" component={ChallengeSystem} />
          <Route path="/ledger" component={LedgerSystem} />
        </Route>
      </Route>
    </>
  );
}
