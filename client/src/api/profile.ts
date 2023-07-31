import axios from 'axios'; 
import { CognitoUser, CognitoUserPool, CognitoUserSession, CognitoUserAttribute } from 'amazon-cognito-identity-js';
import { poolData } from '../utils/user_pool';

const userPool = new CognitoUserPool(poolData);

export const getUserProfile = async () => {
  const cognitoUser = userPool.getCurrentUser();

  if (cognitoUser != null) {
    cognitoUser.getSession(async function(err: Error|null, session: CognitoUserSession|null) {
      if (err) {
        alert(err.message || JSON.stringify(err));
        return;
      }
      if (session && session.isValid()) {
        const token = session.getIdToken().getJwtToken();
        try {
          const response = await axios.get('/api/profile', {
            headers: { Authorization: `Bearer ${token}` }
          });
          return response.data;
        } catch (error) {
          throw error;
        }
      }
    });
  }
}