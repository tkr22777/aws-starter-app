from fastapi import FastAPI
from controllers import usersettings_controller, admin_controller

app = FastAPI()

# app.include_router(usersettings_controller.router, prefix="/v1/usersettings", tags=["usersettings"])
app.include_router(admin_controller.router, prefix="/v1/admin", tags=["admin"])
