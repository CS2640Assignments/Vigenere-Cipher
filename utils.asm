.macro getKey
	printStr(keyPrompt)
	li $v0, 8
	la $a0, buffer
	la $a1, 50
	syscall
.end_macro

.macro getFile
prompt:
    	# Prompt for file name
    	printStr(filePrompt)

    	# Read file name from user
    	li $v0, 8
    	la $a0, fin
    	li $a1, 25
    	syscall
	la $t0, fin
	process($t0)
open_file:
    	# Open the file for reading
    	li $v0, 13
    	la $a0, fin
    	li $a1, 0
    	li $a2, 0
    	syscall
    	move $s1, $v0  # Save the file descriptor

    	# Check if file opened successfully
   	 bltz $s1, file_open_failed

    	# Read from the file
    	li $v0, 14
    	move $a0, $s1
    	la $a1, file
    	li $a2, 500  # Adjust buffer length
    	syscall

    	# Close the file
    	li $v0, 16
    	move $a0, $s1
    	syscall
    	j done

file_open_failed:
	printStr(fileError)
	printStr(newLine)
    	j prompt

done:
.end_macro



.macro processKey(%key)
    	process(%key)
    	move $a0, %key

convert_loop:
    	# Load a character from the string
    	lb $t1, 0($a0)

    	# Check if the character is null (end of string)
    	beqz $t1, convert_exit

    	# Check if the character is a lowercase letter
    	blt $t1, 'a', not_lowercase
    	bgt $t1, 'z', not_lowercase

    	# Convert lowercase to uppercase (ASCII difference is 32)
    	subi $t1, $t1, 32
    	sb $t1, 0($a0)

not_lowercase:
    # Move to the next character
    	addi $a0, $a0, 1
    	j convert_loop

convert_exit:
    	# End of string, return
.end_macro

.macro printStr(%str)
	li $v0, 4
	la $a0, %str
	syscall
.end_macro

.macro process(%key)
    	move $t0, %key
loop:
        lb $t1, ($t0)  # Load a character from the buffer
        beqz $t1, done_processing  # Exit loop if null terminator
        beq $t1, 10, replace_newline  # Check for newline (ASCII 10)
        beq $t1, 13, replace_newline  # Check for carriage return (ASCII 13)
	j continue_loop
replace_newline:
	sb $zero, ($t0)  # Replace newline with null terminator
continue_loop:
        addi $t0, $t0, 1  # Move to the next character
        j loop

done_processing:
.end_macro