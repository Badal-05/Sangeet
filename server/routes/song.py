

import uuid
from fastapi import APIRouter, Depends, File, Form, UploadFile
from sqlalchemy.orm import Session

from database import get_db
from middleware.auth_middleware import auth_middleware
from models.song import Song

router = APIRouter()

import cloudinary
import cloudinary.uploader


# Configuration       
cloudinary.config( 
    cloud_name = "dlbrthqw8", 
    api_key = "648215727194124", 
    api_secret = "3WR05XLBHu8Rs8WW_k9IROeDVrE", # Click 'View Credentials' below to copy your API secret
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