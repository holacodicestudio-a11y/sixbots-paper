# Publicar SixBots en Render

Esta app usa un servicio web porque el backend conserva la clave de OpenAI y ejecuta los agentes. No publiques solo `index.html`: la clave nunca debe estar en el navegador.

## Archivos preparados

- `Dockerfile` inicia el servidor Python en el puerto que Render asigne.
- `render.yaml` define un servicio web gratuito y solicita los secretos durante la configuración inicial.
- El servidor pide una contraseña antes de permitir análisis. La sesión se guarda en una cookie `HttpOnly`, `Secure` y `SameSite=Strict` cuando está en Render.
- `.gitignore` excluye las capturas adjuntas, claves y archivos locales.

## Publicación

1. Crea un repositorio **privado** en GitHub y agrega el contenido de esta carpeta. No subas capturas privadas ni claves. Conserva `Dockerfile`, `render.yaml`, `server.py`, `index.html`, `app.js`, `styles.css`, `prompts/` y `templates/`.
2. En Render, crea un **Blueprint** y conecta ese repositorio. Render lee `render.yaml` y prepara el servicio.
3. Cuando Render pida los secretos, introduce `OPENAI_API_KEY` en el panel seguro de Render. Elige una `APP_ACCESS_PASSWORD` larga (mínimo 16 caracteres) y guárdala en un gestor de contraseñas. `APP_SESSION_SECRET` se genera automáticamente.
4. Espera a que termine el deploy. Abre la URL `onrender.com` desde el teléfono e inicia sesión con `APP_ACCESS_PASSWORD`.

No pongas la clave de OpenAI ni la contraseña de acceso en GitHub, en esta conversación ni en campos visibles de la app. Cada sesión puede consumir hasta seis llamadas a OpenAI API.

## Límite del plan gratuito

Render duerme un servicio gratuito tras 15 minutos sin visitas; la siguiente apertura puede tardar cerca de un minuto. El servicio gratuito sirve para probar la app y no garantiza disponibilidad continua. [Detalles oficiales de Render](https://render.com/docs/free).

El acceso de SixBots sigue siendo solo para simulación: no ejecuta operaciones ni se conecta a un broker.
