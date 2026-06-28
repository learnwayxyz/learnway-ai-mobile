#!/bin/bash

echo "Firebase Config Setup"
echo "Configuration: ${CONFIGURATION}"

if [[ "${CONFIGURATION}" == *"dev"* ]] || [[ "${CONFIGURATION}" == *"Dev"* ]]; then
    CONFIG_PATH="${SRCROOT}/Runner/Firebase/Dev/GoogleService-Info.plist"
    echo "Using Dev Firebase config"
elif [[ "${CONFIGURATION}" == *"staging"* ]] || [[ "${CONFIGURATION}" == *"Staging"* ]]; then
    CONFIG_PATH="${SRCROOT}/Runner/Firebase/Staging/GoogleService-Info.plist"
    echo "Using Staging Firebase config"
else
    CONFIG_PATH="${SRCROOT}/Runner/Firebase/Prod/GoogleService-Info.plist"
    echo "Using Production Firebase config"
fi

if [ ! -f "$CONFIG_PATH" ]; then
    echo "Error: Firebase config not found at: $CONFIG_PATH"
    exit 1
fi

DEST_PATH="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"
cp -f "$CONFIG_PATH" "$DEST_PATH"
echo "Copied Firebase config to: $DEST_PATH"