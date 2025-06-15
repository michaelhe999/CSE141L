# Convert 16-bit two's complement into 16-bit IEEE format
# given short, turn into float

# 1 bit for sign, 5 for exponent, 10 for mantissa (after decimal)

# Load values
LOAD R2, M[0]       # R2 = X[15:8]
LOAD R3, M[1]       # R3 = X[7:0]

# Check MSB for sign bit
LI R0, 10000000     # load mask
XOR R0, R2          # R1 = sign bit
LI R0, 00000111     # R0 = 7
SRL R1, R0          # right shift R1 by 7 
LI R0,  01000000    # R0 = 32
SW R0, R1           # store sign bit (R1) in M[32]
BEQ NEGATIVE        # if R1 == 1, branch negative

# if negative, XOR both sides with values, add 1, then check for overflow
NEGATIVE:
    LOAD R2, M[0]   # get clean copy of X[15:8]
    LI R0, 00000001 # R0 = 1
    SLL R2, R0      # R1 = left shift R2 by 1
    MOV R1, R2      # R2 = R1
    SRL R2, R0      # R1 = right shift R2 by 1 
    MOV R1, R2      # R2 = R1 
    LI R0, 11111111 # R0 = mask
    XOR R0, R2      # R1 = R0 XOR R2
    MOV R1, R2      # R2 = R1 

    # check if r2 is all 0's, stores 1 into r0 
    LI R0, 00000001
    XOR R0, R2      # R1 = 1 if R2 == 00000000
    BEQ CASE1