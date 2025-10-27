from passlib.context import CryptContext
from datetime import datetime, timedelta
import jwt

# Configuration du hachage
password_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

SECRET_KEY = "django-insecure-2g1^fl@m8lw*_mlg4tr6fd0(t+fw&#%3c(k5y5dkjksj^mx$1-"
ALGORITHM = "HS256"

# 🔒 Hachage du mot de passe
def hash_password(password: str) -> str:
    return password_context.hash(password)

# 🔑 Vérification du mot de passe
def verify_password(plain_password: str, hashed_password: str) -> bool:
    return password_context.verify(plain_password, hashed_password)

# 📝 Création d'un JWT
def create_access_token(data: dict, expires_delta: timedelta = timedelta(hours=1)):
    to_encode = data.copy()
    expire = datetime.utcnow() + expires_delta
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

# 🔍 Vérification d'un JWT
def verify_access_token(token: str):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except jwt.ExpiredSignatureError:
        return None
    except jwt.InvalidTokenError:
        return None