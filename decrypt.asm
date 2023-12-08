.globl decryption

.data

.text
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
