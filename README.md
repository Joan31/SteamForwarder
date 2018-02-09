# SteamForwarder
![https://travis-ci.org/xomachine/SteamForwarder](https://travis-ci.org/xomachine/SteamForwarder.svg?branch=master)

steam_api.dll implementation for wine. Your windows games now can interact with your linux steam!

# ! DISCLAIMER !
**The author is not liable for any damage resulting from the use of this software. User might break his games, steam, OS or even computer. User account might to be banned by Valve. EVERYTHING THAT YOU'RE DOING, YOU'RE DOING ON YOUR OWN RISK!**

## Restrictions
There are a few known problems with this tool. Some of them will be solved in future, others are not solvable.

SteamForwarder is NOT able to run by design:

* Games what trying to detect steam process bypassing steam\_api.dll
* Games with statically linked steam\_api.dll

SteamForwarder is NOT able to download:

* Everything that steamcmd are not able to download (mostly paid games with protection)

For pre-2014 steam api it's recomended to use
[SteamBrige](https://github.com/sirnuke/steambridge)

## Usage dependencies
* steamcmd (not required with experimental flag `--steamnative`)
* nim 0.17.3 or higher (to generate and compile a bunch of wrappers code)
* python3 (for installer script)
* wine-devel (including winedump, winegcc and headers)
* binutils (libopcode.so and libbfd.so in particular)

Addinional dependences to build:
* binutils-devel (including bfd.h and dis-asm.h)

## Usage

This is a common usage scenario of SteamForwarder for users.
Some hints for experts can be found in the section below.

* Download redist.tar.bz2 from latest release of SteamForwarder from releases page
* Unpack it to the folder you want
* Open the terminal in the folder SteamForwarder was unpacked
* Type `python3 app_install.py --help` to learn command line options of installer tool.
* Use app\_install.py to install your windows game. E.g. for Paladins it command will be `python3 app_install.py 444090`. The steam appid of the game can be found in the url of the game page on the steam store site.
* Launch your linux **steam** (don't allow it to update your windows games if they support MacOS either)
* Run installed game via runscript generated. (Its location will be printed after app\_install.py will install the game.)

Some tips:
* If you dont want to install steamcmd, it is possible to avoid it by using `--steamnative` flag in `sf_install`
* If the game does not installing with typical method try to use `--depot` option
* There is `install` target for `make`, so you can build a package or install SteamForwarder to your system. Don't forget about PREFIX and DESTDIR variables.
* If `app_install.py` can not write the run script or can not find steam\_api.dll check the game installation, it may be not even installed. In other case, it might be incompatible with SteamForwarder

## Found a bug?
Feel free to post the issue. Don't forget to attach the wine log with `WINEDEBUG=trace+steam_api` environment variable set.
If you're starting the game from the runscript generated by the **app_install.py** the required log can be found in the
runscript folder (it's named **lastrun.log**).
If you know how to improve SteamForwarder or even already improved it in your fork, your Pull Request will be appreciated!
Any poor-languachisms, mistakes and other text-related issues also can be considered as bugs.

## Implementation details
The SteamForwarder may be represented as two almost independent parts:
steam\_api.dll.so and service tools. Service tools may also be
devided to user tools and developer tools.

For a moment there is only one user tool - `sf_install`. This script
tells steam or steamcmd to download the game and prepares SteamForwarder to work
with this game, including the run scripts creation and steam\_api.dll.so building.
It has arbitary user-friendly interface with many settings managed by command
line switches.

Another pair of tools can be related to developers tools. Their work invisible
for ordinal user. But before describing them, it is necessary to describe the
build process. So the target of whole build process is a steam\_api.dll.so
library which implements everything implemented in steam\_api.dll file from
the game installed. The target library should forward every call to the
libsteam\_api.so library on linux side. The building of steam\_api.dll.so
starts from gathering information about original steam\_api.dll. There are
two kinds of information: version dependent and version independent.

The version dependent information is represented by the library's exported
symbols and can be obtained via `winedump` tool from wine-devel.
As the result, there is steam\_api.spec file will be created. But the
information from this file is not enough to build the library: there aren't
any information about the symbols arguments. In previous versions of
the SteamForwarder this problem was solved by parsing header files which
Valve supplies to game developer. But headers are only available for latest
steam API version and their usage for old steam games causes problems.
The solution of such a situation was found in parsing various versions
of libsteam\_api.so and search for mostly compatible with original
steam\_api.dll, then extract the information about amount of symbol arguments
via the `dllparser` tool.

Another part of information - version independent. This one should be extracted
from steamclient.so and not dependent from steam\_api.dll. The extraction is
being performed by `sigsearch` tool. The tool provides information about
steam API classes and their methods. As soon as this information does not
depend on game, it was included to this repository at file signatures.txt.

When both of information kinds is collected, the build stage begins.
Main job which is being done by steam\_api.dll.so is
ABI conversion from MSVC calling conventions to GCC ones and vise versa.
It means that a little chunk of the wrapping code should be added to
each steam API function or method. The wrapping code in almost all cases
is very similiar. Implementing it by hands could make me crazy.
Thats why steam\_api.dll.so is implemented in the Nim programming language.
Nim has wonderful metaprogramming abilities and compiles directly to C,
so I can rely on a few macros to generate the whole steam API.
