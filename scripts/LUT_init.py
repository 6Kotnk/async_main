ENC = "TWO_PHASE"

THRESHOLD = 3
NUM_INPUTS = 5

# Start from idx 0
DOUBLE_INPUTS = 0

NUM_INPUTS_TOTAL = NUM_INPUTS + DOUBLE_INPUTS

FB_NEEDED = NUM_INPUTS_TOTAL//2 != THRESHOLD

init = 0
init_fb_is_0 = 0
init_fb_is_1 = (2**2**NUM_INPUTS - 1)


for loc in range(2**NUM_INPUTS):
    input_sum = bin(loc).count("1")
    init_fb_is_0 |= (input_sum >= THRESHOLD) << loc

if ENC == "TWO_PHASE":
    for loc in range(2**NUM_INPUTS):
        input_sum = bin(loc).count("1")
        init_fb_is_1 &= (input_sum <= THRESHOLD) << loc

elif ENC == "FOUR_PHASE":
    init_fb_is_1 -= 1
else:
    print("ENCODING NOT VALID")


init = init_fb_is_0 | (init_fb_is_1 << (2**NUM_INPUTS))

format_str = "0x{:0" + str(2**NUM_INPUTS) + "x}"

print("".join(format_str.format(init)))

