import React, { useState } from "react";
import {
  CognitoUserPool,
  CognitoUserAttribute,
} from "amazon-cognito-identity-js";
import { poolData } from "../utils/user_pool";

const userPool = new CognitoUserPool(poolData);

const SignUp = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const handleRegister = (event: React.FormEvent) => {
    event.preventDefault();

    const attributeList = [];
    attributeList.push(
      new CognitoUserAttribute({
        Name: "email",
        Value: email,
      })
    );

    attributeList.push(
      new CognitoUserAttribute({
        Name: "custom:role",
        Value: "user",
      })
    );

    userPool.signUp(email, password, attributeList, [], function (err, result) {
      if (err) {
        alert(err.message || JSON.stringify(err));
        return;
      }
      alert(
        `User: ${email} was created successfully. Result: ${JSON.stringify(
          result
        )}`
      );
    });
  };

  return (
    <div className="container mt-5">
      <div className="row justify-content-center">
        <div className="col-md-6">
          <h3 className="text-center mb-4">Register</h3>
          <form onSubmit={handleRegister}>
            <div className="mb-3">
              <label htmlFor="email" className="form-label">
                Email address
              </label>
              <input
                type="email"
                className="form-control"
                id="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
              />
            </div>
            <div className="mb-3">
              <label htmlFor="password" className="form-label">
                Password
              </label>
              <input
                type="password"
                className="form-control"
                id="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
              />
            </div>
            <button type="submit" className="btn btn-primary w-100">
              Register
            </button>
          </form>
        </div>
      </div>
    </div>
  );
};

export default SignUp;