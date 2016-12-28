
# The following format is required for all submissions in CMPUT 229
	
#---------------------------------------------------------------
# Assignment:           1
# Due Date:             January 15, 2000
# Name:                 John Doe
# Unix ID:              johnd
# Lecture Section:      B1
# Instructor:           John Smith
# Lab Section:          L3 (Tuesday 0000 - 0300)
# Teaching Assistant:   Joe Johnson
#---------------------------------------------------------------

#---------------------------------------------------------------
# The main program loads a0 and a1 with the input parameters for
# hex2dec, calls the subroutine hex2dec to perform hexadecimal to
# ASCII-coded decimal conversion, and prints the result using the
# print_string system call.
#
# Register Usage:
#
#       a0: contains the number to be converted
#       a1: contains the address of the output buffer
#
#---------------------------------------------------------------

        .text

main:
        li      $a0, -0x1234    # load the number to be converted into $a0
        la      $a1, buffer     # load the address of buffer for
                                #   ASCII decimal into $a1
        jal     hex2dec         # call the subroutine

# print out the result of the conversion using
# the system call print_int

        move    $a0, $v0        # initialize a0 to buffer
        li      $v0, 4          # tell syscall to do the print_string function
        syscall                 # make the call

# print a newline character
        la      $a0, str_newline# load a0 with the address of the char
        li      $v0, 4          # invoke system call no. 4
        syscall                 # make the actual call

# Return to OS

        li      $v0, 10         # return to the OS by call sys call no. 10
        syscall                 # make the actual call


#----------------------------------------------------------------------
# Subroutine hex2dec takes as input a 32-bit number and converts it
# to ASCII decimal. 
#
# Inputs:
#          a0    number to be converted
#          a1    address of result buffer
#          ra    return address
#                 
# Register Usage
#
#       t0: 1 if a0 was negative, otherwise 0
#       t1: holds the number 10 for dividing by 10
#       t2: buffer pointer (starts at end of buffer and moves backwards)
#       t3: remainder of division, converted to ascii decimal
#
#----------------------------------------------------------------------
hex2dec:
        slt     $t0, $a0, $zero  # determine the sign, setting $t0
                                 #   to 1 if $a0 is negative
        beqz    $t0, next        # skip the next instruction if >= 0
        neg     $a0, $a0         # negate the sign if negative

next:
	li      $t1, 10         # for dividing by 10
        la      $t2, 11($a1)    # set $t2 to end of buffer
while_loop:
        beqz    $a0, done_while

        div     $a0, $t1        # divide $a0 by 10
        mflo    $a0             # put quotient back into $a0
	mfhi    $t3             # put remainder ( < 10 ) into $t3
        add     $t3, $t3, 0x30  # convert to ascii decimal
        subu    $t2, $t2, 1     # decrement buffer pointer
        sb      $t3, ($t2)      # store it in the next available location

        b       while_loop      # continue loop
done_while:

# add the sign to the buffer if negative
        beqz    $t0, quit       # branch to quit if $t0 = 0
        li      $t0, '-'        # reusing $t0 to hold '-'
        subu    $t2, $t2, 1     # decrement buffer pointer
        sb      $t0, ($t2)      # add '-' to the front of string
quit:
        move    $v0, $t2        # set $v0 to last used buffer address
        jr      $ra             # return to calling program



        .data
# This is the buffer where the number will be stored.
buffer:
        .word   0, 0, 0         # 12 bytes of zeroes

str_newline:
        .asciiz "\n"            # null-terminated ascii string for (CR+LF)
