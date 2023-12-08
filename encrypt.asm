.globl encryption

.data

.text
encryption:
    	move $t0, $a0                # Copy plaintext address
    	move $t1, $a1                # Copy key address
    	li $t2, 0                    # Initialize counter for plaintext index
    	li $t3, 0                    # Initialize counter for key index

loop:
    	lb $t4, ($t0)                # Load a character from plaintext
    	beqz $t4, end1		# checks if 
    	blt $t4, 65, skip             # If ASCII value is less than 'A', skip, not a character
    	bgt $t4, 122, skip            # If ASCII value is greater than 'z', skip, not a character
    	blt $t4, 97, upper            # If ASCII value is less than 'a', it's in the upper case range
    	bgt $t4, 90, lower            # If ASCII value is greater than ''Z' its in the lower case range

skip:	
	addi $t0, $t0, 1
	j loop                
lower:
	blt $t4, 97, skip	     # skip characters in the middle (non-letters)
    	lb $t5, ($t1)                # Load a character from key
    	beqz $t5, reset_key          # If null terminator, reset key index

    	sub $t4, $t4, 97             # Convert plaintext character to 0-25 range
    	sub $t5, $t5, 65             # Convert key character to 0-25 range

    	add $t4, $t4, $t5            # Add plaintext and key characters
    	li $t6, 26                   # Constant for modulo operation
    	rem $t4, $t4, $t6            # Modulo 26 to keep within the alphabet range

    	add $t4, $t4, 97             # Convert back to ASCII range

    	sb $t4, ($t0)                # Store encrypted character back to plaintext
    	addi $t0, $t0, 1             # Move to the next character in plaintext
    	addi $t1, $t1, 1             # Move to the next character in key
    	j loop                       # Repeat for the next character
upper:
	bgt $t4, 90, skip	     # skip characters in the middle (non-letters)
    	lb $t5, ($t1)                # Load a character from key
    	beqz $t5, reset_key          # If null terminator, reset key index

    	sub $t4, $t4, 65             # Convert plaintext character to 0-25 range
    	sub $t5, $t5, 65             # Convert key character to 0-25 range

    	add $t4, $t4, $t5            # Add plaintext and key characters
    	li $t6, 26                   # Constant for modulo operation
    	rem $t4, $t4, $t6            # Modulo 26 to keep within the alphabet range

    	add $t4, $t4, 65             # Convert back to ASCII range

    	sb $t4, ($t0)                # Store encrypted character back to plaintext
    	addi $t0, $t0, 1             # Move to the next character in plaintext
    	addi $t1, $t1, 1             # Move to the next character in key
    	j loop                       # Repeat for the next character

reset_key:
    	# Reset key index if end of key is reached
    	move $t1, $s0                  # Reload key address
    	li $t3, 0                    # Reset key index
    	j loop                       # Continue encryption

end1:
	jr $ra