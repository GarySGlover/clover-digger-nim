# Package

version       = "0.1.0"
author        = "Gary Glover"
description   = "Clover Digger keyboard firmware"
license       = "MIT"
srcDir        = "src"
bin           = @["clover_digger_nim"]


# Dependencies

requires "nim >= 2.0.2"
requires "picostdlib >= 0.4.0"

include picostdlib/build_utils/tasks
