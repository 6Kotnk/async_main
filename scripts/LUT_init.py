def input_sum(x):
    return bin(x).count("1") + bin(x)[:DOUBLE_INPUTS].count("1")


ENC = "FOUR_PHASE"

NUM_INPUTS = 4
# Start from idx 0
DOUBLE_INPUTS = 2
THRESHOLD = 3


NUM_INPUTS_TOTAL = NUM_INPUTS + DOUBLE_INPUTS

FB_NEEDED = (NUM_INPUTS_TOTAL + 1) != THRESHOLD * 2

if not FB_NEEDED:
    if ENC == "TWO_PHASE":
        init = 0
        for loc in range(2**NUM_INPUTS):
            init |= (input_sum(loc) >= THRESHOLD) << loc

        format_str = str((2**NUM_INPUTS)) + "'h{:0" + str((2**NUM_INPUTS) // 4) + "x}"
        print("".join(format_str.format(init)))
        print(NUM_INPUTS)
        quit()

        

init = 0
init_fb_is_0 = 0
init_fb_is_1 = (2**2**NUM_INPUTS - 1)


for loc in range(2**NUM_INPUTS):
    init_fb_is_0 |= (input_sum(loc) >= THRESHOLD) << loc

if ENC == "TWO_PHASE":
    init_fb_is_1 = 0
    for loc in range(2**NUM_INPUTS):
        init_fb_is_1 |= (input_sum(loc) >= (NUM_INPUTS_TOTAL + 1 - THRESHOLD)) << loc

elif ENC == "FOUR_PHASE":
    init_fb_is_1 -= 1
else:
    print("ENCODING NOT VALID")
    quit()

init = init_fb_is_0 | (init_fb_is_1 << (2**NUM_INPUTS))
# div by 4 -> 4 bits per hex, mul by 4 -> 2**2 (feedback and reset)
format_str = str(2**NUM_INPUTS * 4) + "'h{:0" + str(2**NUM_INPUTS) + "x}"

print("".join(format_str.format(init)))
print(NUM_INPUTS + 2)

