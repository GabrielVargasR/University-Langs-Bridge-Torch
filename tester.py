a = 1
b = 2
c = 5
d = 10
e = 15
j = 20


def test(input):
	lines = input.split(' ;')
	lines.pop(len(lines)-1)
	arr = []
	times = []
	for line in lines:
		temp = line.replace('X = ','')
		arr.append(eval(temp))
		times.append(time(eval(temp)))
	print(times)

def time(arr):
	time = 0
	for move in arr:
		l = []
		for p in move:
			l.append(p)
		time += max(l)
	return time


print("Ingrese valores a analizar: ")
values = []
while True:
    value = input()
    if value:
        values.append(value)
    else:
        break
valueStr = '\n'.join(values)

test(valueStr)