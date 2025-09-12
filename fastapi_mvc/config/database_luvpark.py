import mysql.connector
from fastapi import HTTPException

def get_connection():
    try:
        return mysql.connector.connect(
            host="localhost",
            user="root",
            password="",  
            database="voting_system"  
        )
    except mysql.connector.Error as e:
        raise HTTPException(status_code=500, detail=str(e))
