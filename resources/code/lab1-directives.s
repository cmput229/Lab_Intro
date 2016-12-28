# Make sure you clear memory before loading this file

.data
	.word 21, 88, -5, -10
	.byte 10, 'c'
	.align 2
	.space 9
	.asciiz "ABCD"
	.ascii "EF"

.text

main:
        jr      $ra
