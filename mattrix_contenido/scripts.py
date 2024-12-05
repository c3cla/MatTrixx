import random
from .models import ProblemaProbabilidad  

def es_primo(n):
    if n < 2:
        return False
    for i in range(2, int(n ** 0.5) + 1):
        if n % i == 0:
            return False
    return True

def generar_evento(condicion, espacio_muestral):
    if condicion == "par":
        return [num for num in espacio_muestral if num % 2 == 0]
    elif condicion == "impar":
        return [num for num in espacio_muestral if num % 2 != 0]
    elif condicion == "primo":
        return [num for num in espacio_muestral if es_primo(num)]
    elif condicion == "mayor que 2":
        return [num for num in espacio_muestral if num > 2]
    elif condicion == "mayor o igual a 2":
        return [num for num in espacio_muestral if num >= 2]
    elif condicion == "mayor o igual a 3":
        return [num for num in espacio_muestral if num >= 3]
    elif condicion == "mayor o igual a 4":
        return [num for num in espacio_muestral if num >= 4]
    elif condicion == "mayor o igual a 5":
        return [num for num in espacio_muestral if num >= 5]
    elif condicion == "mayor que 3":
        return [num for num in espacio_muestral if num > 3]
    elif condicion == "menor que 4":
        return [num for num in espacio_muestral if num < 4]
    elif condicion == "menor que 5":
        return [num for num in espacio_muestral if num < 5]
    elif condicion == "menor que 6":
        return [num for num in espacio_muestral if num < 6]
    elif condicion == "divisor de 6":
        return [num for num in espacio_muestral if 6 % num == 0]
    elif condicion == "divisor de 10":
        return [num for num in espacio_muestral if 10 % num == 0]
    elif condicion == "divisor de 12":
        return [num for num in espacio_muestral if 12 % num == 0]
    elif condicion == "1":
        return [num for num in espacio_muestral if num == 1]
    elif condicion == "2":
        return [num for num in espacio_muestral if num == 2]
    elif condicion == "3":
        return [num for num in espacio_muestral if num == 2]
    elif condicion == "4":
        return [num for num in espacio_muestral if num == 2]
    elif condicion == "5":
        return [num for num in espacio_muestral if num == 2]
    elif condicion == "6":
        return [num for num in espacio_muestral if num == 2]

def generar_problema_probabilidad():
    n = random.choice(range(3, 13))
    espacio_muestral = list(range(1, n + 1))  
    cardinalidad_espacio_muestral = len(espacio_muestral)
    tipo = random.choice(["simple", "aditiva"])

    if tipo == "aditiva":
        condicion1 = random.choice(["1", "2", "3", "4", "5", "6", "par", "impar", "primo", "mayor que 2", "mayor o igual a 2", "mayor o igual a 3", "mayor o igual a 4", "mayor o igual a 5", "mayor que 3", "menor que 4", "menor que 5", "menor que 6","divisor de 6", "divisor de 10", "divisor de 12"])
        condicion2 = condicion1

        while condicion1 == condicion2:
            condicion2 = random.choice(["1", "2", "3", "4", "5", "6", "par", "impar", "primo", "mayor que 2", "mayor o igual a 2", "mayor o igual a 3", "mayor o igual a 4", "mayor o igual a 5", "mayor que 3", "menor que 4", "menor que 5", "menor que 6", "divisor de 6", "divisor de 10", "divisor de 12"])

        
        A1 = generar_evento(condicion1, espacio_muestral)
        A2 = generar_evento(condicion2, espacio_muestral)
        A = list(set(A1 + A2)) 
        
        enunciado = f"¿Cuál es la probabilidad de obtener un número {condicion1} o {condicion2} al lanzar un dado de {n} caras?"
        cardinalidad_evento = len(A)

    else:  
        condicion = random.choice(["1", "2", "3", "4", "5", "6", "par", "impar", "primo", "mayor que 2", "mayor o igual a 2", "mayor o igual a 3", "mayor o igual a 4", "mayor o igual a 5", "mayor que 3", "menor que 4", "menor que 5", "menor que 6", "divisor de 6", "divisor de 10", "divisor de 12"])
        A = generar_evento(condicion, espacio_muestral)
        enunciado = f"¿Cuál es la probabilidad de obtener un número {condicion} al lanzar un dado de {n} caras?"
        cardinalidad_evento = len(A)

    
    problema = ProblemaProbabilidad(
        tipo=tipo,
        enunciado=enunciado,
        espacio_muestral=f"U = {espacio_muestral}",
        elementos_evento=f"A = {A}",
        numerador=cardinalidad_evento,
        denominador=cardinalidad_espacio_muestral
    )
    problema.save()

    print("Problema creado:", enunciado)

generar_problema_probabilidad()
