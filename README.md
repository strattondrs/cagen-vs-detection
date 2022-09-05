# cagen-vs-detection
Visual Studio detection improvements

This repository contains slightly updated BAT files for detecting the Visual Studio tools
required for C/C++ builds where the Build Tools don't align perfectly with the Visual Studio
of interest.

For example, supporting the VS 2019 C/C++ tools (certified) in a VS 2022 IDE environment (not
certified)

It is based on the PTF level `RTN86208`.

A properly licensed [CA Gen](https://www.broadcom.com/products/mainframe/application-development/gen)
install is required for this to work.