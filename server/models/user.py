from sqlalchemy import Column,TEXT,VARCHAR,LargeBinary
from models.base import Base
from sqlalchemy.orm import relationship


# creating the schema for a table. The table will be created using these attributes.
class User(Base):
    __tablename__ = "users"

    id = Column(TEXT, primary_key=True)
    name = Column(VARCHAR(100))
    email = Column(VARCHAR(100))
    password = Column(LargeBinary)

    favorites = relationship('Favorite', back_populates='user')