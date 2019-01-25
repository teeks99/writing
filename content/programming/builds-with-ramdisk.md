Title:  "Building with a Ramdisk"
Date:   2019-01-23 22:00:00 -0600

Building with a Ramdisk
=======================

TL;DR: Ramdisks don't help build times.

I've long been thinking that C++ build times were often disk IO limited. The
biggest thing that lead me to think that was the speedup in build times when I 
moved from spinning disks to SSDs. I don't have any numbers for it, but 
anecdotally it was a big speedup. 

I recently got some time on Microsoft Azure's F72 VM, with 72 compute cores and
144GB of RAM. Just to see it fly, I ran my [Boost Windows Build](https://github.com/teeks99/boost-release-windows) on it, and was somewhat 
underwhelmed by the results. This got me thinking that maybe the build was
limited by the disk IO to the machine. Thinking about ways to solve this, I 
remembered from my time in the 90s that there are pieces of software called 
"Ramdisks" that let you have a virtual hard disk that is backed by system
memory, so won't be affected by the typical limits of spinning or SSD disks.

After looking around, I found an open source tool called 
[ImDisk](https://sourceforge.net/projects/imdisk-toolkit/) that allows you to
create Ramdisks on windows (Linux comes with the [/run/shm ramdisk](https://www.cyberciti.biz/tips/what-is-devshm-and-its-practical-usage.html)
 enabled by default). 

Once I had that, I decided to run some tests. Since I work with 
[Boost](https://www.boost.org/) a lot, I'm using a couple different tests from
there.

*   Windows Binary Build - Each release, I 
    [build and package](https://github.com/teeks99/boost-release-windows) the 
    windows binaries for boost. This runs several version of Visual Studio 
    (msvc-10.0 through msvc-14.1) in several configurations: Debug/Release, 
    mt/mtdll, static/dynamic, 32/64. This also packages up the build with 
    [7-zip](https://www.7-zip.org/) and
    [Inno Setup](https://github.com/jrsoftware/issrc).
*   Boost Regression Test Suite - I 
    [run this](https://github.com/teeks99/boost-build) regularly across several
    machines (and a lot of 
    [docker containers](https://github.com/teeks99/boost-cpp-docker)), and have
    good data on how long it takes to run.

Test Machines
-------------

*   F72
    *   72 Core (Intel Xeon Platinum 8186 @ 2.70GHz)
    *   144GB Ram
    *   576GB Temp Storage
    *   $5.86/hr (Windows) $3.045/hr (Linux)
*   F16
    *   16 Core
    *   32GB Ram
    *   256GB Temp Storage
    *   $1.53/hr (Windows) $.0796/hr (Linux)
*   Local VM
    *   8 Core
    *   16GB Ram
    *   100GB Temp Storage
    *   $600 amortized over the last 2.5yrs + electricity

On the machines with more than 100GB of RAM, I created a ramdisk with 
[ImDisk](https://sourceforge.net/projects/imdisk-toolkit/). For the 
build/package tests, I ran my standard [build for windows releases](
https://github.com/teeks99/boost-release-windows) scripts for a build of 1.69.
I ran (including creation of packages) from the ramdisk and from the azure 
temp storage (a local SSD).  Because the smaller machines couldn't run the
whole thing in the ramdisk, I ran single builds on them where possible. For the
[regression tests](https://github.com/teeks99/boost-build), I was only able to 
run in a ramdisk on the F72 machine, but was able to run under both linux and
windows.

Results
-------

Boost release build

| Machine | Ram Build, Pkg | SSD Build, Pkg   | Ram Single | SSD Single |
| ------- | -------------- | ---------------- | ---------- | ---------- |
| F72     | 26:46, 1:01:55 | 26:06, 43:24     | 2:09       | 2:08       |
| Local   |                | 1:49:30, 1:24:35 |            | 11:18      |
| F16 Cha |                | 1:03:38, 1:25:29 | 5:11       | 5:21       |

Boost regression test

| Machine | Win Ram Test | Win SSD Test | Linux Ram Test | Linux SSD Test |
| ------- | ------------ | ------------ | -------------- | -------------- |
| F72     | 1:19:12      | 1:12:35      | 57:00          | 57:00          |
| Local   |              | 2:31:24      |                | 2:06:00        |
| F16 Cha |              | 1:57:35      |                | 1:15:35        |

Initially when I ran, the Inno Setup task was taking much longer. However, I 
went on a tangent exploration, and found the 
[best settings for running parallelized](https://github.com/teeks99/inno-test/).

Conclusion
----------

It turns out that ramdisks don't do a thing to build times. Clearly modern
compilation isn't bound by storage I/O. On the other hand it was hard to get
the F72 machine to spike all the CPUs. This could indicate that there just isn't
enough parallelization in the build system. I know from watching that big swaths
of the regression test is taken up by single threaded tasks (git updates,
setup, etc.). I'd be curious to take a more modern build system like 
[ninja](https://ninja-build.org/) for a spin on an F72.