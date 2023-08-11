import requests
from models.usersettings import UserSettings

headers = { "Authorization": "Bearer BYPASS_TOKEN" }

# dependencies must, first be ran: docker-compose up --build
def test_usersettings_api():
    base_url = "http://localhost:8000/v1/usersettings"

    # CREATE
    user_settings = UserSettings(user_id="uid_101", setting_1="s1", setting_2=1, setting_3=False)
    response = requests.post(f"{base_url}/", headers=headers, json=user_settings.model_dump())
    assert response.status_code == 200
    assert response.json() == user_settings.model_dump()

    # READ
    response = requests.get(f"{base_url}/uid_101", headers=headers)
    assert response.status_code == 200
    assert response.json() == user_settings.model_dump()

    # UPDATE
    user_settings.setting_1="s2"
    response = requests.put(f"{base_url}/uid_101", headers=headers, json=user_settings.model_dump())
    assert response.status_code == 200
    assert response.json() == user_settings.model_dump()

    # DELETE
    response = requests.delete(f"{base_url}/uid_101", headers=headers)
    assert response.status_code == 200