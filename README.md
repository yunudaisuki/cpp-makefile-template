# C++ Makefile Template

A small, no-fuss Makefile for C++23 projects.
I made this for practice exercises and personal experiments, the kind of project where you just want to drop a few `.cpp` files in a folder and type `make`. It finds your source files on its own, only rebuilds what actually changed, and keeps track of header dependencies, so you can spend your time on the code instead of the build.

## What you get

- C++23 out of the box
- Every `.cpp` file in the project root is picked up automatically
- Incremental builds: only the files that changed get recompiled
- Header dependency tracking, so editing a `.h` rebuilds whatever includes it
- Three commands cover the whole workflow: `make`, `make run`, `make clean`
- Works with GCC and Clang (Linux and Windows, as long as your toolchain and GNU Make are set up properly)

## What you need

- GNU Make
- `g++` or `clang++`
- A compiler recent enough to support the C++23 features you use

## Getting started

Clone the repo:

```bash
git clone https://github.com/yunudaisuki/cpp-makefile-template.git
cd cpp-makefile-template
```

Put your `.cpp` and header files in the project root, then:

```bash
make        # build
make run    # build (if needed) and run
make clean  # remove build files
```

## Picking a compiler

It uses GCC (`g++`) by default. Want Clang instead? No need to touch the Makefile:

```bash
make CXX=clang++
```

Not sure what you have installed?

```bash
g++ --version
clang++ --version
```

MSVC (`cl.exe`) isn't supported. It uses completely different command-line options, so it would need its own build setup.

## Compiler flags

Here's what the Makefile uses by default:

```makefile
CXXFLAGS := -std=c++23 -Wall -Wextra -Wpedantic -g -MMD -MP
```

A quick tour of the flags you're most likely to tweak:

**Language standard**: swap `-std=c++23` for `-std=c++17` or `-std=c++20` if your project or compiler needs it.

**Warnings**

| Flag           | What it does                                      |
| -------------- | ------------------------------------------------- |
| `-Wall`        | Common warnings                                   |
| `-Wextra`      | A few more on top of `-Wall`                      |
| `-Wpedantic`   | Warns about non-standard extensions               |
| `-Wshadow`     | Warns when a declaration shadows another one      |
| `-Wconversion` | Warns about conversions that might change a value |
| `-Werror`      | Turns warnings into errors                        |

Heads up: `-Wall` doesn't actually enable everything, `-Wconversion` can get noisy, and `-Werror` can break your build when a newer compiler adds new warnings. Turn those on when you mean to.

**Debugging and optimization**

| Flag       | What it does                       |
| ---------- | ---------------------------------- |
| `-g`       | Adds debug info                    |
| `-O0`      | No optimization                    |
| `-O1`      | Light optimization                 |
| `-O2`      | The usual choice for release builds |
| `-O3`      | More aggressive optimization       |
| `-DNDEBUG` | Disables `assert` checks           |

`-g -O0` is a good starting point for debugging, and `-O2 -DNDEBUG` is a common choice for release.

**Sanitizers**

GCC and Clang can catch memory errors and some undefined behavior at runtime:

```makefile
CXXFLAGS += -fsanitize=address,undefined -fno-omit-frame-pointer
LDFLAGS  += -fsanitize=address,undefined
```

Don't forget to pass the sanitizer flags to the linker too, not just the compiler. Support varies by compiler and platform.

**Dependency tracking**

`-MMD -MP` makes the compiler generate `.d` files that list which headers each source file depends on. The Makefile includes them automatically, so you don't have to do anything. Just leave these two flags in.

## Build profiles

A few ready-to-use setups. Run `make clean` before switching between them, because all profiles share the same object files.

**Debug**

```bash
make clean
make CXXFLAGS="-std=c++23 -Wall -Wextra -Wpedantic -g -O0 -MMD -MP"
```

**Release**

```bash
make clean
make CXXFLAGS="-std=c++23 -Wall -Wextra -Wpedantic -O2 -DNDEBUG -MMD -MP"
```

**Sanitizers**

```bash
make clean
make CXXFLAGS="-std=c++23 -Wall -Wextra -Wpedantic -g -O1 -fsanitize=address,undefined -fno-omit-frame-pointer -MMD -MP" LDFLAGS="-fsanitize=address,undefined"
```

## Customizing it

Everything you'd want to change is at the top of the Makefile:

- `CXX`: the compiler
- `CXXFLAGS`: compiler options
- `CPPFLAGS`: preprocessor options, like `-Iinclude`
- `LDFLAGS`: linker options
- `LDLIBS`: libraries to link
- `TARGET`: name of the output executable

For example, to keep your headers in an `include` folder:

```makefile
CPPFLAGS += -Iinclude
```

Or to link the math library:

```makefile
LDLIBS += -lm
```

Library names and linker flags differ between platforms, so adjust them for yours.

## Things to know

- Source files are only discovered in the project root, not in subfolders.
- It needs GNU Make.
- On Windows, whether it works depends on your compiler, shell, and Make setup.
- It's built for small projects, not complex multi-directory builds.
- Switching build configurations means running `make clean` first.
- Windows: Install GNU Make with winget install ezwinports.make (or via Chocolatey/Scoop). MinGW ships it as mingw32-make, so you may need to rename or copy it to make.exe.

## License

MIT. See LICENSE for details.
