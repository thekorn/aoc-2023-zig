# Advent of Code 2023 in zig

![Build](https://github.com/thekorn/aoc-2023-zig/actions/workflows/actions.yaml/badge.svg)

See [Advent of Code 2023](https://adventofcode.com/2023) for more information.

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

## Reference

* project setup is based on [this template](https://github.com/SpexGuy/Zig-AoC-Template/tree/main)
* [blog post with inspiration](https://www.huy.rocks/everyday/12-11-2022-zig-using-zig-for-advent-of-code)