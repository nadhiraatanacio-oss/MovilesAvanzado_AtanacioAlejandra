CONTEXTO: Soy estudiante de Swift, cuarta semana, trabajo en un Playground de Xcode.

TAREA: Necesito una biblioteca con enum EstadoLibro, struct Libro y class Biblioteca con métodos prestar, devolver e inventario.

RESTRICCIONES: Solo struct, class, herencia, protocolos, enums, arrays, bucles y funciones. Sin optionals ni guard let, sin firstIndex(where:), sin didSet, sin propiedades calculadas, sin genéricos.

FORMATO: Solo el código Swift, con las firmas exactas que te indico:
- enum EstadoLibro con casos disponible y prestado
- struct Libro con titulo (String), autor (String), estado (EstadoLibro, empieza en .disponible)
- class Biblioteca con var libros: [Libro] (empieza vacía)
- func agregar(libro:) que añade al array
- func prestar(titulo:) -> Bool que busca por título recorriendo el array por índice (for i in 0..<libros.count)
- func devolver(titulo:) -> Bool con lógica inversa
- func inventario() que imprime cada libro con autor y estado usando switch

EJEMPLO de salida esperada:
Préstamo aprobado: La ciudad y los perros
Error: La ciudad y los perros ya está prestado
Devolución registrada: La ciudad y los perros
Préstamo aprobado: El Quijote
Error: no existe El Principito
===== INVENTARIO =====
Cien años de soledad (Gabriel García Márquez) - disponible
La ciudad y los perros (Mario Vargas Llosa) - disponible
El Quijote (Miguel de Cervantes) - prestado
