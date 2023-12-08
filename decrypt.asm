# Vigenere Cipher in MIPS Assembly
# The Gamblers - Joshua Estrada & Damian Varela

# Rules
# message can be in any case
# key must be uppercase, if not, convert to uppercase
# ignore spaces and special characters in the message

.include "utils.asm"
.globl decryption

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
ciphertextText: .asciiz "The ciphertext is:\n\n"
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
    	jal decryption                # Call the vigenere function

    # Print encrypted plaintext
    	li $v0, 4                    # System call for print_str
    	la $a0, file            # Load encrypted plaintext address
    	syscall

    # Exit program
    	li $v0, 10                   # System call for exit
    	syscall

decryption:
    move $t0, $a0                # Copy ciphertext address
    move $t1, $a1                # Copy key address

loop:
    lb $t4, ($t0)                # Load a character from ciphertext
    beqz $t4, end                # If null terminator, end decryption
    blt $t4, 65, skip            # If ASCII value is less than 'A', skip
    bgt $t4, 122, skip           # If ASCII value is greater than 'z', skip
    blt $t4, 97, upper           # If ASCII value is less than 'a', it's in the upper case range
    bgt $t4, 90, lower           # If ASCII value is greater than 'Z', it's in the lower case range

skip:
    addi $t0, $t0, 1
    j loop

lower:
    blt $t4, 97, skip            # Skip non-letter characters
    lb $t5, ($t1)                # Load a character from key
    beqz $t5, reset_key          # If null terminator, reset key index
    sub $t4, $t4, 97             # Convert ciphertext character to 0-25 range
    sub $t5, $t5, 65             # Convert key character to 0-25 range
    slt $t6, $t4, $t5            # Check if key index is greater than ciphertext index
    beqz $t6, no_add1             # If not, skip the addition
    addi $t4, $t4, 26            # Add 26 to ciphertext index
no_add1:
    sub $t4, $t4, $t5            # Subtract key index from ciphertext index
    rem $t4, $t4, 26             # Take the remainder after dividing by 26
    add $t4, $t4, 97             # Convert back to ASCII range
    sb $t4, ($t0)                # Store decrypted character back to ciphertext
    addi $t0, $t0, 1             # Move to the next character in ciphertext
    addi $t1, $t1, 1             # Move to the next character in key
    j loop                       # Repeat for the next character

upper:
    bgt $t4, 90, skip            # Skip non-letter characters
    lb $t5, ($t1)                # Load a character from key
    beqz $t5, reset_key          # If null terminator, reset key index
    sub $t4, $t4, 65             # Convert ciphertext character to 0-25 range
    sub $t5, $t5, 65             # Convert key character to 0-25 range
    slt $t6, $t4, $t5            # Check if key index is greater than ciphertext index
    beqz $t6, no_add2             # If not, skip the addition
    addi $t4, $t4, 26            # Add 26 to ciphertext index
no_add2:
    sub $t4, $t4, $t5            # Subtract key index from ciphertext index
    rem $t4, $t4, 26             # Take the remainder after dividing by 26
    add $t4, $t4, 65             # Convert back to ASCII range
    sb $t4, ($t0)                # Store decrypted character back to ciphertext
    addi $t0, $t0, 1             # Move to the next character in ciphertext
    addi $t1, $t1, 1             # Move to the next character in key
    j loop                       # Repeat for the next character

reset_key:
    move $t1, $a1                # Reload key address
    j loop                       # Continue decryption

end:
    jr $ra  
