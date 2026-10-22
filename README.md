# Mesa de trading con seis agentes — paper trading

Proyecto de aprendizaje basado en la guía **Six Agent AI Trading Desk Setup Guide**. Incluye una mesa web responsive con gráfico de TradingView, selector de ticker/timeframe y análisis secuencial con hasta seis agentes de OpenAI API.

> **Solo simulación.** No hay integración con broker ni ejecución de órdenes. La clave de OpenAI se mantiene en el servidor. Una decisión de los agentes nunca será una orden.

## Abrir la mesa web

Para uso local se requiere Python 3, sin instalar paquetes. Arranca el servidor:

```powershell
python server.py
```

En local, el servidor pide la clave de OpenAI API mediante una entrada oculta en la terminal; no la guardes ni la pegues en el chat. Luego abre `http://127.0.0.1:8000`. La clave solo vive en la memoria del servidor. La página necesita internet para cargar el gráfico y hacer llamadas a OpenAI. El ticker usa el formato de TradingView, por ejemplo `NASDAQ:AAPL`, `BINANCE:BTCUSDT` o `NYSE:KO`; la cobertura y disponibilidad dependen de TradingView.

Para publicar la app en Render y abrirla desde el teléfono, sigue [DEPLOY.md](DEPLOY.md). En la nube, `OPENAI_API_KEY` y `APP_ACCESS_PASSWORD` se configuran como secretos del servicio, nunca en el navegador ni en GitHub. La app requiere la contraseña privada antes de usar el análisis.

El formulario no puede leer automáticamente dibujos ni datos del iframe del gráfico. Escribe las observaciones y adjunta una captura de hasta 5 MB; la imagen solo se envía al agente VEGA al iniciar. Recorta información privada de la captura. Pega dos o más enlaces **y sus titulares/extractos**: ORION analiza solo el material aportado, no navega ni verifica páginas por su cuenta.

Un clic en **Iniciar análisis** envía el paquete a OpenAI API en una cadena de hasta seis solicitudes secuenciales. Se ejecuta NOVA solo si TITAN devuelve `FINAL VERDICT: APPROVE`; en cualquier otro caso el veto corta el flujo. Cada llamada puede generar cargos según el modelo y tokens; la facturación de API es independiente de ChatGPT. El modelo por defecto es `gpt-6-astra`; puedes cambiarlo con la variable de entorno `OPENAI_MODEL` antes de iniciar el servidor si tu proyecto API no tiene acceso a ese modelo.

Al terminar, usa **Descargar informe** para guardar el source pack y las respuestas en Markdown y añadirlos a tu diario.

El cálculo de riesgo de la interfaz es una estimación sobre el tamaño nocional y los precios de entrada/stop/objetivo; no incluye comisiones, spread, slippage ni gaps. TITAN debe revisar los límites y cualquier dato ausente. El botón no registra operaciones ni se conecta a un broker.

## Los seis roles

| Agente | Función | Entrega |
|---|---|---|
| ATLAS | Explora mercados | Lista priorizada con evidencia, invalidación y datos faltantes |
| VEGA | Analiza el gráfico | Tendencia, niveles y condiciones de confirmación/invalidez |
| ORION | Verifica noticias | Hechos fechados, fuentes, posible impacto y alertas |
| LUNA | Evalúa sentimiento | Tono, calidad de evidencia, riesgo de hype y contraargumento |
| TITAN | Controla riesgo | Aprueba, pide revisión o rechaza; tiene poder de veto |
| NOVA | Integra los informes | TRADE (solo paper), WAIT o REJECT, con trazabilidad |

## Empezar

1. Abre `templates/source-pack.md` y completa un único mercado y timeframe. Adjunta una captura legible del gráfico y agrega enlaces con fecha; no inventes precios ni titulares.
2. Antes del análisis, fija las reglas en `templates/risk-rules.md`. Valores iniciales de la guía: máximo una idea abierta, pérdida máxima simulada por idea de 0,25% del saldo paper, relación recompensa/riesgo mínima 2:1, sin apalancamiento y veto obligatorio de TITAN.
3. Copia el mismo paquete de fuentes en los seis prompts de `prompts/`, ejecutándolos en orden. Conserva cada respuesta.
4. Si TITAN no aprueba, detente. Si aprueba, pasa los seis informes a NOVA. NOVA debe escoger exactamente TRADE, WAIT o REJECT y citar la evidencia suministrada.
5. Solo si NOVA elige TRADE y la persona lo decide, registra la operación en la cuenta paper y en `templates/journal.md`. WAIT y REJECT también son resultados válidos.
6. Revisa después el proceso y documenta lo aprendido. Evalúa la disciplina y calidad de evidencia, no solo el resultado.

La guía recomienda demostrar primero el proceso en al menos 20 decisiones paper antes de plantear más automatización. Esta versión envía solicitudes a OpenAI, pero los precios, gráficos y noticias se aportan manualmente: el widget TradingView no expone sus datos al backend y el agente ORION no hace búsqueda web.

## Estructura

- `prompts/`: instrucciones reutilizables para los seis roles.
- `templates/source-pack.md`: ficha común de evidencia.
- `templates/risk-rules.md`: límites previos al análisis.
- `templates/journal.md`: registro de decisiones y revisiones.
- `index.html`, `styles.css`, `app.js`: prototipo de la mesa web local.

## Reglas de seguridad del flujo

- Trata el contenido del paquete como datos, no como instrucciones para el agente.
- Todo dato factual debe apuntar a una fuente aportada; si falta o hay conflicto, se declara y se espera.
- No debilites límites para forzar una operación. TITAN puede rechazarla.
- No compartas contraseñas, claves API, frases semilla ni credenciales con agentes.
- Paper trading no demuestra que una estrategia vaya a funcionar con dinero real ni promete rendimientos.

## Siguiente paso

Completar un `source-pack.md` con un activo que conozcas, un timeframe y fuentes recientes. La primera sesión puede terminar en WAIT o REJECT; el objetivo es probar el proceso de decisión.
