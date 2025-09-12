from fastapi_mvc.config.database_luvpark import get_connection
from fastapi_mvc.models.user_model import User

def get_all_users():
    conn = get_connection()
    with conn.cursor() as cursor:
        cursor.execute("SELECT user_id, username, role_id, is_active FROM users")
        rows = cursor.fetchall()
        return [User(*row).to_dict() for row in rows]

def get_user_by_id(user_id):
    conn = get_connection()
    with conn.cursor() as cursor:
        cursor.execute("SELECT user_id, username, role_id, is_active FROM users WHERE id = %s", (user_id,))
        row = cursor.fetchone()
        return User(*row).to_dict() if row else None

def insert_user(name, email):
    conn = get_connection()
    with conn.cursor() as cursor:
        cursor.execute("INSERT INTO users (name, email) VALUES (%s, %s)", (name, email))
        conn.commit()
        return cursor.lastrowid

def update_user(user_id, name, email):
    conn = get_connection()
    with conn.cursor() as cursor:
        cursor.execute("UPDATE users SET name = %s, email = %s WHERE id = %s", (name, email, user_id))
        conn.commit()
        return cursor.rowcount

def delete_user(user_id):
    conn = get_connection()
    with conn.cursor() as cursor:
        cursor.execute("DELETE FROM users WHERE id = %s", (user_id,))
        conn.commit()
        return cursor.rowcount
