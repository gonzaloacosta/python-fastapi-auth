#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
 service: basic apikey auth
```usage: python main.py -h```
"""
__author__ = "Gonzalo Acosta"
__email__ = "gonzaloacostapeiro@gmail.com"
__version__ = "0.0.1"

from fastapi import FastAPI, status, HTTPException, Response, Header, Request, Query

from database import Base, engine
from sqlalchemy.orm import Session
from typing import List, Union

import models
import schemas
import datetime
import time
from time import sleep


def get_date():
    """
    Day of the day
    """
    return datetime.datetime.now()


# Create the database
Base.metadata.create_all(engine)

# Initialize app
app = FastAPI()


@app.get("/")
def root(response: Response):
    """
    Root base path
    """
    start_time = time.time()

    message = "Hello DevOps to apikey basic auth version {}".format(__version__)
    response_content = {
        "message": message
    }

    process_time = time.time() - start_time
    response.headers["x-process-time"] = str(process_time)

    return response_content


@app.post("/apikey",
          status_code=status.HTTP_201_CREATED,
          response_model=schemas.Apikeys)
def create_apikey(
        apikey: schemas.ApikeyCreate,
        response: Response):
    """
    Create a new apikey
    """
    start_time = time.time()

    session = Session(
        bind=engine,
        expire_on_commit=False)

    apikey_db = models.Apikeys(
        appname=apikey.appname,
        apikey=apikey.apikey,
        description=apikey.description,
        stamp_created=get_date(),
        stamp_updated=get_date(),
    )

    session.add(apikey_db)
    session.commit()
    session.refresh(apikey_db)
    session.close()

    process_time = time.time() - start_time
    response.headers["x-process-time"] = str(process_time)

    return apikey_db


@app.get("/apikey/{id}",
         response_model=schemas.Apikeys,
         status_code=status.HTTP_200_OK)
def read_apikey(id: int, response: Response):
    """
    Read a raw apikey
    """
    start_time = time.time()

    session = Session(bind=engine, expire_on_commit=False)
    apikey = session.query(models.Apikeys).get(id)
    session.close()

    if not apikey:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"apikey item with id {id} not found"
        )

    process_time = time.time() - start_time
    response.headers["x-process-time"] = str(process_time)
    return apikey

@app.get("/auth",
         status_code=status.HTTP_200_OK)
async def check_apikey(
        request: Request,
        response: Response,
        apikey: str = "local-key",
        ):
    """
    Validate apikey
    """

    # work here
    start_time = time.time()

    print("request.headers: {} {}".format(request.headers, request.headers.keys()))

    if "apikey" in request.headers.keys():
        apikey = request.headers["apikey"]
        print("header apikey: {}".format(apikey))
    elif 'apikey' in request.headers["x-forwarded-uri"]:
        print("x-forwarded-uri: {}".format(request.headers["x-forwarded-uri"]))
        apikey == "x-forwarded-uri"
    elif apikey == "local-key":
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Need to define apikey in query string or header"
        )
    else:
        print("querystring apikey: {}".format(apikey))

    session = Session(bind=engine, expire_on_commit=False)
    apikey_list = session.query(models.Apikeys).all()

    if not apikey_list:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"empty apikey tables"
        )

    session.close()

    appname = None
    for ak in apikey_list:
        if ak.apikey == apikey or ak.apikey in request.headers["x-forwarded-uri"]:
            appname = ak.appname
            break

    if not appname: 
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"unauthorize"
        )
        
    process_time = time.time() - start_time
    response.headers["x-process-time"] = str(process_time)
    response.headers["appname"] = str(appname)

    print("response.headers: {}".format(response.headers))

    response_content = {
        "message": "authorized {}".format(appname)
    }
    return response_content

@app.get("/apikey/{id}",
         response_model=schemas.Apikeys,
         status_code=status.HTTP_201_CREATED)
def update_apikey(id: int,
                   appname: str,
                   apikey: str,
                   description: str,
                   response: Response):
    """
    Update a raw apikey
    """
    start_time = time.time()

    session = Session(bind=engine, expire_on_commit=False)
    apikey = session.query(models.Apikeys).get(id)

    if apikey:
        apikey.appname = username
        apikey.apikey = apikey
        apikey.description = description
        apikey.stamp_updated = get_date()
        session.commit()

    session.close()

    if not apikey:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"apikey item with id {id} not found"
        )

    process_time = time.time() - start_time
    response.headers["x-process-time"] = str(process_time)

    return apikey


@app.delete("/apikey/{id}",
            status_code=status.HTTP_201_CREATED,
            response_model=schemas.Apikeys)
def delete_apikey(id: int, response: Response):
    """
    Delete a apikey
    """
    start_time = time.time()

    session = Session(bind=engine, expire_on_commit=False)
    apikey = session.query(models.Apikeys).get(id)
    print(apikey)

    if apikey:
        session.delete(apikey)
        session.commit()
        session.close()
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"apikeys item with id {id} not found"
        )

    process_time = time.time() - start_time
    response.headers["x-process-time"] = str(process_time)

    return apikey

@app.get("/apikeys",
         status_code=status.HTTP_201_CREATED,
         response_model=List[schemas.Apikeys])
def read_apikeys_list(response: Response):
    """
    Read all apikeys stored in db
    """
    start_time = time.time()

    session = Session(bind=engine, expire_on_commit=False)
    apikeys = session.query(models.Apikeys).all()

    if not apikeys:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"apikeys item with id {id} not found"
        )

    session.close()

    process_time = time.time() - start_time
    response.headers["x-process-iime"] = str(process_time)

    return apikeys
