## System Date Comparison in x86‑64 Assembly
This project implements a low‑level date comparison utility written entirely in x86‑64 NASM assembly. It retrieves the current system time using a Linux syscall, converts epoch seconds into an approximate year and month, accepts user input, and determines whether the user‑provided date is higher or equal/lower than the current system date.

The program was developed and tested using the SASM assembly environment.

## Technical Skills Demonstrated
x86‑64 assembly programming

Linux syscall interface (time syscall)

64‑bit integer arithmetic and division

Manual ASCII‑to‑integer parsing

Control flow using conditional jumps

Epoch‑time conversion without libraries

Use of NASM with io64.inc macros

## File Structure

main.asm        # Full program source code

## How the Program Works

1. Retrieve Current Time
The program calls Linux syscall 201 to obtain the current epoch timestamp (seconds since Jan 1, 1970).

2. Convert Epoch → Year
Epoch seconds are divided by the average number of seconds in a year:

31,556,952 seconds/year

The result is added to 1970 to compute the current year.

3. Convert Epoch → Month
Remaining seconds are divided by the average seconds per month:

2,629,746 seconds/month

This yields a month value in the range 1–12.

4. Read User Input
A custom READ_INT64 routine reads numeric input one character at a time and constructs a 64‑bit integer.

5. Compare Dates
The program compares:

  User year vs. current year

  If equal, user month vs. current month

It then prints whether the user’s date is higher or equal/lower.

## Running the Program (SASM)
Open SASM

Create a new NASM x86‑64 project

Paste main.asm into the editor

Ensure the environment is set to Linux syscalls

Build & Run

## Example Output
Code
Enter year (YYYY):
2025
Enter month (1-12):
12
The current year and month is 2026 02
 and your date is equal or lower
## Notes
Date conversion uses approximate month/year lengths for simplicity.

The project focuses on low‑level system interaction, arithmetic, and control flow rather than precise calendar computation
