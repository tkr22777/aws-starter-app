// src/components/SignOut.tsx
import React from 'react';
import { CognitoUserPool } from 'amazon-cognito-identity-js';
import { poolData } from '../utils/user_pool';

const userPool = new CognitoUserPool(poolData);

const SignOut = () => {
  const handleSignOut = () => {
    const cognitoUser = userPool.getCurrentUser();

    if (cognitoUser) {
      cognitoUser.signOut();
      alert('Signed out successfully');
      // Redirect or update your application state as needed
    } else {
      alert('No user is currently signed in');
    }
  };

  return (
    <button onClick={handleSignOut}>Sign Out</button>
  );
};

export default SignOut;

