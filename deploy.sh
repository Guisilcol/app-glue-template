
echo "Installing dependencies to build dependencies"
pip install wheel build

echo "Building dependencies"
python -m build --wheel --outdir ./app/dependencies/ ./app/src