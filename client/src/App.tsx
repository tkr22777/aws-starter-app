import React from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import Registration from "./components/Registration";
import SignIn from "./components/SignIn";
import UserProfile from "./components/UserProfile";
import Fun from "./components/Fun";
import Alert from "./components/Alert";
import ListGroupProps from "./components/ListGroupProps";
import SignOut from "./components/SignOut";

function App() {
  let items = ["New York", "San Francisco", "Dhaka", "Seattle"];
  const handleSelectItem = (item: string) => {
    console.log("item selected:" + item);
  };

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

            <Route path="/fun">
              <Fun />
            </Route>
            <Route path="/list-group-props">
              <ListGroupProps
                items={items}
                heading="Cities"
                onSelectItem={handleSelectItem}
              />
            </Route>
            <Route path="/alert">
              <Alert>
                <ListGroupProps
                  items={items}
                  heading="Cities"
                  onSelectItem={handleSelectItem}
                />
              </Alert>
            </Route>
          </Switch>
        </Router>
      </header>
    </div>
  );
}

export default App;
