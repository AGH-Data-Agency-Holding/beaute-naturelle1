from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from auth.auth_routes import router as auth_router

app = FastAPI(title="BeautyNaturel - Auth API")

# 🔹 Middleware CORS pour autoriser les requêtes du frontend Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # en dev : "*" (toutes origines)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ✅ Ne pas répéter le prefix ici, il est déjà défini dans auth_routes.py
app.include_router(auth_router)

@app.get("/")
def read_root():
    return {"message": "API Auth ready 🚀"}