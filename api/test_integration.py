import requests
from models.usersettings import UserSettings

headers = { "Authorization": "Bearer BYPASS_TOKEN" }

# dependencies must, first be ran: docker-compose up --build
def test_usersettings_api():
    base_url = "http://localhost:8000/v1/usersettings"

    us = UserSettings(user_id="uid_101", setting_1="s1", setting_2=1, setting_3=False)

    # CREATE
    response = requests.post(f"{base_url}/", headers=headers, json=us.model_dump())
    assert response.status_code == 200
    assert response.json() == us.model_dump()

    # READ
    response = requests.get(f"{base_url}/{us.user_id}", headers=headers)
    assert response.status_code == 200
    assert response.json() == us.model_dump()

    # UPDATE
    us.setting_1="s2"
    response = requests.put(f"{base_url}/{us.user_id}", headers=headers, json=us.model_dump())
    assert response.status_code == 200
    assert response.json() == us.model_dump()

    # DELETE
    response = requests.delete(f"{base_url}/{us.user_id}", headers=headers)
    assert response.status_code == 200
    print("successfully ran and asserted base test cases!")