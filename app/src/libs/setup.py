from setuptools import setup, find_packages
from pathlib import Path
import shutil

SETUP_DIRECTORY = Path(__file__).parent
SRC_FOLDER = SETUP_DIRECTORY.parent
APP_FOLDER = SRC_FOLDER.parent
BUILD_FOLDER = SETUP_DIRECTORY.joinpath('build')
EGG_INFO_FOLDER = SETUP_DIRECTORY.joinpath('libs.egg-info')

with open(APP_FOLDER.joinpath('requirements.txt')) as f:
    requirements = f.readlines()

finded_packages = find_packages()
finded_packages = [f'libs.{package}' for package in finded_packages]
finded_packages.append('libs')


if 'build' in finded_packages:
    raise Exception("You can't have a package named 'build' in your libs folder")

setup(
    name="libs",
    version="0.1",
    packages=finded_packages,
    install_requires=requirements,
    package_dir={"libs": "."}
)

shutil.rmtree(BUILD_FOLDER, ignore_errors=True)
shutil.rmtree(EGG_INFO_FOLDER, ignore_errors=True)