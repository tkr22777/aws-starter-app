type UserSettings = {
  user_id: string;
  setting_1: string;
  setting_2: number;
  setting_3: boolean;
};

const API_ENDPOINT = "http://localhost:80" // "https://your-backend-service-url.com"; // Replace with your backend service URL

class UserSettingsService {

  private static async fetchWithToken(
    endpoint: string,
    jwtToken: string,
    method: string,
    body?: any
  ) {
    const headers: Record<string, string> = {
      Authorization: `Bearer ${jwtToken}`,
      "Content-Type": "application/json",
    };

    const config: RequestInit = {
      method: method,
      headers: headers,
      body: body ? JSON.stringify(body) : undefined,
    };

    const response = await fetch(endpoint, config);

    if (!response.ok) {
      const errorMessage = await response.text();
      throw new Error(errorMessage);
    }

    return response.json();
  }

  static async createUserSetting(jwtToken: string, userSetting: UserSettings) {
    const endpoint = `${API_ENDPOINT}/v1/usersettings`; // Update endpoint if different
    return this.fetchWithToken(endpoint, jwtToken, "POST", userSetting);
  }

  static async getUserSetting(jwtToken: string, userId: string) {
    const endpoint = `${API_ENDPOINT}/v1/usersettings/${userId}`;
    return this.fetchWithToken(endpoint, jwtToken, "GET");
  }

  static async updateUserSetting(
    jwtToken: string,
    userId: string,
    userSetting: UserSettings
  ) {
    const endpoint = `${API_ENDPOINT}/v1/usersettings/${userId}`;
    return this.fetchWithToken(endpoint, jwtToken, "PUT", userSetting);
  }

  static async deleteUserSetting(jwtToken: string, userId: string) {
    const endpoint = `${API_ENDPOINT}/v1/usersettings/${userId}`;
    return this.fetchWithToken(endpoint, jwtToken, "DELETE");
  }
}

export default UserSettingsService;
