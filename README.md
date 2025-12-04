# Advent of Code

This repository documents my attempts to solve the [Advent of Code](https://adventofcode.com/) challenges.

Note: I somehow never heard of Advent of Code until 2024, so anything prior to that is me going back and solving previous years' challenges.

In the past, I've used challenges like [Project Euler](https://projecteuler.net/) (where I've solved the first 128 problems 😌) to learn new languages, which I didn't do in 2024 due to time pressure, but I have done in some of my historic backtracking. In particular, I have enjoyed playing around with [Janet](https://janet-lang.org/).

![My Project Euler profile](https://projecteuler.net/profile/dlej.png)

## 2015

Going back to the first year, I've begun solving some problems in Janet.

Day 4 was a bit tricky - MD5 isn't built into Janet. I started trying to leverage the unix `md5` command, but that was incredibly slow, which surprised me. In the end I wrote a [small C extension](2015/4/md5.c) to compute MD5 hashes, which got the answer in a few seconds even for the 6-zero variant.
Day 20 turned out to also be a but too computationally intensive for Janet, so I wrote [another C extension](2015/20/day20.c) for that one, too, for the heavy lifting of computing the divisor function.

## 2016

Continuing onto the second year, I'm doing more Janet.

Day 9 was a particularly fun way to dig deeper into [parsing expression grammars (PEGs)](https://en.wikipedia.org/wiki/Parsing_expression_grammar), which Janet has very nice native support for. I actually always parse my inputs using PEGs in Janet, but for this problem I was able to use PEGs to do all of the heavy lifting - first to perform the decompression in Part 1 and then to parse the nested decompressions as a tree in Part 2. I couldn't figure out a good way to do the recursion in pure PEG for Part 2, so I had to resort to calling a function from the PEG that ran the PEG again, but maybe there is a more clever way to do it?

Day 10 was an opportunity to dig into fibers and Janet's [`ev` module](https://janet-lang.org/api/ev.html) as a way to implement the bot DAG. I'm still not sure if there's a way to properly await a fiber sent to the event loop, but creating a dedicated output fiber for collecting bot outputs was a decent hack that let me avoid writing a polling loop.

## 2023

Before starting Advent of Code 2024, I warmed up on a few problems from 2023 in Python.

## 2024

**Language:** I chose to code all of my solutions in basic "numeric Python" - that is, standard libraries in Python + NumPy.
NumPy just makes working with grid-based data a lot easier, and often faster.

**Timing:** I usually go for speed of implementation rather than speed of execution, but execution time shouldn't be crazy.
If it takes more than a few seconds to run, there's probably a much better way to do it, which I'll try to go for.

## 2025

**Language:** I'm _upping the ante_ this year by doing everything in Janet. Going a step further, I'm trying to get a better mastery of PEGs, and so will try to implement as much as I can in them, as time permits.

Day 3 was my first big PEG use case. I was able to write both parts as a generic PEG accepting a number of digits as a parameter, and the PEG computed the entire result including the sum! I also figured out that the `sub` pattern does what I was missing back in 2016 Day 10, so I had no need to hack together an external function to call another PEG.
