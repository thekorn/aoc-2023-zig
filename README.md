# Advent of Code 2023 in zig

See [Advent of Code 2020](https://adventofcode.com/2020) for more information.

## how to run

You need zig 0.11 or later to run this code.
If you dont have zig installed, you can use a nix shell which includes all required dependencies.

```bash
$ nix-shell --run zsh
```

Within the shell you have can run every day, by

```bash
$ zig build day01
```

and the test for each day by

```bash
$ zig build test_day01
```

(Replace `day01` with the day you want to run.)