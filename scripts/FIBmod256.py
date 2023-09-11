import csv

def fibmod256(x):
  if x == 0:
    return 0
  if x == 1:
    return 1
  return (fibmod256(x-1) + fibmod256(x-2)) % 256

def fibmod256gen():
    a, b = 0, 1
    while True:
        yield a
        a, b = b, (a + b) % 256

gen = fibmod256gen()

print(list(gen))

with open(r'C:\Users\galn\Desktop\MAG\async_main\scripts\nums.csv', mode='r') as file:
    reader = csv.DictReader(file)
    gen.__next__()
    for row in reader:
      cirval = int(row["Value"])
      algval = gen.__next__()
      if cirval != algval:
         print("PIZDAKI")
      print(algval)

