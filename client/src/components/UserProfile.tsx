import React, { useEffect, useState } from 'react';
import { getToken } from '../utils/token';
import { getUserProfile } from '../api/profile';

const UserProfile = () => {
  const [token, setToken] = useState('');
  const [setProfileData] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      const token = await getToken();
      setToken(token);
      // const profile = await getUserProfile();
      // setProfileData(profile);
    };

    fetchData();
  }, []);

  var profileData = {
    name: "change-name",
    email: "change-email"
  }

  console.log("token: " + token)

  /*
  return (
    <div>
      <h2>User Profile</h2>
      {profileData && (
        <>
          <p>Name: {profileData.name}</p>
          <p>Email: {profileData.email}</p>
        </>
      )}
    </div>
  );
  */

  return (
    <div>
      <h2>User Profile</h2>
      <p>Token: {token}</p>
    </div>
  );
};

export default UserProfile;
