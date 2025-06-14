def twos_complement_to_decimal(binary_string):
    if binary_string[0] == '0':
        return int(binary_string, 2)  # Positive number
    else:
        inverted_string = ''.join('1' if bit == '0' else '0' for bit in binary_string)
        decimal_value = int(inverted_string, 2) + 1
        return -decimal_value

def r_type(opcode, ra, rb, move=False):
    opcode_bin = 0b111
    opcode_dict = {
        "and": 0b000,
        "add": 0b001,
        "xor": 0b010,
        "slt": 0b011,
        "sll": 0b100,
        "srl": 0b101, 
        "neq": 0b110, 
        "over": 0b111
    }
    if opcode not in opcode_dict:
        raise ValueError(f"Invalid opcode: {opcode}")
    if not (0 <= ra <= 3):
        raise ValueError(f"Invalid register ra: {ra}")
    if not (0 <= rb <= 3):
        raise ValueError(f"Invalid register rb: {rb}")
    if not move and (opcode == "and" or opcode == "add" or opcode == "xor"):
        if ra > rb:
            raise ValueError(f"Must follow canonical ordering for {opcode} instruction: {ra}, {rb}")

    type_bin = 0b00 << 7         # bits 8–7
    opcode_bin = opcode_dict[opcode] << 4  # bits 6–4
    ra_bin = ra << 2             # bits 3–2
    rb_bin = rb                  # bits 1–0

    instruction = type_bin | opcode_bin | ra_bin | rb_bin
    return f"{instruction:09b}"

def b_type(imm):
    type_bin = 0b01 << 7         # bits 8–7
    if not (-64 <= imm <= 63):
        raise ValueError(f"Invalid immediate value: {imm}")
    imm_bin = imm & 0b1111111     # bits 6–0
    instruction = type_bin | imm_bin
    return f"{instruction:09b}"

def i_type(imm):
    type_bin = 0b10 << 7         # bits 8–7
    if not (-64 <= imm <= 63):
        raise ValueError(f"Invalid immediate value: {imm}")
    imm_bin = imm & 0b1111111     # bits 6–0
    instruction = type_bin | imm_bin
    return f"{instruction:09b}"

def m_type(l_s, ra, rb):
    type_bin = 0b11 << 7         # bits 8–7
    l_s_dict = {
        "lw": 0b0,
        "sw": 0b1
    }
    if l_s not in l_s_dict:
        raise ValueError(f"Invalid l_s: {l_s}")
    if not (0 <= ra <= 3):
        raise ValueError(f"Invalid register ra: {ra}")
    if not (0 <= rb <= 3):
        raise ValueError(f"Invalid register rb: {rb}")
    l_s_bin = l_s_dict[l_s] << 6
    filler = 0b00 << 4         # bits 5-4
    ra_bin = ra << 2             # bits 3–2
    rb_bin = rb             # bits 1–0
    instruction = type_bin | l_s_bin | filler | ra_bin | rb_bin
    return f"{instruction:09b}"

def compile_line(line):
    """
    This function takes a line of assembly-like code and compiles it into a binary instruction.
    """
    line = line.strip()
    if not line or line.startswith("#") or line.startswith("{") or line.startswith("}"):
        return ""  # Skip empty lines and comments and branch encapsulation
    parts = line.split()
    if parts[0] == "move":
        # Handle special move instructions
        move_dict = {
            ("0", "1"): ("and", 1, 0),
            ("0", "2"): ("and", 2, 0),
            ("0", "3"): ("and", 3, 0),
            ("1", "0"): ("and", 2, 1),
            ("1", "2"): ("and", 3, 1),
            ("1", "3"): ("and", 3, 2),
            ("2", "0"): ("add", 1, 0),
            ("2", "1"): ("add", 2, 0),
            ("2", "3"): ("add", 3, 0),
            ("3", "0"): ("add", 2, 1),
            ("3", "1"): ("add", 3, 1),
            ("3", "2"): ("add", 3, 2)
        }
        key = (parts[1], parts[2])
        if key in move_dict:
            opcode, ra, rb = move_dict[key]
            instruction = r_type(opcode, ra, rb, move=True)
        else:
            raise ValueError(f"Invalid move instruction: {line}")
        
    elif parts[0] in ["and", "add", "xor", "slt", "sll", "srl", "neq", 'over']:
        opcode = parts[0]
        ra = int(parts[1])
        rb = int(parts[2])
        instruction = r_type(opcode, ra, rb)
    elif parts[0] == "done": 
        imm = 0
        instruction = b_type(imm)
    elif parts[0] == "beq":
        # Sign extend the immediate value
        try:
            temp = int(parts[1])
        except ValueError:
            raise ValueError(f"Immediate value for beq must be an integer: {parts[1]}")
        sign_extended = parts[1][0] + parts[1]
        imm = twos_complement_to_decimal(sign_extended)
        instruction = b_type(imm)
    elif parts[0] == "li":
        sign_extended = parts[1][0] + parts[1]
        imm = twos_complement_to_decimal(sign_extended)
        instruction = i_type(imm)
    elif parts[0] in ["lw", "sw"]:
        l_s = parts[0]
        ra = int(parts[1])
        rb = int(parts[2])
        instruction = m_type(l_s, ra, rb)
    else:
        raise ValueError(f"Invalid instruction: {parts[0]}")
    return instruction

def compile_file(filename):
    output_file = filename.split(".")[0] + "_machinecode"
    line_num = 0

    with open(output_file, "w") as f:
        for line in open(filename):
            line = line.strip()
            try:
                instruction = compile_line(line)
                # print(instruction)
                f.write(instruction + "\n")
            except ValueError as e:
                print(f"Error: {e} on line {line_num}: {line}")
            line_num += 1

def main():
    import sys
    if len(sys.argv) != 2:
        print("Usage: python compiler.py <filename>")
        return
    filename = sys.argv[1]
    compile_file(filename)

if __name__ == "__main__":
    main()

# SPECIAL INSTRUCTIONS
# done: 0b010000000
# move r0 r1: AND R1 R0 00_000_01_00
# move r0 r2: AND R2 R0 00_000_10_00
# move r0 r3: AND R3 R0 00_000_11_00
# move r1 r0: AND R2 R1 00_000_10_01
# move r1 r2: AND R3 R1 00_000_11_01
# move r1 r3: AND R3 R2 00_000_11_10
# move r2 r0: ADD R1 R0 00_001_01_00
# move r2 r1: ADD R2 R0 00_001_10_00
# move r2 r3: ADD R3 R0 00_001_11_00
# move r3 r0: ADD R2 R1 00_001_10_01
# move r3 r1: ADD R3 R1 00_001_11_01
# move r3 r2: ADD R3 R2 00_001_11_10