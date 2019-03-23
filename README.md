# MultiCalc

A small macOS tool that allows to run multiple system Calculator apps.

![Example Screenshot](https://github.com/vashpan/multi-calc/raw/master/Documentation/Example%20Screenshot.png)

*Currently tested with macOS 10.14.x and Xcode 10.1*

## Motivation

For some reason, macOS system calculator - Calculator.app doesn't allow to create more calculator windows, macOS itself also doesn't allow for multiple apps instances. This application overrides this by doing exactly this - starting & quitting multiple Calculator.app instances, with some small improvements like tweaking it's initial windows position.

Having multiple calculators could be helpful in some situations so now on macOS you can do it with this easy tool.

## Usage

Application runs in a status bar, click once to open a new Calculator instance. Right click to access menu to close all Calculators or quit this utility. Add it to your "Startup Items" in your user settings if you want it to start everytime you log-in to your Mac.

## Caveats

Moving new Calculator.app instance before running is a bit of hack, requires modifying its properties. Unfortunately Calculator.app is sandboxed, and apparently sandboxed apps doesn't work with `CFPreferencesCopyAppValue` family of functions to read other apps user defaults. So currently MultiCalc just changes values directly in Calculator.app user defaults `.plist` file, which is not really reliable and sometimes change could not be applied. If someone knows better way to handle that, or a way to properly change user defaults of sandboxed apps, let me know! 
