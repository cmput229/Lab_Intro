#------------------------------
# Introductory Lab - Buggy Program
# Author: Taylor Lloyd
# Date: June 19, 2012
#
# Something doesn't work. This code should replace
# all [Old] chars in a string with [New].
# The string is in $a0
# Old is in $a1
# New is in $a2
#
#------------------------------
.data
.align 2
.space 3
New:
	.byte '-'
Old:
	.byte ' '
Str:
	.asciiz "Cmput 229 is the absolute bomb.\n"

.text
main:
	la	$a0 Str	
	lw	$a1 Old
	lb	$a2 New

	loop:
		lb	$t0 0($a0)
		beqz	$t0 done		
		bne	$t0 $a1 continue
		
		sb	$a2 0($a0)

		continue:
		addi	$a0 $a0 4
		j	loop

	done:

	li	$v0 4
	la	$a0 Str
	syscall

	jr	$ra
