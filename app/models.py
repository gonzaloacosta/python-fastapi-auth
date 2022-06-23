from sqlalchemy import Column, Integer, String, DateTime
from database import Base
import datetime


def get_date():
    """
    Day of the day
    """
    return datetime.datetime.now()


class Apikeys(Base):
    """
    Inherit class from Base, represent to table apikeys,
    each instance is a row
    """
    __tablename__ = 'apikeys'
    id = Column(Integer, primary_key=True)
    appname = Column(String(64))
    apikey = Column(String(64))
    description = Column(String(128))
    stamp_created = Column(DateTime, default=get_date())
    stamp_updated = Column(DateTime, default=get_date())
