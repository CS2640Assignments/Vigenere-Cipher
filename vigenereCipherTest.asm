# Vigenere Cipher in MIPS Assembly
# The Gamblers - Joshua Estrada & Damian Varela

# Rules
# message can be in any case
# key must be uppercase, if not, convert to uppercase
# ignore spaces and special characters in the message

.include "utils.asm"

.data
filePrompt: .asciiz "Enter the input file name: "
keyPrompt: .asciiz "Enter a key containing only letters (Max 50 chars): "
newLine: .asciiz "\n"
buffer: .space 51
fin: .space 26
file: .space 501
fileError: .asciiz "Error opening the file. Please check the file name and try again."
plaintextText: .asciiz "The original plaintext is:\n\n"
keyText: .asciiz "The key is: "
ciphertextText: .asciiz "The ciphertext is:\n\n "
divider: .asciiz "----------------------------------------------------------"

.text
main:
	getFile
   	getKey
   	la $s0, buffer
   	processKey($s0)
   	printStr(newLine)

	printStr(plaintextText)

	# Print file contents
    	li $v0, 4		
    	la $a0, file            
    	syscall

 	printStr(newLine)
 	printStr(divider)
 	printStr(newLine)
	printStr(keyText)

	# print key
    	li $v0, 4                    # System call for print_str
    	move $a0, $s0                  # Load key address
    	syscall
    
    # Print original plaintext and key
	printStr(newLine)
	printStr(divider)
	printStr(newLine)
	printStr(ciphertextText)

    	la $a0, file          # Load plaintext address
    	move $a1, $s0                  # Load key address
    	jal encryption                # Call the vigenere function

    # Print encrypted plaintext
    	li $v0, 4                    # System call for print_str
    	la $a0, file            # Load encrypted plaintext address
    	syscall

    # Exit program
    	li $v0, 10                   # System call for exit
    	syscall

# Vigenere function
encryption:
    	move $t0, $a0                # Copy plaintext address
    	move $t1, $a1                # Copy key address
    	li $t2, 0                    # Initialize counter for plaintext index
    	li $t3, 0                    # Initialize counter for key index

loop:
    	lb $t4, ($t0)                # Load a character from plaintext
    	beqz $t4, end		# checks if 
    	blt $t4, 65, skip             # If ASCII value is less than 'A', skip
    	bgt $t4, 122, skip            # If ASCII value is greater than 'z', skip
    	blt $t4, 97, upper            # If ASCII value is less than 'a', it's upper case
    	bgt $t4, 90, lower

skip:	
	addi $t0, $t0, 1
	j loop                
lower:
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

end:
	jr $ra                       # Return from function
