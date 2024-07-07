from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker


DATABASE_URL = 'postgresql://postgres:test123@localhost:5432/musicapp'
# creates a db engine.
engine = create_engine(DATABASE_URL)
# creates a session that is binded with the engine
SessionLocal = sessionmaker(autocommit = False, autoflush=False, bind= engine)

# this is good code practice, this allows us to access them db, and once we are done with it we close the connection to the db
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
