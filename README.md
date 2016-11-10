# Description #
Passgen - unique password generator written using Qt Quick Controls 2. Generates password based on (web) service name and master-password. Any inputted data or generated password doesn't be stored.

**Disclaimer.**
Password generation algorithm is based on whirlpool hashing and isn't cryptographically resistant. Doesn't use this app for such important things like encryption passwords.

# Platforms #
In theory it supports all platforms that Qt does, but i've tested it on:

* Arch linux with gcc 6.2
* Android 5.0.2 with gcc 4.9

# Build requirements #
* Qt >= 5.7
* Compiler with c++11 support.

# Build #
To build passgen shure that all dependencies is properly installed. Clone repo and ```cd```  inside. Then :
```
mkdir build
cd build
qmake ../
make -j4
```

# License notes #
* Distribute over MIT license. 
* Whirlpool hash implementation: https://github.com/rhash/RHash. (RHash license)
* Icons from Qt quick controls 2 example https://github.com/qt/qt5 (GPL/LGPL)