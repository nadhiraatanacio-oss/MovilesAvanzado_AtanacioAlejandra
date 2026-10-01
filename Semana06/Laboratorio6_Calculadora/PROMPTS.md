# PROMPTS.md — Semana 06 · Ejercicio 4 (rama ai-assisted)

## Calculadora de Venta a Plazos de Electrodoméstico

### Contexto
Estoy en el curso Programación en Móviles Avanzado (UIKit + Storyboard, Swift).
Tengo un proyecto con Navigation Controller y dos pantallas ya diseñadas:
- "Nueva Venta" (NuevaVentaViewController) con 5 UITextField conectados:
  tfElectrodomestico, tfPrecio, tfCantidad, tfMeses, tfInteres.
- "Resultado" (ResultadoViewController) con 6 UILabel conectados:
  lblSubtotal, lblIgv, lblBase, lblIntereses, lblTotal, lblCuota.
El botón "Calcular" tiene un segue Show con identifier "showResultado".

### Tarea
1. Define `class VentaModel: NSObject` con 6 propiedades Double:
   subtotal, igv, base, intereses, total, cuota.
2. En "Nueva Venta", implementa el cálculo con estas fórmulas y arma un VentaModel:
   - subtotal = precioUnitario x cantidad
   - igv = subtotal x 0.18
   - base = subtotal + igv
   - intereses = base x (tasaInteresMensual / 100) x meses
   - total = base + intereses
   - cuota = total / meses
3. Pasa el VentaModel a "Resultado" con `prepare(for:sender:)`.
4. En "Resultado", muestra cada valor con `String(format: "S/. %.2f", valor)`.

### Restricciones
- Solo lo visto hasta semana 6: clases, UINavigationController,
  prepare(for:sender:), IBOutlet/IBAction.
- Nada de Combine, Codable ni persistencia.
- Explica por qué usas `class` y no `struct` para VentaModel.

### Formato
Código Swift separado por archivo (VentaModel.swift,
NuevaVentaViewController.swift, ResultadoViewController.swift),
con comentarios cortos en español.

### Ejemplo
Entrada: precio 1750, cantidad 2, meses 12, interés 1%.
Salida esperada: Subtotal S/. 3500.00 · IGV S/. 630.00 · Base S/. 4130.00 ·
Intereses S/. 495.60 · Total S/. 4625.60 · Cuota S/. 385.47

---

## Respuesta de la IA: ¿por qué class y no struct?
Se usó `class VentaModel: NSObject` para seguir el mismo patrón de ClienteModel
del Ejercicio 2. Una class es un tipo por referencia: la pantalla Resultado
recibe el mismo objeto que se creó en Nueva Venta. Con un struct el paso de
datos hacia adelante también funcionaría, porque se copia el valor antes de
abrir la pantalla; la diferencia se notaría solo si una pantalla modificara el
modelo y la otra esperara ver ese cambio.

---

## Reflexión: qué hizo distinto la IA
- Leyó los campos con `Double(tf.text ?? "") ?? 0` en vez de usar `text!`
  como en el Ejercicio 2. Así, si un campo está vacío o tiene letras, vale 0
  y la app no se cae.
- Evitó dividir entre cero: si meses es 0, la cuota queda en 0.
- No usó `guard let` ni alertas de validación; se mantuvo en lo visto en clase.
- Pasó los datos con `prepare(for:sender:)` y el segue `showResultado`,
  en vez de `instantiateViewController` + `present` como en la modal.
- Resultado verificado: con los datos del ejemplo salieron los mismos
  valores que en el diseño profesor