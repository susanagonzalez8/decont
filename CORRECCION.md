### pipeline.sh

- [-1] L5: Falta un comando para extraer las urls del archivo (e.g. `$(cat data/urls)`)
- [-0.5] L48: la barra al principio de la ruta (`/out`) la convierte en absoluta
  y provoca un error
- [-0.5] L48: los archivos no contienen la palabra ".merged." en sus nombres
- [-1] Falta el log final
