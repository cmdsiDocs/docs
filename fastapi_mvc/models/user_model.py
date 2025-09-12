class User:
    def __init__(self, user_id, username, password, role_id, is_active):
        self.user_id = user_id
        self.username = username 
        self.role_id = role_id
        self.is_active = is_active 

    def to_dict(self):
        return {
            "user_id": self.user_id,
            "username": self.username, 
            "role_id": self.role_id,
            "is_active": self.is_active
        }
