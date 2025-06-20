li 0000001 # Load 1 (immediate) into default destination R1
lw 1 2 # Load data at address 1 into R2 (mem1)
li 0000111 # Load 7 (immediate) into default destination R1
move 1 0 # Load value 7 into R0
srl 2 0 # R1 = R2 >> R0 (shift R2 7 bits right, will be equal to sign bit)
move 1 3 # Move sign bit into R3
li 0001110 # Load 14 into R1
sw 1 3 # Store sign bit into address 14
li 0010000 # Load 16 into R1
sw 1 2 # Store data in R2 (mem1) into address 16
li 0000000 # Load 0 into R1
lw 1 0 # Load data at address 0 into R0 (mem0)
li 0001111 # Load 15 into R1
sw 1 0 # Store data in R0 (mem0) into address 15
move 3 1 # Move the sign bit back to R1
beq 0100011 # 35; (pos); Skip past the negative part if sign bit is 0: Handle negative case on next line
{
    li 0010000 # Load 16 into R1
    lw 1 2 # Load mem1 back into R2
    li 1111111 # Load this into R1
    xor 1 2 # R1 = R1 XOR R2 (1111_1111 ^ mem1)
    move 1 3 # R3 = R1
    li 0010000 # Load 16 in R1
    sw 1 3 # store complemented mem1 into address 16
    li 0001111 # Load 15 into R1
    lw 1 2 # Load mem0 into R2
    li 1111111 # Load mask into R1
    xor 1 2 # R1 = R1 XOR R2 (1111_1111 ^ mem0)
    move 1 3 # R3 = R1
    li 0001111 # Load 15 into R1
    sw 1 3 # store complemented mem0 into address 15
    li 0000001 # Load 1 into R1
    add 1 3 # R1 = R1 + mem0
    move 1 3 # Move R1 into R3
    li 0010001 # Load 17 into R1
    sw 1 3 # Store complemented mem0 + 1 into address 17
    li 0000111 # Load 7 into R1
    move 1 0 # Move 7 into R0
    srl 3 0 # Shift complemented mem0 + 1 right by 7
    move 1 2 # Move sign bit of complemented mem0 + 1 to R2
    li 0001111 # Load 15 into R1
    lw 1 1 # Load complimented mem0 + 1 into R1
    srl 1 0 # Shift ^ right by 7
    neq 1 2 # Check if sign bits are equal; if not should handle (r1 will be 1)
    beq 0000111 # 7; (no overflow); No need to handle overflow 
    {
        li 0010000 # Load 16 into R1
        lw 1 3 # Load complimented mem1 into R3
        li 0000001 # Load 1 into R1
        add 1 3 # R1 = complimented mem1 + 1
        move 1 3 # R3 = R1
        li 0010000 # Load 16 into R1
        sw 1 3 # Store complimented mem1 + 1 into 16; now 16 holds correct mem1 and 17 hold correct mem0
    }
}
li 0000111 # Load 7 into R1; Start Search for first 1 # BRANCH HERE FOR BOTH POS BRANCH AND NO OVERFLOW BRANCH 
move 1 3 # Move 7 into R3 ([i])
li 0010000 # Load 16 into R1 (mem1 address); START of MSW LOOP
lw 1 2 # Load mem1 into R2
li 0000001 # Load 1 into R1
sll 2 1 # Shift mem1 left by 1 bit (remove sign bit)
move 1 2 # Move shifted left mem1 into R2
srl 2 3 # Shift R2 right by i bits
move 1 2 # Move ith bit into R2
li 0000001 # Load 1 into R1
neq 1 2 # R1 != R2 ? R1 = 1 : R1 = 0 (We want this to output 0; means we found the bit)
beq 0111010 # 58; (MSW finds i) Found correct i
neq 1 3 # Check if i == 1; if so, didn't find 1 in MSW, go to LSW loop R1 != R3 ? R1 = 1 : R1 = 0
beq 0000101 # 5; (finish loop 1) Checks if R1 == 0; if it is, didn't find 1 in MSW, go to LSW loop
li 1111111 # Load -1 into R1
add 1 3 # Decrement R3
move 1 3 # Move updated R3 into R3
li 0000000 # Load 0 into R1
beq 1101111 # -17; Branch back to loop start
li 0000111 # Load 7 into R1 # BRANCH HERE FOR GOING TO LSW LOOP
move 1 3 # Move 7 into R3 ([i])
li 0010001 # Load 17 into R1 (mem0 address); # Line for START of LSW LOOP
lw 1 2 # Load mem0 into R2
srl 2 3 # Shift R2 right by i bits
move 1 2 # Move ith bit into R2
li 0000001 # Load 1 into R1
neq 1 2 # R1 != R2 ? R1 = 1 : R1 = 0 (We want this to output 0; means we found the bit)
beq 0010100 # 12; (LSW finds i) Found correct i
move 3 1 # Move i into R1
beq 0000101 # 5; (NO 1s) If i is 0 and still no 1s were found, then the initial value is all 0s. Handle separately
li 1111111 # Load -1 into R1
add 1 3 # Decrement R3
move 1 3 # Move updated R3 into R3
li 0000000 # Load 0 into R1
beq 1110010 # -14; Branch back to loop start
li 0000010 # SPECIAL CASE!!! ALL 0s Load 2 into R1
sw 1 3 # Store all 0s into mem2
li 0000011 # Load 3 into R1
sw 1 3 # Store all 0s into mem3
done # Finished with the program!! (special case)
li 1111000 # BRANCH DEST for LSW LOOP FINDS i; Load -8 into R1
add 1 3 # R1 = R3 - 8 
move 1 2 # Move R3 - 8 to R2
li 0001111 # Load 15 into R1
add 1 2 # R1 = exp
move 1 0 # move exp into R0
li 1111111 # Load all 1s into R1
xor 1 3 # R1 = !R3
move 1 3 # Move !R3 into R3
li 0000001 # Load 1 into R1
add 1 3 # R1 = !R3 + 1
move 1 3 # essentially R3 = -R3
li 0001000 # Load 8 into R1
add 1 3 # R1 = 8 - R3
move 1 3 # Move value into R3
li 0010001 # Load 17 into R1
lw 1 1 # Load mem0 into R1
sll 1 3 # Shift mem0 left by 8 - R3
move 1 3 # Move the output into R3 (7:6 is last two bits of MSW, 5:0 + 00 is LSW)
li 0001110 # Load 14 into R1
lw 1 2 # R2 is now the sign bit
li 0000111 # Load 7 into R1
sll 2 1 # R1 = R2 << 7
move 1 2 # R2 holds the sign bit in the right spot
li 0000010 # Load 2 into R1
sll 0 1 # R1 = R0 << 2 
move 1 0 # R0 holds the exp bits in the right spot
xor 0 2 # R1 = sign bit + exp + 00
move 1 0 # R1 moved into R0
li 0000110 # Load 6 into R1
beq 0010011 # 19; i in MSW branches here, chain to destination
srl 3 1 # Shift R3 to be the 2 bits of MSW
xor 0 1 # R1 = MSW
move 1 0 # R0 = MSW
li 0000011 # Load 3 into R1
sw 1 0 # MSW stored!
li 0000010 # Load 2 into R1
sll 3 1 # R1 = R3 << 2 = LSW
move 1 0 # R0 = LSW
li 0000010 # Load 2 into R1
sw 1 0 # LSW stored!
li 0000000 # NOP
li 0000000 # NOP
li 0000000 # NOP
li 0000000 # NOP
li 0000000 # NOP
li 0000000 # NOP
li 0000000 # NOP
li 0000000 # NOP
done # Done with program
li 1111111 # BRANCH DEST for MSW LOOP FINDS i; Load -1 into R1
add 1 3 # R1 = R3 - 1;
move 1 3 # Move into R3
move 1 2 # Move into R2 as well 
li 0001111 # Load 15 into R1
add 1 3 # R1 = exp
move 1 0 # move exp into R0
li 1111111 # Load all 1s into R1
xor 1 3 # R1 = !R3
move 1 3 # Move !R3 into R3
li 0000001 # Load 1 into R1
add 1 3 # R1 = !R3 + 1
move 1 3 # essentially R3 = -R3
li 0001000 # Load 8 into R1
add 1 3 # R1 = 8 - R3
move 1 3 # Move value into R3
li 0000010 Move 2 into R1
slt 2 1 # Checking if we need to move bits from mem0 into mem1
beq 0111100 # 60; (done handling needing mem0 bits) if not less than, no need to handle silly case 
{
    move 2 1 # Moves position of first 1 bit into R1
    beq 0101000 # 40; (handle the case where bit 0 of mem1 is 1)
    {
        li 0010001 # Load 17 into R1; Get the first bit of mem0 
        lw 1 2 # Load mem0 into R2
        li 0000111 # Load 7 into R1
        srl 2 1 # R1 = mem0 >> 7 (only first bit of mem0 is kept)
        move 1 2 # first bit of mem0 is in R2
        li 0001110 # Load 14 into R1
        lw 1 1 # Get sign bit into R1
        move 1 3 # Move sign bit to R3
        li 0000111 # Load 7 into R1
        sll 3 1 # R1 = R3 << 7
        move 1 3 # Store sign bit (in the right place) into R3
        li 0000010 # Load 2 into R1
        sll 0 1 # Shift exp field 2 left
        xor 1 3 # R1 is sign + exp
        move 1 3 # R3 is sign + exp
        li 0000110 # Load 6 into R1 
        move 1 0 # Move 6 into R0
        li 0010000 # Load 16 into R1
        lw 1 1 # Move mem1 into R1
        sll 1 0 # R1 = R1 << 6
        srl 1 3 # R1 = R1 >> 6 (only last 2 bits are preserved)
        move 1 0 # Move last 2 bits into R0
        li 1111110 # Load mask into R1
        and 0 1 # R1 = R1 && mask (clear last bit)
        xor 1 3 # R1 = sign + exp + 1 bit + 1 bit of garbage
        xor 1 2 # sign + exp + 2 bits of mantissa
        move 1 0 # Move correct mem3 into R0
        li 0000011 # Load 3 into R1
        sw 1 0 # mem3 DONE!
        li 0000001 # Load 1 into R1; Get mem0, shift left by 1, store into mem2
        move 1 0 # Move 1 into R0
        li 0010001 # Load 17 into R1
        lw 1 1 # Load mem0 into r1
        sll 1 0 # R1 = R1 << 1, correct mem2!
        move 1 0 # Move mem2 to R0
        li 0000010 # Load 2 into R1
        sw 1 0 # mem2 DONE!
        li 0000000 # NOP
        li 0000000 # NOP
        li 0000000 # NOP
        li 0000000 # NOP
        li 0000000 # NOP
        li 0000000 # NOP
        li 0000000 # NOP
        li 0000000 # NOP
        done # PROGRAM DONE FOR 1 BIT OF MANTISSA IN MSW
    }
    li 0010001 # Load 17 into R1; BRANCH HERE FOR CASE WHERE NO MANTISSA IN MSW
    lw 1 2 # Load mem0 into R2
    li 0000110 # Load 6 into R1
    srl 2 1 # R1 = mem0 >> 6 (only first 2 bits of mem0 are kept)
    move 1 2 # first 2 bits of mem0 is in R2
    li 0001110 # Load 14 into R1
    lw 1 1 # Get sign bit into R1
    move 1 3 # Move sign bit to R3
    li 0000111 # Load 7 into R1
    sll 3 1 # R1 = R3 << 7
    move 1 3 # Store sign bit (in the right place) into R3
    li 0000010 # Load 2 into R1
    beq 0011000 # 24; (Chain Jump) CHAINED JUMP FOR >= 2 BITS OF MANTISSA IN MSW
    sll 0 1 # Shift exp field 2 left
    xor 1 3 # R1 is sign + exp
    xor 1 2 # R1 is sign + exp + first 2 bits of mem0
    move 1 0 # Move correct mem3 into R0
    li 0000011 # Load 3 into R1
    sw 1 0 # mem3 DONE!
    li 0000010 # Load 1 into R1; Get mem0, shift left by 2, store into mem2
    move 1 0 # Move 2 into R0
    li 0010001 # Load 17 into R1
    lw 1 1 # Load mem0 into r1
    sll 1 0 # R1 = R1 << 2, correct mem2!
    move 1 0 # Move mem2 to R0
    li 0000010 # Load 2 into R1
    sw 1 0 # mem2 DONE!
    li 0000000 # NOP
    li 0000000 # NOP
    li 0000000 # NOP
    li 0000000 # NOP
    li 0000000 # NOP
    li 0000000 # NOP
    li 0000000 # NOP
    li 0000000 # NOP
    done # PROGRAM DONE FOR 0 BITS OF MANTISSA IN MSW
}
li 0010000 # BRANCH DESTINATION FOR >= 2 BITS OF MANTISSA IN MSW; Load 16 into R1
lw 1 1 # Get mem1 into R1
sll 1 3 # Shift mem1 left by 8 - R3
move 1 3 # Move shifted mem1 (mantissa bits) into R3
li 0000110 # Load 6 into R1
srl 3 1 # R1 = R3 >> 6 (Only last two bits remain)
move 1 3 # first 2 mantissa bits moved into R3
li 0000010 # Load 2 into R1
sll 0 1 # R1 = R0 << 2; exp bits in right place
xor 1 3 # R1 = R1 XOR R3; exp bits and first two mantissa bits in right place
move 1 3 # Move exp + first 2 sign bits to R3
li 0001110 # Load 14 into R1
lw 1 0 # Load sign bit into R0
li 0000111 # Load 7 into R1
sll 0 1 # R1 = R0 << 7, sign bit in right place
xor 1 3 # R1 = R1 XOR R3, mem3 all right!
move 1 3 # Move mem3 into R3
li 0000011 # Move 3 into R1
sw 1 3 # mem3 DONE!!
li 1111111 # Load all 1s into R1; Shift MSW left by 8 - R3 - 2, shift LSW right by 8 - R3 - 2, XOR them
xor 1 3 # R1 = !R3
move 1 3 # Move !R3 into R3
li 0000001 # Load 1 into R1
add 1 3 # R1 = !R3 + 1
move 1 3 # essentially R3 = -R3
li 0001000 # Load 8 into R1
add 1 3 # R1 = 8 - R3
move 1 3 # Move value into R3
li 1111110 # Load -2 into R1
add 1 3 # R1 = 8 - R3 - 2
move 1 3 # Move into R3
li 0010000 # Load 16 into R1
lw 1 1 # Load MSW into R1
sll 1 3 # R1 = R1 << 8 - R3 - 2
move 1 0 # Move R1 into R0
li 0010001 # Load 17 into R1
lw 1 1 # Load LSW into R1
srl 1 3 # R1 = R1 << 8 - R3 - 2
xor 0 1 # R1 = R0 XOR R1; this is mem2
move 1 0 # move mem2 to R0
li 0000010 # Load 2 into R1
sw 1 0 # mem2 DONE!!
li 0000000 # NOP
li 0000000 # NOP
li 0000000 # NOP
li 0000000 # NOP
li 0000000 # NOP
li 0000000 # NOP
li 0000000 # NOP
li 0000000 # NOP
done # YIPPEEEEEE