# models/usersettings.py
from pydantic import BaseModel

class UserSettings(BaseModel):
    user_id: str
    setting_1: str
    setting_2: int
    setting_3: bool
