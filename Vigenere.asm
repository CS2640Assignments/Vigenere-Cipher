# Vigenere Cipher in MIPS Assembly
# Joshua Estrada and Damian Varela
# https://github.com/CS2640Assignments/Vigenere-Cipher

# Rules
# message can be in any case
# key must be uppercase, if not, convert to uppercase
# ignore spaces and special characters in the message

.include "utils.asm"

.data
welcome: .asciiz "Welcome to Joshua Estrada's and Damian Varela's Vigenere Cipher\n"
filePrompt: .asciiz "Enter the input file name: "
keyPrompt: .asciiz "Enter a key containing only letters (Max 50 chars): "
optionPrompt: .asciiz "Please select if you would like to encrypt or decrypt:\n1) Encryption\n2) Decryption"
option: "Please input 1 or 2: "
newLine: .asciiz "\n"
buffer: .space 51
fin: .space 26
file: .space 501
fileError: .asciiz "Error opening the file. Please check the file name and try again."
plaintextText: .asciiz "The original plaintext is:\n\n"
keyText: .asciiz "The key is: "
ciphertextText: .asciiz "The ciphertext is:\n\n"
divider: .asciiz "----------------------------------------------------------"
encryptFile: .asciiz "encryptOutput.txt"
decryptFile: .asciiz "decryptOutput.txt"

.text
main:
	printStr(welcome)
	getFile
   	getKey
   	la $s0, buffer
   	processKey($s0)
   	printStr(newLine)
   	printStr(optionPrompt)
   	printStr(newLine)
   	printStr(option)
   	
   	li $v0, 5
   	syscall
   	move $s1, $v0
   	
   	tlti $s1, 0
   	tgei $s1, 3
   	beq $s1, 1, select_encryption
   	beq $s1, 2, select_decryption
   	
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

select_encryption:
    	la $a0, file          # Load plaintext address
    	move $a1, $s0                  # Load key address
    	jal encryption                # Call the vigenere function

    # Print encrypted plaintext
    	li $v0, 4                    # System call for print_str
    	la $a0, file            # Load encrypted plaintext address
    	syscall
    	
    	printStr(newLine)
    	encryptOutput
    	j exit
    	
select_decryption:
    	la $a0, file          # Load plaintext address
    	move $a1, $s0                  # Load key address
    	jal decryption                # Call the vigenere function

    # Print encrypted plaintext
    	li $v0, 4                    # System call for print_str
    	la $a0, file            # Load encrypted plaintext address
    	syscall
    	
    	decryptOutput
    	

exit:
    # Exit program
    	li $v0, 10                   # System call for exit
    	syscall

