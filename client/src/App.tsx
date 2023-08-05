import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import Registration from "./components/Registration";
import SignIn from "./components/SignIn";
import UserProfile from "./components/UserProfile";
import SignOut from "./components/SignOut";

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <Router>
          <Switch>
            <Route path="/register">
              <Registration />
            </Route>
            <Route path="/login">
              <SignIn />
            </Route>
            <Route path="/logout">
              <SignOut />
            </Route>
            <Route path="/profile">
              <UserProfile />
            </Route>
          </Switch>
        </Router>
      </header>
    </div>
  );
}

export default App;
