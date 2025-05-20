import React from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import SignUp from "./components/SignUp";
import Registration from "./components/Registration";
import SignIn from "./components/SignIn";
import ViewToken from "./components/ViewToken";
import UserProfile from "./components/UserProfile";
import Fun from "./components/Fun";
import Alert from "./components/Alert";
import ListGroupProps from "./components/ListGroupProps";
import SignOut from "./components/SignOut";
import ConfirmAccount from "./components/ConfirmAccount";

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
            <Route path="/" exact>
              <ViewToken />
            </Route>
            
            {/* Authentication Routes */}
            <Route path="/sign-up">
              <SignUp />
            </Route>
            <Route path="/register">
              <Registration />
            </Route>
            <Route path="/confirm">
              <ConfirmAccount />
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
            
            {/* Profile Routes */}
            <Route path="/profile">
              <UserProfile />
            </Route>
            
            {/* UI Demo Routes */}
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
