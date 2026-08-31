// ===== EJERCICIO 7: JUEGO DE ADIVINANZA (asistido por IA) =====

let numeroSecreto = 42          // Número que el jugador debe adivinar

// Simulamos 5 intentos fijos porque el Playground no permite pedir input al usuario
let intento1 = 20                // Primer intento del jugador
let intento2 = 50                // Segundo intento del jugador
let intento3 = 35                // Tercer intento del jugador
let intento4 = 45                // Cuarto intento del jugador
let intento5 = 42                // Quinto intento del jugador (coincide con el número secreto)

let intentos = [intento1, intento2, intento3, intento4, intento5]  // Arreglo con todos los intentos en orden, para recorrerlos con while

var indiceActual = 0              // Guarda la posición del intento actual dentro del arreglo (empieza en 0)
var numeroDeIntentos = 0          // Cuenta cuántos intentos se han realizado hasta ahora
var adivino = false                // Bandera que indica si el jugador ya acertó el número

while indiceActual < intentos.count && !adivino {  // Repite mientras queden intentos por revisar Y el jugador aún no haya acertado
    let intentoActual = intentos[indiceActual]        // Obtiene el valor del intento actual desde el arreglo
    numeroDeIntentos += 1                              // Aumenta en 1 el contador de intentos realizados

    if intentoActual == numeroSecreto {                // Compara si el intento actual es exactamente igual al número secreto
        print("Intento \(numeroDeIntentos): \(intentoActual) -> ¡Correcto!") // Muestra que el jugador acertó
        adivino = true                                   // Marca que el jugador ya ganó, para detener el bucle
    } else if intentoActual > numeroSecreto {           // Si no es igual, compara si el intento es mayor al número secreto
        print("Intento \(numeroDeIntentos): \(intentoActual) -> Muy alto")  // Indica que el número ingresado fue demasiado grande
    } else {                                             // Si no es igual ni mayor, entonces es menor al número secreto
        print("Intento \(numeroDeIntentos): \(intentoActual) -> Muy bajo")  // Indica que el número ingresado fue demasiado pequeño
    }

    indiceActual += 1                                   // Avanza al siguiente intento del arreglo
}

if adivino {                                          // Verifica si el jugador llegó a acertar en algún momento
    print("¡Ganaste! Adivinaste el número en \(numeroDeIntentos) intento(s)") // Muestra un mensaje de victoria con el total de intentos usados
} else {                                              // Si nunca acertó tras recorrer todos los intentos
    print("Perdiste. El número era: \(numeroSecreto)")  // Muestra el mensaje de derrota revelando el número secreto
}
