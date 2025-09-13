from fastapi import APIRouter, Request
from fastapi_mvc.controllers import api_menus_controller

router = APIRouter()

@router.get("/")
def get_api_menus():
    return api_menus_controller.fetch_all_api_menus()

@router.get("/{menu_id}")
def get_api_menu(menu_id: int):
    return api_menus_controller.fetch_api_menu_by_id(menu_id)

@router.get("/page/{page_id}")
def get_api_menu(page_id: int):
    return api_menus_controller.fetch_api_menu_by_page_id(page_id)

@router.get("/page/{page_id}/menus")
def get_api_menu(page_id: int):
    return api_menus_controller.fetch_api_menus_by_page_id(page_id)

@router.post("/")
async def post_api_menu(request: Request):
    data = await request.json()
    return api_menus_controller.create_api_menu(data)

@router.put("/{menu_id}")
async def put_api_menu(menu_id: int, request: Request):
    data = await request.json()
    return api_menus_controller.modify_api_menu(menu_id, data)

@router.delete("/{menu_id}")
def delete_api_menu(menu_id: int):
    return api_menus_controller.remove_api_menu(menu_id)

@router.get("/{menu_id}/content")
def get_menu_content(menu_id: int):
    return api_menus_controller.fetch_menu_content(menu_id)

@router.post("/{menu_id}/content")
async def save_menu_content(menu_id: int, request: Request):
    data = await request.json()
    content = data.get("content", "[]")
    return api_menus_controller.save_menu_content(menu_id, content)
