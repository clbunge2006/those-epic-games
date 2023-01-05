# Epic Games Autograbber

Originally written as a script to share between friends, may write a more detailed readme soetime in the future.

## Requirements
These programs must be installed and up-to-date to ensure functionality.
 * [Git](https://git-scm.com/downloads)
 * [NodeJS](https://nodejs.org/download/)
 * [Python3](https://www.python.org/downloads/)

## How to install:
*(A quick note, as the install batch file needs to be run as administrator, please look into the source code to make sure for yourself that there is no malicious activity)*

1. Download this repository; `git clone https://github.com/clbunge2006/those-epic-games/` or download and unpack a zip from github
2. Initialise submodules; `git submodule init && git submodule update`
3. Install needed wheel packages for DeviceAuthGenerator; `pip install -U wheel && pip install -U -r DeviceAuthGenerator/requirements.txt`
4. Run DeviceAuthGenerator and sign in when prompted; `python DeviceAuthGenerator/generator.py` *if this errors, attempt to run with python3 instead of python*
5. Copy the generated authenticated json to freebies-claimer; `cp DeviceAuthGenerator/device_auths.json epicgames-freebies-claimer/data`
6. Run the provided batch file, **run.bat**, to setup automatic execution; `run.bat` *be sure to run this in administrator mode* 

![Oh how i love the epic games store!](https://media.tenor.com/GLTbAke0WUAAAAAC/epic-games-epic.gif)
