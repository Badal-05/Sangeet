import uuid
import bcrypt
from fastapi import Depends, HTTPException, Header
from database import get_db
from models.user import User
from pydantic_schemas.create_user import UserCreate
from fastapi import APIRouter
from sqlalchemy.orm import Session
from pydantic_schemas.login_user import UserLogin
import jwt
from sqlalchemy.orm import joinedload

#  APIRouter will mimic all the functionalities of the @app methods (ie : get, post etc)
router = APIRouter() 
@router.post('/signup',status_code=201)
def signup_user(user : UserCreate, db:Session = Depends(get_db)):
    # to check if the user already exists in the db.
    user_db = db.query(User).filter(User.email==user.email).first()
    if user_db : 
        raise HTTPException(400,'User with the same email already exists!')
    # match the hashed password and password entered by the user.
    hashed_pw = bcrypt.hashpw(user.password.encode(),bcrypt.gensalt())
    user_db = User(id = str(uuid.uuid4()), name = user.name, email = user.email, password = hashed_pw)
    db.add(user_db)
    db.commit()
    db.refresh(user_db)         # refreshes the db wrt to the given item

    return user_db

@router.post('/login')
def login_user(user : UserLogin, db : Session = Depends(get_db)):
    user_db = db.query(User).filter(User.email == user.email).first()
    if not user_db : 
        raise HTTPException(400,'User with this email does not exist!')
    is_pw_match = bcrypt.checkpw(user.password.encode(),user_db.password)
    if not is_pw_match:
        raise HTTPException(400,'Incorrect password!')
    
    token = jwt.encode({'id': user_db.id}, 'password_key')

    return {'token' : token, 'user' : user_db}
