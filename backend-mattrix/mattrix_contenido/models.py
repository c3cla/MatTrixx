###################### INICIO IMPORTACIONES ######################

from django.db import models

###################### FIN IMPORTACIONES ########################

#------------------------------  INICIO MODELOS  ------------------------------#
# Objetivos de aprendizaje
class OA(models.Model):
    id_OA = models.AutoField(primary_key=True)
    OA = models.CharField(max_length=255)
    descripcion = models.TextField()
    NIVELES = [
        ("7° Básico", "7° Básico"),
        ("8° Básico", "8° Básico"),
        ("1° Medio", "1° Medio"),
        ("2° Medio", "2° Medio"),
        ("3° Medio", "3° Medio"),
        ("4° Medio", "4° Medio"),
    ]
    nivel_asociado = models.CharField(max_length=50, choices=NIVELES)

    def __str__(self):
        return self.OA


#Indicadores de evaluación
class IndicadoresEvaluacion(models.Model):
    id_indicador = models.AutoField(primary_key=True)
    OA = models.ForeignKey(OA, on_delete=models.CASCADE)
    descripcion = models.TextField()
    contenido = models.TextField()

    def __str__(self):
        return f"Indicador {self.id_indicador}"
    

##################### DISTRIBUCIÓN DEL CONTENIDO #####################
#Niveles
class Niveles(models.Model):
    id_nivel = models.CharField(primary_key=True, max_length=10)
    nombre = models.CharField(max_length=255)
    OA = models.ForeignKey(OA, on_delete=models.CASCADE)
    

    def __str__(self):
        return self.nombre
    
#Etapas
class Etapas(models.Model):
    id_etapa = models.AutoField(primary_key=True)
    id_nivel = models.ForeignKey(Niveles, on_delete=models.CASCADE)
    OA = models.ForeignKey(OA, on_delete=models.CASCADE)
    nombre = models.CharField(max_length=255)
    descripcion = models.TextField()
    componente = models.TextField()
    DIFICULTAD = [
        ("Baja", "Baja"),
        ("Intermedia", "Intermedia"),
        ("Alta", "Alta"),
    ]
    dificultad = models.TextField(max_length=50, choices=DIFICULTAD)
    HABILIDAD = [
        ("Argumentar", "Argumentar"),
        ("Modelar", "Modelar"),
        ("Representrar", "Representrar"),        
        ("Resolución de problemas", "Resolución de problemas"),        
    ]
    habilidad = models.TextField(max_length=50, choices=HABILIDAD)
    posicion_x = models.IntegerField()
    posicion_y = models.IntegerField()
    

    def __str__(self):
        return self.nombre
    
##################### ADMINISTRACIÓN PROBLEMAS #####################

#Términos pareados: en uso debe ir la etapa en la que usa
class TerminosPareados(models.Model):
    id_termino = models.AutoField(primary_key=True)
    uso = models.CharField(max_length=255)
    concepto = models.CharField(max_length=255)
    definicion = models.TextField()

    def __str__(self):
        return self.concepto


#Problemas probabilidad simple y aditiva al lanzar un dado
class ProblemaProbabilidad(models.Model):
    id_problema = models.AutoField(primary_key=True)
    tipo = models.CharField(max_length=50)
    enunciado = models.TextField()
    espacio_muestral = models.TextField()  
    elementos_evento = models.TextField()  
    numerador = models.IntegerField()  
    denominador = models.IntegerField()  
    creado_en = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.tipo} - {self.enunciado[:50]}"