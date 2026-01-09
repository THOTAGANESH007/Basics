from fastapi import FastAPI
from typing import Optional
from pydantic import BaseModel
from enum import Enum
app = FastAPI()

@app.get('/')
def welcome():
    return "Welcome to my world!!!"

# path variables (passed inside the {} in the path) and query params (passed in the url after ?)

@app.get('/blob')
def index(limit = 10, published:bool = True, sort:Optional[str] = None): # default parameters (if query params not passed) and optional parameters
    if published:
        return {'data':f'You published {limit} books'}
    return {'data':f'Not yet done!!!'}

@app.get('/blob/{id}')
def print_page(id:int): # type checking
    return {'data':f'You are on the page {id}'}

@app.get('/blob/{id}/comments')
def comments(id, comment="Hello"):
    return {'data':f'Your comment is {comment} on page {id}'}

class Blob(BaseModel):
    title:str
    body: str
    is_published:Optional[bool]

class EnumClass(str,Enum):
    a = "what"
    b = "why"
    c = "who"
    
@app.post('/blob')
def create_blob(blob:Blob):
    return {'data':f'Bro Your first blob contains {blob.body} and {blob.title}'}
    # return {'title':blob.title ,'body':blob.body}
    
@app.get('/enum')
def enum_usage(enum_usage: EnumClass):
    if enum_usage.value == "what":
        return {'data':f'{EnumClass.a} are you talking'}
    

fake_items_db = [{"item_name": "Foo"}, {"item_name": "Bar"}, {"item_name": "Baz"}]


@app.get("/items")
def read_item(skip: int, limit: int = 10):
    return [d["item_name"] for d in fake_items_db[skip : skip + limit]]