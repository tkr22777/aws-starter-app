import { useEffect, useState } from "react";
import { getToken } from "../utils/token";

const ViewToken = () => {
  const [token, setToken] = useState("");

  useEffect(() => {
    const fetchData = async () => {
      const token = await getToken();
      setToken(token);
    };
    fetchData();
  }, []);

  console.log("token: " + token);

  const decodeJWT = (token: string) => {
    try {
      const base64Url = token.split(".")[1];
      const base64 = base64Url.replace(/-/g, "+").replace(/_/g, "/");
      const payload = decodeURIComponent(
        atob(base64)
          .split("")
          .map((c) => "%" + ("00" + c.charCodeAt(0).toString(16)).slice(-2))
          .join("")
      );

      return JSON.parse(payload);
    } catch (error) {
      console.error("Invalid token:", error);
      return null;
    }
  };

  const decodedToken = decodeJWT(token);
  console.log(decodedToken);

  return (
    <div className="container">
      <div className="row justify-content-center">
        <div className="col-md-6 text-center">
          <h4 className="mb-4">JWT Token Content for User:</h4>
          <ul className="list-group">
            {decodedToken &&
              Object.entries(decodedToken).map(([key, value], index) => (
                <li key={index} className="list-group-item">
                  <strong>{key}:</strong> {JSON.stringify(value)}
                </li>
              ))}
          </ul>
        </div>
      </div>
    </div>
  );
};

export default ViewToken;
