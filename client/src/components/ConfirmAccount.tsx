import React, { useState } from 'react';
import { CognitoUser, CognitoUserPool } from 'amazon-cognito-identity-js';
import { poolData } from '../utils/user_pool';
import 'bootstrap/dist/css/bootstrap.min.css';

const ConfirmAccount = () => {
  const [code, setCode] = useState<string>('');
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<boolean>(false);

  const onSubmit = (event: React.FormEvent) => {
    event.preventDefault();

    if (!code) {
      setError('Confirmation code is required.');
      return;
    }

    const userPool = new CognitoUserPool(poolData);
    const userData = {
      Username: "tahsinkabir@gmail.com",
      Pool: userPool,
    };

    const cognitoUser = new CognitoUser(userData);

    cognitoUser.confirmRegistration(code, true, (err, result) => {
      if (err) {
        setError(err.message || JSON.stringify(err));
        return;
      }
      setSuccess(true);
    });
  };

  return (
    <div className="container mt-5">
      <div className="row justify-content-center">
        <div className="col-md-6">
          <h3 className="text-center mb-4">Confirm Your Account</h3>
          {error && <div className="alert alert-danger">{error}</div>}
          {success ? (
            <div className="alert alert-success">Account confirmed! You may now sign in.</div>
          ) : (
            <form onSubmit={onSubmit}>
              <div className="mb-3">
                <label htmlFor="code" className="form-label">
                  Confirmation Code
                </label>
                <input
                  type="text"
                  className="form-control"
                  id="code"
                  value={code}
                  onChange={(e) => setCode(e.target.value)}
                />
              </div>
              <button type="submit" className="btn btn-primary w-100">
                Confirm Account
              </button>
            </form>
          )}
        </div>
      </div>
    </div>
  );
};

export default ConfirmAccount;

