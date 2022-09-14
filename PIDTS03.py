from typing import Union
from fastapi import FastAPI
from pydantic import BaseModel
import pymysql


app = FastAPI()

@app.get("/Pregunta1")
def read_root():
    #return {"Hello": "World"}
    conexion = pymysql.connect(host='localhost', database='pidts03', user ='root', password='abcd12345')
    cursor = conexion.cursor()
    cursor.execute("select `year`, count(`year`) as Numero_carreras from races group by `year` order by Numero_carreras desc limit 1;")
    for year in cursor:
        print ("Anio con mas carreras", year)
    conexion.close()
    return ("Año con mas carreras: "+str(year[0]))

@app.get("/Pregunta2")
def read_root():
    #return {"Hello": "World"}
    conexion = pymysql.connect (host='localhost', database='pidts03', user ='root', password='abcd12345')
    cursor = conexion.cursor()
    cursor.execute(" SELECT drivers.driverId, count(qualifying.position) as Cantidad_primeros_puestos, drivers.forename as Nombre, drivers.surname as Apellido FROM qualifying JOIN drivers ON qualifying.driverId = drivers.driverId WHERE position = 1 GROUP BY driverId ORDER BY Cantidad_primeros_puestos DESC LIMIT 1;")
    for racer in cursor:
        print ("Piloto con mayor cantidad de primeros puestos: ", racer)
    conexion.close()
    return ("Piloto con mayor cantidad de primeros puestos: "+racer[2]+' '+racer[3])

@app.get("/Pregunta3")
def read_root():
    #return {"Hello": "World"}
    conexion = pymysql.connect (host='localhost', database='pidts03', user ='root', password='abcd12345')
    cursor = conexion.cursor()
    cursor.execute(" SELECT count(circuitId) as CantidadCarreras, `name` FROM circuits GROUP BY circuitId ORDER BY CantidadCarreras DESC LIMIT 1;")
    for circuit in cursor:
        print ("Nombre del circuito más corrido: ", circuit)
    conexion.close()
    return ("Circuito más corrido: "+circuit[1])

@app.get("/Pregunta4")
def read_root():
    #return {"Hello": "World"}
    conexion = pymysql.connect (host='localhost', database='pidts03', user ='root', password='abcd12345')
    cursor = conexion.cursor()
    cursor.execute(" SELECT sum(r.points) as Puntaje_total, c.nationality as Nacionalidad_del_constructor, c.name as Nombre, d.forename as Nombre, d.surname as Apellido FROM results r JOIN constructors c ON (r.constructorId = c.constructorId) JOIN drivers d ON (r.driverId = d.driverId) WHERE c.nationality = 'British' OR c.nationality = 'American' GROUP BY r.driverId ORDER BY Puntaje_total DESC LIMIT 1;")
    for pilot in cursor:
        print ("Piloto con mayor cantidad de puntos (constructor American o British): ", pilot)
    conexion.close()
    return ("Piloto con mayor cantidad de puntos (constructor American o British): "+pilot[3]+' '+pilot[4])