#!/bin/bash

# This script automates the build and deployment of a web project to a Tomcat server.
# It's designed to be more robust and flexible for use in a CI/CD pipeline like Jenkins.

# --- Script Configuration ---
# Exit immediately if a command exits with a non-zero status.
# This ensures that the script will stop if any step fails.
set -e

# --- Variables ---
# The script now accepts the Tomcat deployment path as an argument.
# If you don't provide an argument when running the script, it will use the default path.
# This makes it easy to configure in Jenkins without changing the script itself.
DEFAULT_TOMCAT_PATH="/opt/tomcat/webapps/projecttom"
TOMCAT_PATH="${1:-$DEFAULT_TOMCAT_PATH}"
PROJECT_NAME=$(basename "$TOMCAT_PATH")

echo "---"
echo "🚀 Starting Deployment for: $PROJECT_NAME"
echo "Deployment Target: $TOMCAT_PATH"
echo "---"


# --- 1. Install Dependencies ---
# Installs all the necessary node modules defined in package.json.
echo "Step 1: Installing npm dependencies..."
npm install
echo "✅ Dependencies installed."
echo "---"


# --- 2. Build Project ---
# Runs the 'build' script defined in your package.json to compile the application.
echo "Step 2: Building the project..."
npm run build
echo "✅ Project built successfully. Artifacts are in 'dist/'."
echo "---"


# --- 3. Deploy to Tomcat ---
# Copies the built application files to the Tomcat webapps directory.
echo "Step 3: Deploying to Tomcat..."

# Clean the old deployment to ensure a fresh start.
if [ -d "$TOMCAT_PATH" ]; then
    echo "   - Found existing directory. Removing old deployment..."
    rm -rf "$TOMCAT_PATH"
    echo "   - Old deployment removed."
else
    echo "   - No existing directory found. A new one will be created."
fi

# Recreate the deployment folder.
echo "   - Creating deployment directory: $TOMCAT_PATH"
mkdir -p "$TOMCAT_PATH"

# Copy the new build files from the 'dist' directory to the Tomcat path.
echo "   - Copying new build files..."
cp -R dist/* "$TOMCAT_PATH"

echo "✅ Deployment complete!"
echo "---"
echo "🎉 Successfully deployed $PROJECT_NAME to Tomcat."
echo "---"
