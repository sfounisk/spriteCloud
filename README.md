# QA reqres/saucedemo Automation


# User Guides

[Robot Framwork](http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html)


# Quickstart

To run Robot Framework on your local machine, you need to install these dependencies:

* [Python 3.13](https://www.python.org/)
* [Git](https://git-scm.com/)


## Create virtual environment

While you are in the folder with the code files, you need to create a virtual environment and install our required packages.

### For windows

In `Git Bash`
```
python -m venv ../sprite_venv
source ../sprite_venv/scripts/activate
pip install -r requirements.txt
```

If you have multiple python versions installed please make sure you are using python3 when
creating the virtual environment, by passing the python 3 root during creation

Example: `c:\Python35\python -m venv ../android_venv`

## For Mac / Linux
```
python3 -m venv ../sprite_venv
source ../sprite_venv/bin/activate
pip install -r requirements.txt
```

## How to run test(s)
### Single file:
```
robot <file_name>.robot
```

### Single test
```
robot -t "Test_title" *.robot
```

### The entire suite
```
robot *.robot
```