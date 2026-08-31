# Prompts utilizados — Laboratorio 02

## Herramienta de IA utilizada
Claude

## Ejercicio 6 — Carrito mejorado

### Prompt (estructura CTRFE):
CONTEXTO: Tengo un carrito de compras en Swift con 5 productos (nombre, precio,
cantidad), que ya calcula subtotales, descuento por monto, categoría de cliente,
IGV y total.

TAREA: Mejora el carrito agregando estas funcionalidades:
1. Descuento por cantidad: si se compran 3 o más unidades del mismo producto,
   aplicar 5% extra de descuento en ese producto.
2. Cupón de descuento: si el código ingresado es "DESCUENTO20", aplicar 20%
   adicional sobre el total.
3. Envío gratis si el total supera S/. 3000; si no, el envío cuesta S/. 25.00.
4. Puntos de fidelidad: 1 punto por cada S/. 100 de compra.
5. Validación: si algún precio es negativo o alguna cantidad es 0, mostrar error.

RESTRICCIONES: Código en Swift para Playground. Cada línea debe tener un
comentario específico explicando qué hace (no comentarios genéricos).

FORMATO: Bloque de código Swift comentado línea por línea.

EJEMPLO: precio1 = 3500.0, cant1 = 1 → sin descuento por cantidad (necesita 3+).

### ¿Funcionó a la primera?
Sí — el código generado cumplió los 5 requisitos y compiló sin errores.

### ¿La IA usó algo que no conocías?
Sí — usó una función (`func calcularSubtotal`) para reutilizar la lógica del
descuento por cantidad en cada producto, en vez de repetir el cálculo 5 veces.
Investigué cómo se declaran funciones con parámetros y valor de retorno en Swift.

## Ejercicio 7 — Juego de adivinanza

### Prompt (estructura CTRFE):
CONTEXTO: Necesito un mini juego de adivinanza de números en Swift para Playground,
donde no se puede pedir input al usuario, así que los intentos se simulan con
variables fijas.

TAREA: Genera un juego de adivinanza con:
1. Un número secreto fijo (ejemplo: 42).
2. 5 intentos simulados con variables (intento1, intento2, intento3, intento4, intento5).
3. Un bucle while que recorra los intentos uno por uno.
4. En cada intento, mostrar si el número ingresado es "Muy alto", "Muy bajo" o "¡Correcto!".
5. Contar cuántos intentos se necesitaron para acertar.
6. Si no adivina en los 5 intentos, mostrar "Perdiste. El número era: X".

RESTRICCIONES: Código en Swift para Playground. Cada línea debe tener un
comentario explicando qué hace y la lógica de la comparación usada.

FORMATO: Bloque de código Swift comentado línea por línea.

EJEMPLO: numeroSecreto = 42, intento1 = 20 → "Muy bajo" (20 < 42).

### ¿Funcionó a la primera?
Sí — el bucle `while` recorrió el arreglo de intentos correctamente y se detuvo
al llegar al número correcto.

### ¿La IA usó algo que no conocías?
Sí — usó un arreglo (`[intento1, intento2, ...]`) junto con un índice para
                    recorrer los intentos, en vez de escribir un `if` por cada intento por separado..
