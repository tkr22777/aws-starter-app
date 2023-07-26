Build, test and deployment scripts are in *Makefile*

Developed and tested on Python version: 3.10

Build docker image:

```
make build_docker_image
```

Create a new UserSetting:
```
curl -X POST -H "Content-Type: application/json" -d '{
    "user_id": "user123",
    "setting_1": "Value 1",
    "setting_2": 42,
    "setting_3": true
}' http://localhost:8000/v1/usersettings/
```

Get a specific UserSetting by user_id:
```
curl -X GET http://localhost:8000/v1/usersettings/{user_id}
```

Update an existing UserSetting by user_id:
```
curl -X PUT -H "Content-Type: application/json" -d '{
    "user_id": "user123",
    "setting_1": "Updated Value",
    "setting_2": 99,
    "setting_3": false
}' http://localhost:8000/v1/usersettings/{user_id}
```

Delete a UserSetting by user_id:
```
curl -X DELETE http://localhost:8000/v1/usersettings/{user_id}
```
