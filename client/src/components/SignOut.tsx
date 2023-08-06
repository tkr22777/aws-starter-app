// src/components/SignOut.tsx
import React from "react";
import { CognitoUserPool } from "amazon-cognito-identity-js";
import { poolData } from "../utils/user_pool";

const userPool = new CognitoUserPool(poolData);

const SignOut = () => {
  const handleSignOut = () => {
    const cognitoUser = userPool.getCurrentUser();

    if (cognitoUser) {
      cognitoUser.signOut();
      alert("Signed out successfully");
      // Redirect or update your application state as needed
    } else {
      alert("No user is currently signed in");
    }
  };

  return (
    <div className="container mt-5">
      <div className="row justify-content-center">
        <div className="col-md-6 text-center">
          <h3 className="text-center mb-4">
            Are you sure you want to sign out?
          </h3>
          <button className="btn btn-primary" onClick={handleSignOut}>
            Sign Out
          </button>
        </div>
      </div>
    </div>
  );
};

export default SignOut;
