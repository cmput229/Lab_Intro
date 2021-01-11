# CMPUT 229 Lab 1 - The SPIM/QTSPIM Environment

## QTSPIM
QTSPIM is a Graphical User Interface (GUI) for the SPIM MIPS Simulator. It provides a graphical display showing assembly instructions, output, registers, and memory values to assist with writing and debugging MIPS assembly code. To launch QTSPIM, simply type `qtspim` in a terminal on your lab machine (or `qtspim &` to keep the terminal usable while running QTSPIM). While you are working in this assignment you may also want to open your favorite text editor, because you'll be answering questions as we go through.

To make it easier to write and run SPIM code on your home machine, you can install SPIM and QTSPIM from [SourceForge](http://spimsimulator.sourceforge.net). Be warned though that all of your projects will be run on lab machines, which may not behave the exact same way as the version you install. An alternative more likely to maintain compatibility is from Mac or Linux to `ssh` to `ohaton.cs.ualberta.ca` with the `-X` flag, enabling X forwarding. For Windows, a similar effect can be achieved using PuTTY and Xming, though the process is more in-depth, and will not be discussed here. Whenever writing your code at home, you should always test your final solution on the lab machines before submitting.

<p align="center">
  <img alt="QTSPIM Main Window" src="resources/imgs/mainWin.png" />
</p>

Next, let's run our first MIPS program. First, close QTSPIM and download [lab1-first.s]. Launch QTSPIM again. Click File>Load File and the choose the file you just downloaded. It is generally a good idea to click the Clear Registers button before running a program.


**Question 1:** What was the output of the program?

Next, lets understand what's going on when the program runs. Press the Clear Registers button to wipe out the memory and registers changed and setup for next run, then press the Single Step button.

When stepping through the assembly code, each instruction executed is highlighted in QTSPIM's Text Segment window, and the registers and data show you the internal state of the software, with register changes highlighted in red. Pressing `run` causes the program to execute from the current step. You can step through the program now, observing how the registers change.

**Question 2:** What is the maximum value, in hex, of register `$t0` during the execution of this program?

**Question 3:** What is the value of the PC immediately before the execution of the instruction that increments register `$t0` to its maximum value?

Stepping through one more time, watch for each execution of the load word (`lw`) instruction.

**Question 4:** How many times is load word executed, and what values are loaded? You may disregard the very first occurrence of a load word instruction, because that is not part of `lab1-first.s`.

Open up [lab1-first.s] in your favorite text editor. In the data segment, the string `Number = ` is a string whose address is the label `str`. In QTSPIM, while looking at the data segment find the string `Number` in memory. You may want to use an ASCII table to help identify the characters. An ASCII table is available [here](http://www.asciitable.com).

<p align="center">
  <img alt="Data Segments" src="resources/imgs/dataAddr.png" />
</p>

SPIM assumes the endianness of the machine where it is running. In the lab machine, it means that SPIM is using a little-endian layout. In a little-endian layout, the least significant byte of a number is stored in the lowest address. See the image above to see how memory addresses map to individual bytes.

**Question 5:** Write out the individual addresses of each letter in the string `Number`.

Data in memory have no inherent meaning, meaning is given solely by context. As an example we're going to interpret an instruction in code as various other types of data. Scroll using the side slider down to the instruction in Kernel Text at `0x800001C0`. The four bytes stored at that address form the binary representation of the instruction `andi $a0, $k0, 60`, but can also be interpreted in other ways.

**Question 6:** What would these four bytes represent if they were interpreted as 4 ASCII characters?

**Question 7:** What would these four bytes represent if they were interpreted as a two's complement integer?

## Directives
If you already have something loaded in QTSPIM, press the Clear Registers button before downloading [lab1-directives.s](resources/code/lab1-directives.s) and loading it into QTSPIM. This assembly file doesn't actually do anything but quit, though it shows off many of the available data directives in MIPS. Open up the file in your text editor.

**Question 8:** For each directive (statement beginning with a period) between `.data` and `.text`, give a brief description of its purpose and where it places data in SPIM's memory when loaded (if applicable).

To assist you in answering the above question, you'll want to match values in the assembly file to values in SPIM's Data section. You'll probably also want to consult pp. A-47 to A-49 (pages B-47 to B-49 in the 4th edition) in your text book (Assembler Syntax).

## Running SPIM via Terminal
While QTSPIM is very useful for debugging and visually understanding your code, sometimes you may want to run SPIM from a terminal window. To do this, you need to execute the command-line program `spim`.

To start SPIM, run an assembler file, and exit (non-interactive mode), simply run the command `spim -file ASSEMBLERFILE`, where `ASSEMBLERFILE` is the name of the file to run. This is the way to provide command-line arguments to a SPIM program and run SPIM over an SSH connection. SPIM can also be run in interactive mode, which allows debugging and breakpoints. To start SPIM interactively, just enter `spim` at a terminal. Then, to load your assembler file, type `load ASSEMBLERFILE`. To run the program type `run`. For a full list of SPIM's interactive commands, type `help`.

**Question 9:** From the interactive SPIM command line, how do you display the contents of only the register `$s0`?.

## Debugging in QTSPIM
Next, download [lab1-broken.s]. Open it in your text editor to see the code and read its intended purpose, then load it in QTSPIM and give it a run. While it completes successfully, it clearly is not doing what it is supposed to do. Step through the code, and track down the errors. **Write down a short description of the errors that you find in a text file called** `bugs.txt`.

## Writing A Simple Program
In this part of the assignment, you will write your first MIPS assembly program. Your program will perform endianness conversion, an operation that is commonly required when sending data over a computer network. Write a MIPS assembly program to read an integer from the terminal, invert the byte order of that integer, and then print out the new big-endian integer. For example, bytes 0 and 3 are swapped, and bytes 1 and 2 are swapped. Use any of the SPIM system calls you would like, though you may not read from or write to main memory. Refer to pages A-43 to A-45 (pages B-43 to B-45 of the 4th edition) in your textbook (System calls) for an explanation of how `syscall` functions work in SPIM. We suggest the following algorithm, though others are also correct:
* Read an integer into a register using the `read_int` syscall.
* Mask out the least significant byte, and shift it into its new position in a new register.
* Repeat the above step for the remaining 3 bytes, using or to keep the already calculated bytes.
* Print out the resulting number using the `print_int` syscall.

You only need to handle a single integer.

Your program must output only the converted integer, and no other unspecified characters (such as input prompts or newline characters). If your program fails to comply, the automated marking scripts will consider your output wrong.

**Question 10:** While this program only read and flipped a single integer, usually endianness conversions need to be done over entire blocks of memory. In this question, you are **not** asked to write assembly code. Consider that you have to write a subroutine that converts the endianness of several integer numbers. For example, your subroutine could receive three parameters: the address of a *source* memory block that contains the integers to be converted, the address of a *target* memory block where the converted integers should be placed, and the *number* of integers to be converted (*source* and *target* could be the same address if the endianness conversion is to be done in place). What control structure in assembly would you need to convert an entire block of integers, given that the number of integers to be converted will only be known at runtime?

## Resources

* Example showing how to format your code is here: [example.s](resources/code/example.s).
* Slides used for in-class introduction of the lab ([.pdf](resources/slides/class.pdf))
* Slides used for in-lab introduction of the lab ([.pdf](resources/slides/lab.pdf))
* Slides used to demonstrate debugging in the lab ([.pdf](resources/slides/lab-debugging.pdf))
* Version of the program with bugs: [lab1-pres-buggy.s](resources/code/lab1-pres-buggy.s)
* Corrected version of the program: [lab1-pres-correct.s](resources/code/lab1-pres-correct.s)

## Marking Guide
Here is the [mark sheet](MarkSheet.txt) used for grading. In particular, your submission will be evaluated for:
* answering questions correctly
* correct bug fixes
* correct functionality in simple program
* program style

## Submission
There are 3 files to submit for this assignment. They should be committed to the root of your private repo.
* `lab1.txt`: should contain answers to the questions on this page.
* `bugs.txt`: should contain descriptions of bugs found in [lab1-broken.s].
* `lab1.s`: should contain the assembly program you wrote in the last step.

You may work together with other students and use outside resources to help complete this lab, however you must **LIST ALL** collaborators and resources used in a comment at the top of your lab1.s file. It is ok to submit the exact same code as your other group members as long as you clearly state in the comment that your code is the same as {ccid} of your collaborators. Each group member should make their own submission in order to get feedback.

**Please make sure that you follow the link provided in the course eClass page for this lab assignment to get your own private GitHub repo for this lab. When prompted, make sure to link your GitHub account to your UAlberta ID, otherwise the teaching staff will not be able to grade your submission. If you do not recall whether or not you have previously linked your account, contact the teaching staff before the submission deadline.**

**To ensure that we have the latest version of your solution, make sure to commit your changes to the repo frequently. Otherwise, you may forget to commit your latest changes by the deadline (which will count as a late lab, and will not be graded). Your solution will be automatically collected via GitHub Classroom by the deadline.**

**Every file you commit to the repository MUST include the [CMPUT 229 Student Submission License](LICENSE.md) text at the very top, and you must include your name in the appropriate place in the license text. Make sure to comment out the license text if you are adding it to a code file (e.g., `lab1.s`), otherwise, your code will not compile or run. Failing to comply will render your submission inadmissible for grading.**

[lab1-first.s]: resources/code/lab1-first.s
[lab1-broken.s]: resources/code/lab1-broken.s
