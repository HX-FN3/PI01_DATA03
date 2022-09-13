# This is a sample Python script.
from fastapi import FastAPI
from typing import Union
from pydantic import BaseModel
from database import conexion as conex

app = FastAPI(title = "Título API")


class Item(BaseModel):
    name: str
    price: float
    is_offer: Union[bool, None] = None

# los eventos son una feature de fastAPI, en este caso aluden al inicio y cierre del servidor
@app.on_event("startup")
async def startup():
    if conex.is_closed():
        conex.connect()
        print("Conectando...")
        print("Conectando...")

@app.on_event("shutdown")
async def startup():
    if (conex.is_closed() == False):
        conex.close()
        print("Apagando...")
        print("Apagando...")

# utilizo método get del protocolo http. Siempre que se el cliente realice una petición con / a través del método get
# la función definida debajo es la que se encargue de realizar la petición
# Cada get crea una url que formará parte de mi API. La keyword async señala que mi función se ejecuta asincrónicamente
@app.get("/")
async def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}") # utilizo el método get del protocolo http para acceder a la ruta pasada como parámetro
async def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}


@app.put("/items/{item_id}")
async def update_item(item_id: int, item: Item):
    return {"item_name": item.name, "item_id": item_id}


""" Hasta ahora el mayor desafío fue crear el entorno virtual con Ananconda, en primer lugar necesitaba un 
nuevo entorno, en segundo lugar, installar git en mi entorno virtual es clave de otra manera se producen errores
debido a que no se pueden encontrar las rutas de acceso a los archivos"""
