from fastapi import FastAPI
from fastapi_mvc.routes.user_routes import router as user_router
from fastapi_mvc.routes.api_menus_routes import router as api_menus_router
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="FastAPI MVC with MySQL")
app.include_router(user_router, prefix="/users", tags=["Users"])

app.include_router(api_menus_router, prefix="/api_menus", tags=["API Menus"])


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)