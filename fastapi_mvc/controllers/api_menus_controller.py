from fastapi import HTTPException
from fastapi_mvc.services import api_menus_service


def fetch_all_api_menus():
    try:
        api_menus = api_menus_service.get_all_api_menus()
        return {"success": "Y", "msg": "", "items": api_menus}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


def fetch_api_menu_by_id(menu_id: int):
    try:
        api_menu = api_menus_service.get_api_menu_by_id(menu_id)
        if api_menu:
            return {"success": "Y", "msg": "", "items": [api_menu]}
        return {"success": "N", "msg": "api_menu not found", "items": []}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
def fetch_api_menus_by_page_id(page_id: int):
    try:
        api_menu = api_menus_service.get_all_api_menus_page_id(page_id)
        if api_menu:
            return {"success": "Y", "msg": "", "items": api_menu}
        return {"success": "N", "msg": "api_menu not found", "items": []}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
def fetch_api_menu_by_page_id(page_id: int):
    try:
        api_menu = api_menus_service.fetch_all_menus_by_page_id(page_id)
        if api_menu:
            return {"success": "Y", "msg": "", "items": api_menu}
        return {"success": "N", "msg": "api_menu not found", "items": []}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_api_menu(data):
    try:
        page_id = data["page_id"]
        title = data["title"]
        desc = data.get("desc", "")
        is_main_page = data.get("is_main_page", "N")
        parent_menu_id = data.get("parent_menu_id", None) 

        new_id = api_menus_service.insert_api_menu(page_id, title, desc, is_main_page, parent_menu_id)
        return {
            "success": "Y",
            "msg": "api_menu created",
            "items": [{
                "id": new_id,
                "page_id": page_id,
                "title": title,
                "desc": desc,
                "is_main_page": is_main_page,
                "parent_menu_id": parent_menu_id,
            }]
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


def modify_api_menu(menu_id: int, data):
    try:
        title = data["title"]
        desc = data.get("desc", "")
        is_main_page = data.get("is_main_page", "N")
        parent_menu_id = data.get("parent_menu_id", None)

        affected = api_menus_service.update_api_menu(menu_id, title, desc, is_main_page, parent_menu_id)
        if affected:
            return {
                "success": "Y",
                "msg": "api_menu updated",
                "items": [{
                    "id": menu_id,
                    "title": title,
                    "desc": desc,
                    "is_main_page": is_main_page,
                    "parent_menu_id": parent_menu_id,
                }]
            }
        return {"success": "N", "msg": "api_menu not found", "items": []}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


def remove_api_menu(menu_id: int):
    try:
        affected = api_menus_service.delete_api_menu(menu_id)
        if affected:
            return {"success": "Y", "msg": f"api_menu {menu_id} deleted", "items": []}
        return {"success": "N", "msg": "api_menu not found", "items": []}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


def fetch_menu_content(menu_id: int):
    try:
        content = api_menus_service.get_menu_content(menu_id)
        if content is not None:
            return {"success": "Y", "msg": "", "items": {"id": menu_id, "content": content}}
        return {"success": "N", "msg": "Menu content not found", "items": {}}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
 


def save_menu_content(menu_id: int, content: str):
    try:
        affected = api_menus_service.save_menu_content(menu_id, content)
        if affected:
            return {
                "success": "Y",
                "msg": "Content updated",
                "items": [{"id": menu_id, "content": content}],
            }
        return {"success": "N", "msg": "Menu not found", "items": []}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
