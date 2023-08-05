import { useEffect, useState } from "react";
import { getToken } from "../utils/token";

const UserProfile = () => {
  const [token, setToken] = useState("");

  useEffect(() => {
    const fetchData = async () => {
      const token = await getToken();
      setToken(token);
    };
    fetchData();
  }, []);

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
