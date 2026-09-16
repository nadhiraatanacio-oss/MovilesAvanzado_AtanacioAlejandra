# Prompts utilizados — Laboratorio 04

## Herramienta de IA utilizada
Claude

## Caso 2B — Biblioteca

### Prompt 1:
CONTEXTO: Soy estudiante de Swift, cuarta semana, trabajo en un Playground de Xcode.
TAREA: Necesito una biblioteca con enum EstadoLibro, struct Libro y class Biblioteca con métodos prestar, devolver e inventario.
RESTRICCIONES: Solo struct, class, herencia, protocolos, enums, arrays, bucles y funciones. Sin optionals ni guard let, sin firstIndex(where:), sin didSet, sin propiedades calculadas, sin genéricos.
FORMATO: Solo el código Swift, con las firmas exactas indicadas.
EJEMPLO: (salida esperada del Caso 2A)

### Respuesta de la IA:
Generó el enum EstadoLibro, el struct Libro y la clase Biblioteca con los métodos agregar, prestar, devolver e inventario, usando bucle for con índice y switch, respetando las restricciones pedidas.

### ¿Funcionó a la primera?
Sí.

### ¿Usó algo que no hemos visto en clase?
No — no usó optionals, guard let, firstIndex(where:), didSet ni genéricos. Solo usó una variable auxiliar (estadoTexto) dentro del switch de inventario(), en vez de imprimir directo en cada case como en mi versión manual.

## Mi versión (Parte A) vs. la versión de la IA (Parte B)

### ¿Qué hizo distinto la IA respecto a mi solución?
Usó una variable auxiliar (estadoTexto) para armar el texto del estado antes de imprimir, en vez de poner el print() directo dentro de cada case del switch.

### ¿Hay alguna línea de la IA que no entiendo del todo? ¿Cuál?
No, el código es claro y usa la misma lógica de recorrido por índice que usé yo.

### ¿Qué me pareció mejor de MI versión?
Es más directa, imprime en el mismo case sin variable intermedia.

### ¿Qué me pareció mejor de la versión de la IA?
Separar el texto del estado en una variable hace el código un poco más ordenado si luego se quisiera reutilizar ese texto en otro lugar.
