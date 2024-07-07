from fastapi import FastAPI,APIRouter
from models.base import Base
from routes import auth
from database import engine


app = FastAPI()

app.include_router(auth.router, prefix='/auth')


Base.metadata.create_all(engine)
    