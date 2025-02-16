from setuptools import setup, find_packages
from pathlib import Path
import shutil



CURRENT_FILE_DIRECTORY = Path(__file__).parent
APP_FOLDER = CURRENT_FILE_DIRECTORY.parent
BUILD_FOLDER = CURRENT_FILE_DIRECTORY.joinpath('build')
EGG_INFO_FOLDER = CURRENT_FILE_DIRECTORY.joinpath('libs.egg-info')

with open(APP_FOLDER.joinpath('requirements.txt')) as f:
    requirements = f.readlines()

finded_packages = find_packages(where="libs")

if 'build' in finded_packages:
    raise Exception("You can't have a package named 'build' in your libs folder")

setup(
    name="libs",
    version="0.1",
    packages=finded_packages,
    package_dir={"": "libs"},
    requires=requirements
)

shutil.rmtree(BUILD_FOLDER, ignore_errors=True)
shutil.rmtree(EGG_INFO_FOLDER, ignore_errors=True)