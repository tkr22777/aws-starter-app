import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import SignUp from "./components/SignUp";
import SignIn from "./components/SignIn";
import ViewToken from "./components/ViewToken";
import SignOut from "./components/SignOut";
import ConfirmAccount from "./components/ConfirmAccount";

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <Router>
          <Switch>
            <Route path="">
              <ViewToken />
            </Route>
            <Route path="/sign-up">
              <SignUp />
            </Route>
            <Route path="/confirm">
              <ConfirmAccount/>
            </Route>
            <Route path="/sign-in">
              <SignIn />
            </Route>
            <Route path="/sign-out">
              <SignOut />
            </Route>
            <Route path="/jwt-token">
              <ViewToken />
            </Route>
          </Switch>
        </Router>
      </header>
    </div>
  );
}

export default App;
