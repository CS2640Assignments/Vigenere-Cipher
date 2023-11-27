# Vigenere Cipher in MIPS Assembly

.data
plaintext: .asciiz "tEsT"      # Input plaintext
key: .asciiz "KEY"              # Key for encryption
newLine: .asciiz "\n"

.text

#TODO: add way to check for upper and lowercase keys so either 'key' or 'KEY'

main:
    # Print original plaintext and key
    li $v0, 4                    # System call for print_str
    la $a0, plaintext            # Load plaintext address
    syscall
    
    # Print original plaintext and key
    li $v0, 4                    # System call for print_str
    la $a0, newLine            # Load plaintext address
    syscall

    li $v0, 4                    # System call for print_str
    la $a0, key                  # Load key address
    syscall
    
    # Print original plaintext and key
    li $v0, 4                    # System call for print_str
    la $a0, newLine            # Load plaintext address
    syscall

    la $a0, plaintext            # Load plaintext address
    la $a1, key                  # Load key address
    jal vigenere                 # Call the vigenere function

    # Print encrypted plaintext
    li $v0, 4                    # System call for print_str
    la $a0, plaintext            # Load encrypted plaintext address
    syscall

    # Exit program
    li $v0, 10                   # System call for exit
    syscall

# Vigenere function
vigenere:
    move $t0, $a0                # Copy plaintext address
    move $t1, $a1                # Copy key address
    li $t2, 0                    # Initialize counter for plaintext index
    li $t3, 0                    # Initialize counter for key index

loop:
    lb $t4, ($t0)                # Load a character from plaintext
    bge $t4, 97, lower
    bge $t4, 65, upper
lower:
    beqz $t4, end                # If null terminator, exit loop

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
    beqz $t4, end                # If null terminator, exit loop

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
    la $t1, key                  # Reload key address
    li $t3, 0                    # Reset key index
    j loop                       # Continue encryption

end:
    jr $ra                       # Return from function
