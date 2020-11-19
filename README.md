# RedisDesktopManager-Mac 

This repository provides a shell can compile [RedisDesktopManager](https://github.com/uglide/RedisDesktopManager), as well as a compiled DMG file.

Latest version: 2020.5

![screenshots](https://raw.githubusercontent.com/zgr0629/RedisDesktopManager-Mac/master/screenshots.png)

## Usage

Install qt

```shell
brew install qt
```

Install python

```shell
brew install python@3.7
```

Install python requirements

```shell
pip3 install -r https://raw.githubusercontent.com/uglide/RedisDesktopManager/2020/src/py/requirements.txt --upgrade
```

Download latest DMG file from [release](https://github.com/zgr0629/RedisDesktopManager-Mac/releases) page. Load Dmg file and drag .app file to your Application folder and enjoy.

If you have any questions, please feel free to submit an issue.

##Update for Big Sur

Big sur is missing CoreFoundation, this `rmd.sh` will meet an error like:

```bash
clang: error: no such file or directory: '/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation'
clang: error: no such file or directory: '/System/Library/Frameworks/CoreServices.framework/Versions/A/CoreServices'
make: *** [../bin/osx/release/RDM.app/Contents/MacOS/RDM] Error 1
```

Thanks to https://github.com/FuckDoctors/rdm-builder, I build a github action to build RDM.app
