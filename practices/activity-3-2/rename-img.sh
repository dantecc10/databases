#!/bin/bash

# Ruta de la carpeta de imágenes
# IMG_DIR="./practices/activity-3-1/assets/img"
IMG_DIR="./assets/img"

# 1. Verificar si la carpeta existe
if [ ! -d "$IMG_DIR" ]; then
  echo "Error: La carpeta $IMG_DIR no existe."
  exit 1
fi

# 2. Buscar el archivo que NO sigue el patrón execN.png
# Filtramos los que NO empiezan con 'exec' y terminan en '.png'
TARGET_FILE=$(ls "$IMG_DIR" | grep -v "^exec[0-9]\+\.png$" | grep "\.png$" | head -n 1)

if [ -z "$TARGET_FILE" ]; then
  echo "No se encontró ningún archivo nuevo para renombrar."
  exit 0
fi

# 3. Encontrar el número más alto actual
# Listamos los archivos execN.png, extraemos el número, los ordenamos y tomamos el mayor
LAST_NUM=$(ls "$IMG_DIR" | grep "^exec[0-9]\+\.png$" | sed 's/exec//;s/\.png//' | sort -n | tail -n 1)

# Si no hay archivos previos, empezamos en 1
if [ -z "$LAST_NUM" ]; then
  NEXT_NUM=1
else
  NEXT_NUM=$((LAST_NUM + 1))
fi

# 4. Renombrar el archivo
NEW_NAME="exec${NEXT_NUM}.png"
mv "$IMG_DIR/$TARGET_FILE" "$IMG_DIR/$NEW_NAME"

echo "Se ha renombrado '$TARGET_FILE' a '$NEW_NAME' exitosamente."
