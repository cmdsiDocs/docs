import os
import json
from fastapi_mvc.config.database_cmdsi import get_connection
from fastapi_mvc.models.api_menus_model import ApiMenu

# Folder to store .text content files
FILES_DIR = os.path.join("assets", "files")
os.makedirs(FILES_DIR, exist_ok=True)


def _get_file_path(menu_id: int) -> str:
    """Helper to resolve text file path for a menu."""
    return os.path.join(FILES_DIR, f"{menu_id}.text")


def save_menu_content(menu_id: int, content) -> int:
    """Save content into a .text file as JSON."""
    path = _get_file_path(menu_id)
 
    if not isinstance(content, str):
        content = json.dumps(content, ensure_ascii=False, indent=2)

    with open(path, "w", encoding="utf-8") as f:
        f.write(content)
    return 1


def get_menu_content(menu_id: int):
    """Load content from .text file if exists."""
    path = _get_file_path(menu_id)
    if os.path.exists(path):
        with open(path, "r", encoding="utf-8") as f:
            try:
                return json.loads(f.read())
            except json.JSONDecodeError:
                return f.read()  # fallback raw text
    return None


def delete_menu_content(menu_id: int):
    """Delete .text file if exists."""
    path = _get_file_path(menu_id)
    if os.path.exists(path):
        os.remove(path)


def get_all_api_menus():
    conn = get_connection()
    with conn.cursor() as cursor:
        cursor.execute("""
            SELECT menu_id, page_id, title, `desc`, is_main_page, 
                   parent_menu_id, created_on, updated_on 
            FROM api_menu
        """)
        rows = cursor.fetchall()
        return [ApiMenu(*row).to_dict() for row in rows]

def get_all_api_menus_page_id(page_id: int):
    conn = get_connection()
    with conn.cursor() as cursor:
        cursor.execute("""
            SELECT menu_id, page_id, title, `desc`, is_main_page, 
                   parent_menu_id, created_on, updated_on 
            FROM api_menu WHERE page_id = %s
        """, (page_id,))
        rows = cursor.fetchall()

    menus = []
    for row in rows:
        menu = ApiMenu(*row).to_dict()
        file_path = os.path.join(FILES_DIR, f"{menu['menu_id']}.text")
        if not os.path.exists(file_path):  # ✅ only include if no .text file yet
            menus.append(menu)

    return menus


def get_api_menu_by_id(menu_id: int):
    conn = get_connection()
    with conn.cursor() as cursor:
        cursor.execute("""
            SELECT menu_id, page_id, title, `desc`, is_main_page, 
                   parent_menu_id, created_on, updated_on
            FROM api_menu WHERE menu_id = %s
        """, (menu_id,))
        row = cursor.fetchone()
        return ApiMenu(*row).to_dict() if row else None


def insert_api_menu(page_id, title, desc, is_main_page, parent_menu_id):
    conn = get_connection()
    with conn.cursor() as cursor:
        cursor.execute("""
            INSERT INTO api_menu (page_id, title, `desc`, is_main_page, parent_menu_id) 
            VALUES (%s, %s, %s, %s, %s)
        """, (page_id, title, desc, is_main_page, parent_menu_id))
        conn.commit()
        menu_id = cursor.lastrowid
 
        return menu_id


def update_api_menu(menu_id, title, desc, is_main_page, parent_menu_id):
    conn = get_connection()
    with conn.cursor() as cursor:
        cursor.execute("""
            UPDATE api_menu 
            SET title = %s, `desc` = %s, is_main_page = %s, parent_menu_id = %s, updated_on = NOW()
            WHERE menu_id = %s
        """, (title, desc, is_main_page, parent_menu_id, menu_id))
        conn.commit() 

        return cursor.rowcount


def delete_api_menu(menu_id: int):
    conn = get_connection()
    with conn.cursor() as cursor:
        cursor.execute("DELETE FROM api_menu WHERE menu_id = %s", (menu_id,))
        conn.commit()

        # Delete .text file
        delete_menu_content(menu_id)

        return cursor.rowcount


def fetch_all_menus_by_page_id(page_id: int):
    """Replicate recursive logic like in Flutter."""
    all_menus = get_all_api_menus()

    def build_children(parent_id):
        children = [
            dict(p) for p in all_menus if str(p["parent_menu_id"]) == str(parent_id)
        ]
        for child in children:
            child["children"] = build_children(child["menu_id"])
        return children

    # main menus where is_main_page = 'Y' and page_id matches
    main_menus = [
        dict(p) for p in all_menus
        if p["is_main_page"] == "Y" and str(p["page_id"]) == str(page_id)
    ]

    for menu in main_menus:
        menu["children"] = build_children(menu["menu_id"])

    return main_menus
