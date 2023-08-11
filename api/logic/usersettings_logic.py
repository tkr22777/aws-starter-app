from typing import Optional

from models.usersettings import UserSettings
from dao.usersettings_dao import UserSettingsDAO

class UserSettingsLogic:
    dao = UserSettingsDAO()

    def create_usersetting(self, usersetting: UserSettings) -> UserSettings:
        return self.dao.create_usersetting(usersetting)

    def get_usersetting_by_id(self, user_id: str) -> Optional[UserSettings]:
        return self.dao.get_usersetting_by_id(user_id)

    def update_usersetting(self, user_id: str, usersetting: UserSettings) -> Optional[UserSettings]:
        return self.dao.update_usersetting(user_id, usersetting)

    def delete_usersetting(self, user_id: str) -> Optional[UserSettings]:
        return self.dao.delete_usersetting(user_id)
