def r_type(opcode, ra, rb):
    opcode_bin = 0b111
    opcode_dict = {
        "and": 0b000,
        "add": 0b001,
        "xor": 0b010,
        "slt": 0b011,
        "sll": 0b100,
        "srl": 0b101, 
        "neq": 0b110
    }
    if opcode not in opcode_dict:
        raise ValueError(f"Invalid opcode: {opcode}")
    if not (0 <= ra <= 3):
        raise ValueError(f"Invalid register ra: {ra}")
    if not (0 <= rb <= 3):
        raise ValueError(f"Invalid register rb: {rb}")

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
    parts = line.split()
    if parts[0] in ["and", "add", "xor", "slt", "sll", "srl", "neq"]:
        opcode = parts[0]
        ra = int(parts[1])
        rb = int(parts[2])
        instruction = r_type(opcode, ra, rb)
    elif parts[0] == "done": 
        imm = 0
        instruction = b_type(imm)
    elif parts[0] == "beq":
        imm = int(parts[1])
        instruction = b_type(imm)
    elif parts[0] == "li":
        imm = int(parts[1])
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
    for line in open(filename):
        line = line.strip()
        if line:
            try:
                instruction = compile_line(line)
                print(instruction)
                with open(output_file, "a") as f:
                    f.write(instruction + "\n")
            except ValueError as e:
                print(f"Error: {e}")
    f.close()

def main():
    import sys
    if len(sys.argv) != 2:
        print("Usage: python compiler.py <filename>")
        return
    filename = sys.argv[1]
    compile_file(filename)

if __name__ == "__main__":
    main()

