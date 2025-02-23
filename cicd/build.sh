# Check if a virtual environment is active
if [ -z "$VIRTUAL_ENV" ]; then
    echo "No virtual environment is active. Creating and activating one..."
    python -m venv .venv
    source .venv/bin/activate
    echo "Virtual environment created and activated: $VIRTUAL_ENV"
else
    echo "A virtual environment is already active: $VIRTUAL_ENV"
fi


echo "Installing dependencies (wheel and build)..."
pip install wheel build

echo "Building dependencies..."
python -m build --wheel --outdir ./app/dependencies/ ./app/src/libs