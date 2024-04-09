import {
  CognitoUserPool,
  CognitoUserSession,
} from "amazon-cognito-identity-js";
import { poolData } from "./user_pool";

const userPool = new CognitoUserPool(poolData);

export const getToken = (): Promise<string> => {
  return new Promise((resolve, reject) => {
    const cognitoUser = userPool.getCurrentUser();
    console.log("Cognito User");
    console.log(cognitoUser);
    if (cognitoUser !== null) {
      cognitoUser.getSession(
        (err: Error | null, session: CognitoUserSession | null) => {
          if (err) {
            reject(err);
            return;
          }
          if (session && session.isValid()) {
            resolve(session.getIdToken().getJwtToken());
          } else {
            reject(new Error("Session is invalid"));
          }
        }
      );
    } else {
      reject(new Error("User is not logged in"));
    }
  });
};
