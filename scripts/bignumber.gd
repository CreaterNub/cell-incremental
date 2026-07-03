class_name BN
extends RefCounted

var mantissa: float = 0.0
var exponent: int = 0


func _init(v: float = 0.0, e: int = 0):
	mantissa = v
	exponent = e
	normalize()



func copy() -> BN:
	return BN.new(mantissa, exponent)


func is_zero() -> bool:
	return mantissa == 0.0


#Normalize
func normalize():
	if mantissa == 0:
		exponent = 0
		return

	while mantissa >= 10.0:
		mantissa /= 10.0
		exponent += 1

	while mantissa > 0.0 and mantissa < 1.0:
		mantissa *= 10.0
		exponent -= 1


# Addition

func add(other: BN):
	if other.is_zero():
		return self

	# Align exponentonents
	var diff = exponent - other.exponent

	if diff >= 15:
		# other is too small to matter
		return self

	if diff <= -15:
		mantissa = other.mantissa
		exponent = other.exponent
		return self

	if diff >= 0:
		mantissa += other.mantissa / pow(10, diff)
	else:
		mantissa = mantissa / pow(10, -diff) + other.mantissa
		exponent = other.exponent

	normalize()
	return self

# Subtraction
func subtract(other: BN):
	if other.is_zero():
		return self

	var diff = exponent - other.exponent

	if diff >= 15:
		# other too small to matter
		return self

	if diff <= -15:
		# other is much larger
		mantissa = 0
		exponent = 0
		return self

	if diff >= 0:
		mantissa -= other.mantissa / pow(10, diff)
	else:
		mantissa = mantissa / pow(10, -diff) - other.mantissa
		exponent = other.exponent

	# clamp negatives to zero
	if mantissa <= 0:
		mantissa = 0
		exponent = 0
		return self

	normalize()
	return self


const abr = [
	"", "K", "M", "B", "T",
	"Qa", "Qn", "Sx", "Sp", "Oc", "No",
	"De", "UDe", "DDe", "TDe", "QtDe", "QnDe",
	"SxDe", "SpDe", "OcDe", "NvDe", "Vt", "UVt",
	"DVt", "TVt", "QtVt", "QnVt", "SxVt", "SpVt",
	"OcVt", "NvVt", "Tg", "UTg", "DTg"
]

func format() -> String:
	var e = exponent
	var v = mantissa

	# normalize into scientific form
	while v >= 10:
		v /= 10
		e += 1

	while v > 0 and v < 1:
		v *= 10
		e -= 1

	# suffix tier
	var tier = floori(e / 3.0)
	var index = tier

	# tiny numbers
	if e < 0:
		return str(snapped(v * pow(10, e), 0.01))

	if index >= abr.size() or e >= 100:

		var exp_tier = int(log(float(e)) / log(1000.0))

		# no abr if below 1e1k
		if e < 1000:
			return str(snapped(v, 0.01)) + "e" + str(e)

		# 1e1k+ = suffix
		var short_exp = e / pow(1000.0, exp_tier)
		var exp_str = str(snapped(short_exp, 0.01))

		if exp_tier >= abr.size():
			return str(snapped(v, 0.01)) + "e" + str(e)

		return str(snapped(v, 0.01)) + "e" + exp_str + abr[exp_tier]

	# normal suffix display
	var display_mantissa = v * pow(10, e % 3)
	return str(snapped(display_mantissa, 0.01)) + abr[index]


#Multiplication
func multiply(other: BN):
	mantissa *= other.mantissa
	exponent += other.exponent
	normalize()
	return self
#scale by float
func mul_float(f: float):
	mantissa *= f
	normalize()
	return self

# Divide
func divide(other: BN):
	if other.is_zero():
		push_error("Division by zero")
		return self

	mantissa /= other.mantissa
	exponent -= other.exponent

	normalize()
	return self
#float version
func div_float(f: float):
	if f == 0.0:
		push_error("Division by zero")
		return self

	mantissa /= f

	normalize()
	return self

# Comparisons (< > = etc)
func compare(other: BN) -> int:
	if exponent > other.exponent:
		return 1
	elif exponent < other.exponent:
		return -1
	else:
		# same exponent, then compare mantissa
		if mantissa > other.mantissa:
			return 1
		elif mantissa < other.mantissa:
			return -1
		else:
			return 0
			
# the things
func gt(other: BN) -> bool:
	return compare(other) == 1
func lt(other: BN) -> bool:
	return compare(other) == -1
func eq(other: BN) -> bool:
	return compare(other) == 0
func gte(other: BN) -> bool:
	return compare(other) >= 0
func lte(other: BN) -> bool:
	return compare(other) <= 0

# powers
func pow(p: float) -> BN:
	if mantissa == 0:
		return BN.new(0, 0)

	# convert BN to real value: m × 10^e
	var log10_value = log(mantissa) / log(10.0) + float(exponent)

	# apply power
	log10_value *= p

	# split back into mantissa + exponent
	var new_exp = floor(log10_value)
	var new_man = pow(10, log10_value - new_exp)

	mantissa = new_man
	exponent = int(new_exp)

	normalize()
	return self


# string delay
func to_text() -> String:
	return str(snapped(mantissa, 0.01)) + "e" + str(exponent)
