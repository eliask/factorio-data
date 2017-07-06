# factorio-data
Factorio data extracted with a Lua interpreter.

This repository contains data extracted from different versions of Factorio
using a version of [factorio-recipe-extraction](https://github.com/CodeLenny/factorio-recipe-extraction).
The basic approach stubs any globals and runs the Lua data files in an interpreter.

The data corresponds directly to the top-level "data" object.

This repository deprecated the earlier [factorio-data](https://github.com/eliask/factorio-data-old)
which I forked from [another repository by slikts](https://github.com/slikts/factorio-data) as parsing is inaccurate and is the Wrong Way (tm) to do it.
