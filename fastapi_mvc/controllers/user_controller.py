from fastapi import HTTPException
from fastapi_mvc.services import user_service

def fetch_all_users():
    try:
        users = user_service.get_all_users()
        return { "success": "Y", "msg": "", "items": users }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

def fetch_user_by_id(user_id: int):
    try:
        user = user_service.get_user_by_id(user_id)
        if user:
            return { "success": "Y", "msg": "", "items": [user] }
        return { "success": "N", "msg": "User not found", "items": [] }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_user(data):
    try:
        name = data["name"]
        email = data["email"]
        new_id = user_service.insert_user(name, email)
        return { "success": "Y", "msg": "User created", "items": [{"id": new_id, "name": name, "email": email}] }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

def modify_user(user_id: int, data):
    try:
        name = data["name"]
        email = data["email"]
        affected = user_service.update_user(user_id, name, email)
        if affected:
            return { "success": "Y", "msg": "User updated", "items": [{"id": user_id, "name": name, "email": email}] }
        return { "success": "N", "msg": "User not found", "items": [] }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

def remove_user(user_id: int):
    try:
        affected = user_service.delete_user(user_id)
        if affected:
            return { "success": "Y", "msg": f"User {user_id} deleted", "items": [] }
        return { "success": "N", "msg": "User not found", "items": [] }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
