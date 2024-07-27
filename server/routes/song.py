

import uuid
from fastapi import APIRouter, Depends, File, Form, UploadFile
from sqlalchemy.orm import Session,joinedload

from database import get_db
from middleware.auth_middleware import auth_middleware

from models.favorite import Favorite
from models.song import Song
from pydantic_schemas.favourite_song import FavoriteSong

router = APIRouter()

import cloudinary
import cloudinary.uploader

import os
from dotenv import load_dotenv

load_dotenv()


# Configuration       
cloudinary.config( 
    cloud_name = os.getenv('CLOUDNAME'), 
    api_key = os.getenv('APIKEY'), 
    api_secret = os.getenv('APISECRET'), # Click 'View Credentials' below to copy your API secret
    secure=True
)


@router.post('/upload',status_code=201)
def upload_Song(song : UploadFile = File(...), 
                thumbnail : UploadFile = File(...), 
                songName: str = Form(...), 
                artist: str = Form(...), 
                color : str = Form(...), 
                db : Session = Depends(get_db), 
                auth_dict : Session = Depends(auth_middleware)):
    
    song_id = str(uuid.uuid4())
    song_res = cloudinary.uploader.upload(song.file, resource_type = 'auto', folder = f'songs/{song_id}')
    thumbnail_res = cloudinary.uploader.upload(thumbnail.file, resource_type = 'image', folder = f'songs/{song_id}')

    # storing the data in the db
    newSong = Song(
        id = song_id,
        song_url = song_res['url'],
        thumbnail_url = thumbnail_res['url'],
        artist = artist,
        song_name = songName,
        hex_code = color
    )
    db.add(newSong)
    db.commit()
    db.refresh(newSong)
    return newSong

@router.get('/list')
def list_songs(db : Session = Depends(get_db), auth_details : Session = Depends(auth_middleware)):
    songs = db.query(Song).all()
    return songs
    pass


# here we have 3 options to implement favorite song. 
# 1. we can add a new attribute to the user class, to check which all songs are the in the user's favorite section.
# 2. we can add a new column to song class to check which all users have added it to their favorite.
# 3. Or we can create a seperate favorite table.

# We will prefer option 3 beacuse it follows 1NF.


@router.post('/favorite')
def favorite_song(song : FavoriteSong,db : Session = Depends(get_db), x_auth_dict : Session = Depends(auth_middleware)):
    user_id = x_auth_dict['uid']
    fav_song = db.query(Favorite).filter(Favorite.song_id == song.song_id, Favorite.user_id == user_id).first()
    if fav_song: 
        db.delete(fav_song)
        db.commit()
        return {'message' : False}
    else:
        new_fav = Favorite(fav_id = str(uuid.uuid4()), song_id = song.song_id, user_id = user_id)
        db.add(new_fav)
        db.commit()
        return {'message' : True}
    
@router.get('/list/favorites')
def list_fav_songs(db : Session = Depends(get_db), auth_detail : Session = Depends(auth_middleware)):
    user_id = auth_detail['uid']
    songs = db.query(Favorite).filter(Favorite.user_id == user_id).options(joinedload(Favorite.song)).all()
    return songs