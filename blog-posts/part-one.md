# An introduction to the magical world of software emulation with Swift

## Overview

- Intro
- Selecting the hardware to emulate (scope)
    - Accuracy vs happiness
    - High-level vs low-level languages
    - HLE vs LLE
- Exploring the CPU
    - 16-bit address space
    - 8-bit data bus
    - Registers
    - PC
    - SP
    - Flags
    - Instruction format
    - Cycles
- The instruction set
    - The basic architecture
    - Counting cycles
    - Handling branching
    - Writing instructions for insane people
    - Writing instructions for pragmatic people

## Intro

As a teenager in the early 2000's, tinkering with PCs and sinking countless hours into online gaming was a favourite pastime of mine. Nothing gave me the warm fuzzies more than throwing Gran Turismo into my CD-ROM and seeing the Playstation startup screen come to life on whatever semi-legal emulator was around at the time.

Throughout my career as a software developer I had always toyed with the idea of attempting to write an emulator of my own. Having spent the majority of my working life in the higher levels of the computing stack -- I had always found the prospect of going lower to be overly daunting or intimidating.

In this series of articles I will attempt to demistify some parts of the emulation black box and shed some light into an area of software development that the vast majority of programmers won't necessarily get to experience in their day-to-day work.

This article is aimed at absolute beginners (such as myself) who generally work with high-level programming languages, and who don't necessarily need to understand the ins-and-outs of the hardware onto which they deploy their code. As such, a lot of the terminology I use and concepts I describe may not be completely accurate -- but will hopefully serve as a general purpose guide for further exploration.

> DISCLAIMER: the purpose of this writing is not to develop a working emulator from scratch, but to provide some guidance on how this could be achieved using comparable hardware. My goal is to focus more on the delightful aspects of emulator development than on the mundane nitty-gritty details.

## Selecting an emulation target

As a way to motivate myself to learn yet another high-level programming language (Swift), I set myself a goal of writing a basic emulator for one of my favourite childhood consoles - the original 1989 Nintendo Game Boy handheld (also referred to as the Game Boy DMG).

The choice of the hardware to emulate is important because..

Indeed, a basic emulator for the Game Boy can be written just as well in [JavaScript](https://github.com/juchi/gameboy.js/) as it might be using a systems-level programming language such as [Rust](https://rylev.github.io/DMG-01/).