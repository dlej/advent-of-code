# Advent of Code

This repository documents my attempts to solve the [Advent of Code](https://adventofcode.com/) challenges.

Note: I somehow never heard of Advent of Code until 2024, so anything prior to that is me going back and solving previous years' challenges.

In the past, I've used challenges like [Project Euler](https://projecteuler.net/) (where I've solved the first 128 problems 😌) to learn new languages, which I didn't do in 2024 due to time pressure, but I have done in some of my historic backtracking. In particular, I have enjoyed playing around with [Janet](https://janet-lang.org/).

![My Project Euler profile](https://projecteuler.net/profile/dlej.png)

## 2015

Going back to the first year, I've begun solving some problems in Janet.

Day 4 was a bit tricky - MD5 isn't built into Janet. I started trying to leverage the unix `md5` command, but that was incredibly slow, which surprised me. In the end I wrote a [small C extension](2015/4/md5.c) to compute MD5 hashes, which got the answer in a few seconds even for the 6-zero variant.

## 2023

Before starting Advent of Code 2024, I warmed up on a few problems from 2023 in Python.

## 2024

**Language:** I chose to code all of my solutions in basic "numeric Python" - that is, standard libraries in Python + NumPy.
NumPy just makes working with grid-based data a lot easier, and often faster.

**Timing:** I usually go for speed of implementation rather than speed of execution, but execution time shouldn't be crazy.
If it takes more than a few seconds to run, there's probably a much better way to do it, which I'll try to go for.
