# Steps to run/test the project

- Install Python 3.10
- Install dependencies: `pip3 install -r requirements.txt`
- Build and run the service containers: `docker-compose up --build`
- Run integration tests: `pytest test_integration.py`

## Test using manual curl command

### Create a new UserSetting:
```
curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer BYPASSTOKEN" -d '{
    "user_id": "user127",
    "setting_1": "Value 1",
    "setting_2": 42,
    "setting_3": true
}' http://localhost:8000/v1/usersettings/
```

### Get a specific UserSetting by user_id:
```
curl -X GET -H "Authorization: Bearer BYPASSTOKEN" http://localhost:8000/v1/usersettings/{user_id}
```

### Update an existing UserSetting by user_id:
```
curl -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer BYPASSTOKEN" -d '{
    "user_id": "user123",
    "setting_1": "Updated Value",
    "setting_2": 99,
    "setting_3": false
}' http://localhost:8000/v1/usersettings/{user_id}
```

### Delete a UserSetting by user_id:
```
curl -X DELETE -H "Authorization: Bearer BYPASSTOKEN" http://localhost:8000/v1/usersettings/{user_id}
```
