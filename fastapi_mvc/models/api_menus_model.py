class ApiMenu:
    def __init__(self, menu_id, page_id, title, desc, is_main_page, parent_menu_id, created_on, updated_on):
        self.menu_id = menu_id
        self.page_id = page_id
        self.title = title
        self.desc = desc
        self.is_main_page = is_main_page
        self.parent_menu_id = parent_menu_id
        self.created_on = created_on
        self.updated_on = updated_on

    def to_dict(self):
        return {
            "menu_id": self.menu_id,
            "page_id": self.page_id,
            "title": self.title,
            "desc": self.desc,
            "is_main_page": self.is_main_page,
            "parent_menu_id": self.parent_menu_id,
            "created_on": self.created_on,
            "updated_on": self.updated_on,
        }
