#!/bin/bash
# Copies Compose Multiplatform resources (fonts, strings) from composeKit.xcframework
# into the app bundle so they are available at runtime.

FRAMEWORK_DIR="${BUILT_PRODUCTS_DIR}/XCFrameworkIntermediates/ConektaElements/composeKit.framework"
if [ -d "$FRAMEWORK_DIR/composeResources" ]; then
  DEST="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/compose-resources"
  mkdir -p "$DEST"
  cp -R "$FRAMEWORK_DIR/composeResources" "$DEST/"
  echo "Copied composeResources to $DEST"
else
  echo "warning: composeResources not found at $FRAMEWORK_DIR"
fi
