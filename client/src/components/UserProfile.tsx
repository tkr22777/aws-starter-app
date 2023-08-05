import React, { useEffect, useState } from "react";
import { getToken } from "../utils/token";
import { getUserProfile } from "../api/profile";

const UserProfile = () => {
  const [token, setToken] = useState("");
  const [setProfileData] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      const token = await getToken();
      setToken(token);
      const profile = getUserProfile();
      console.log("profile: " );
      console.log(profile);
    };

    fetchData();
  }, []);

  var profileData = {
    name: "change-name",
    email: "change-email",
  };

  console.log("token: " + token);
  return (
    <>
      <div>
        <h2>User Profile</h2>
      </div>
      <ul className="list-group">
        <li className="list-group-item">Token: {token}</li>
      </ul>
    </>
  );
};

export default UserProfile;
