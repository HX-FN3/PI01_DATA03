from peewee import *
from password import passwordCadena

# Datos de acceso a mi base de datos que voy a utilizar en un objeto Database
user = 'root'
db_name = 'piuno'

# Creo un objeto MySQLDatabase con el framework importado en la primera línea

conexion = MySQLDatabase(
    db_name, user=user,
    password=passwordCadena,
    host='localhost',
    port = 3306
)

class BaseModel(Model):
    class Meta:
        database = conexion
