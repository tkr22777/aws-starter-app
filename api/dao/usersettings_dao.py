# dao/usersettings_dao.py
import os
import psycopg2
from typing import Optional

from models.usersettings import UserSettings

class UserSettingsDAO:
    def __init__(self):
        postgres = os.environ.get('POSTGRES_HOST_IP')
        self.connection = psycopg2.connect(
            host=postgres,
            database="postgres",
            user="postgres",
            password="abcd1234",
        )

    def get_usersetting_by_id(self, user_id: str) -> Optional[UserSettings]:
        with self.connection.cursor() as cursor:
            cursor.execute("SELECT * FROM usersettings WHERE user_id = %s", (user_id,))
            usersetting_data = cursor.fetchone()

        if usersetting_data is None:
            return None

        usersetting = UserSettings(
            user_id=usersetting_data[0],
            setting_1=usersetting_data[1],
            setting_2=usersetting_data[2],
            setting_3=usersetting_data[3],
        )
        return usersetting

    def create_usersetting(self, usersetting: UserSettings) -> UserSettings:
        with self.connection.cursor() as cursor:
            cursor.execute(
                "INSERT INTO usersettings (user_id, setting_1, setting_2, setting_3) "
                "VALUES (%s, %s, %s, %s) RETURNING user_id",
                (usersetting.user_id, usersetting.setting_1, usersetting.setting_2, usersetting.setting_3),
            )
            new_user_id = cursor.fetchone()[0]
            usersetting.user_id = new_user_id

        self.connection.commit()
        return usersetting

    def update_usersetting(self, user_id: str, usersetting: UserSettings) -> Optional[UserSettings]:
        with self.connection.cursor() as cursor:
            cursor.execute(
                "UPDATE usersettings "
                "SET setting_1 = %s, setting_2 = %s, setting_3 = %s "
                "WHERE user_id = %s RETURNING user_id",
                (usersetting.setting_1, usersetting.setting_2, usersetting.setting_3, user_id),
            )
            updated_user_id = cursor.fetchone()

        self.connection.commit()
        if updated_user_id is None:
            return None

        usersetting.user_id = updated_user_id[0]
        return usersetting

    def delete_usersetting(self, user_id: str) -> Optional[UserSettings]:
        usersetting = self.get_usersetting_by_id(user_id)
        if usersetting is None:
            return None

        with self.connection.cursor() as cursor:
            cursor.execute("DELETE FROM usersettings WHERE user_id = %s", (user_id,))

        self.connection.commit()
        return usersetting
