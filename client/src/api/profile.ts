import axios from 'axios'; 
import { CognitoUser, CognitoUserPool, CognitoUserSession, CognitoUserAttribute } from 'amazon-cognito-identity-js';
import { poolData } from '../utils/user_pool';

const userPool = new CognitoUserPool(poolData);

export const getUserProfile = () => {
  const cognitoUser = userPool.getCurrentUser();

  if (cognitoUser != null) {
    console.log("Current user:");
    console.log(cognitoUser);
  };

  return "some-profile"
}