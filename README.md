# Alias
Simplify your commands

<p align="center">
    <a href="<p align="center">
    <a href="https://appcenter.elementary.io/com.github.bartzaalberg.alias">
        <img src="https://appcenter.elementary.io/badge.svg" alt="Get it on AppCenter">
    </a>
</p>

<p align="center">
    <img
    src="https://raw.githubusercontent.com/bartzaalberg/alias/master/screenshot.png" />
</p>

### alias for elementary OS

A tool to manage your bash aliases.

## Installation

First you will need to install elementary SDK

 `sudo apt install elementary-sdk`

### Dependencies

These dependencies must be present before building
 - `valac`
 - `gtk+-3.0`
 - `granite`

 You can install these on a Ubuntu-based system by executing this command:

 `sudo apt install valac libgtk-3-dev libgranite-dev`


### Building
```
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make
```

### Installing
`sudo make install`
