#!/bin/bash

# Ruta de la carpeta de imagenes
IMG_DIR="./assets/img"

# 1. Verificar si la carpeta existe
if [ ! -d "$IMG_DIR" ]; then
  echo "Error: La carpeta $IMG_DIR no existe."
  exit 1
fi

# 2. Buscar archivo PNG que no siga el patron execN.png
TARGET_FILE=$(ls "$IMG_DIR" | grep -v "^exec[0-9]\+\.png$" | grep "\.png$" | head -n 1)

if [ -z "$TARGET_FILE" ]; then
  echo "No se encontro ningun archivo nuevo para renombrar."
  exit 0
fi

# 3. Obtener el numero mas alto actual
LAST_NUM=$(ls "$IMG_DIR" | grep "^exec[0-9]\+\.png$" | sed 's/exec//;s/\.png//' | sort -n | tail -n 1)

# Si no hay archivos previos, empieza en 1
if [ -z "$LAST_NUM" ]; then
  NEXT_NUM=1
else
  NEXT_NUM=$((LAST_NUM + 1))
fi

# 4. Renombrar
NEW_NAME="exec${NEXT_NUM}.png"
mv "$IMG_DIR/$TARGET_FILE" "$IMG_DIR/$NEW_NAME"

echo "Se ha renombrado '$TARGET_FILE' a '$NEW_NAME' exitosamente."
