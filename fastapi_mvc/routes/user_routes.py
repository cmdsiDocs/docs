from fastapi import APIRouter, Request
from fastapi_mvc.controllers import user_controller

router = APIRouter()

@router.get("/")
def get_users():
    return user_controller.fetch_all_users()

@router.get("/{user_id}")
def get_user(user_id: int):
    return user_controller.fetch_user_by_id(user_id)

@router.post("/")
def post_user(request: Request):
    data = request.json()
    return user_controller.create_user(data)

@router.put("/{user_id}")
def put_user(user_id: int, request: Request):
    data = request.json()
    return user_controller.modify_user(user_id, data)

@router.delete("/{user_id}")
def delete_user(user_id: int):
    return user_controller.remove_user(user_id)
