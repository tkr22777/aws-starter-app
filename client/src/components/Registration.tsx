import React, { useState } from "react";
import {
  CognitoUserPool,
  CognitoUserAttribute
} from "amazon-cognito-identity-js";
import { poolData } from "../utils/user_pool";

const userPool = new CognitoUserPool(poolData);

const Registration = () => {
  const [email, setEmail] = useState("");
  const [role, setRole] = useState("");
  const [password, setPassword] = useState("");

  const handleRegister = (event: React.FormEvent) => {
    event.preventDefault();

    const attributeList = [];
    attributeList.push(new CognitoUserAttribute({
      Name: "email",
      Value: email,
    }));


    attributeList.push(new CognitoUserAttribute({
      Name: "custom:role",
      Value: role,
    }));

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
    <form onSubmit={handleRegister}>
      <label>
        Email:
        <input
          type="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          placeholder="Email"
          required
        />
      </label>
      <br />
      <label>
        Password:
        <input
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          placeholder="Password"
          required
        />
      </label>
      <br />
      <label>
        Role:
        <input
          type="text"
          value={role}
          onChange={(e) => setRole(e.target.value)}
          placeholder="Role"
          required
        />
      </label>
      <br />
      <button type="submit">Register</button>
    </form>
  );
};

export default Registration;
