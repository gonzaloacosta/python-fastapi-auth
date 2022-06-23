from pydantic import BaseModel
from datetime import datetime


class ApikeyCreate(BaseModel):
    """
    Create Apikey Schema (Pydantic Model)
    """
    appname: str
    apikey : str
    description: str


class Apikeys(BaseModel):
    """
    Complete Apikey Schema (Pydantic Model)
    """
    id: int
    stamp_created: datetime
    stamp_updated: datetime
    appname: str
    apikey: str
    description: str

    class Config:
        orm_mode = True
