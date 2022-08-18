.data
	a: .float 2.0
	b: .float 3.0

.text

# Magnitude of vector2: ||v||
.macro len2 (%to, %p0, %p1)
	mul.s, $f16, %p0, %p0 # p0^2
	mul.s $f18, %p1, %p1 # p1^2
	add.s $f18, $f16, $f18 # p0^2 + p1^2
	sqrt.s %to, $f18
.end_macro

# Magnitude of vector2: ||v||
.macro lensquared2 (%to, %p0, %p1)
	mul.s, $f16, %p0, %p0 # p0^2
	mul.s $f18, %p1, %p1 # p1^2
	add.s %to, $f16, $f18 # p0^2 + p1^2
.end_macro

# Magnitude of vector3: ||v||
.macro len3 (%to, %p0, %p1, %p2)
	mul.s, $f16, %p0, %p0 # p0^2
	mul.s $f18, %p1, %p1 # p1^2
	mul.s $f20, %p2, %p2 # p2^2
	add.s $f18, $f16, $f18 # p0^2 + p1^2
	add.s $f18, $f18, $f20 # p0^2 + p1^2 + p2^2
	sqrt.s %to, $f18
.end_macro

# Distance of vector2s ||v - u||
.macro dist2 (%to, %a0, %a1, %b0, %b1)
	sub.s $f20, %a0, %b0
	sub.s $f22, %a1, %b1
	len2 (%to, $f20, $f22)
.end_macro	

# Distance of vector2s ||v - u||
.macro distsquared2 (%to, %a0, %a1, %b0, %b1)
	sub.s $f20, %a0, %b0
	sub.s $f22, %a1, %b1
	lensquared2 (%to, $f20, $f22)
.end_macro	

# Distance of vector3s ||v - u||
.macro dist3 (%to, %a0, %a1, %a2, %b0, %b1, %b2)
	sub.s $f22, %a0, %b0
	sub.s $f24, %a1, %b1
	sub.s $f26, %a2, %b2
	len3 (%to, $f22, $f24, $26)
.end_macro	

# Make vector2 a unit vector, v/||v||
.macro unit2 (%a0, %a1)
	len2 ($16, %a0, %a1)
	div.s %a0, $16
	div.s %a1, $16
.end_macro

# Make vector3 a unit vector, v/||v||
.macro unit3 (%a0, %a1, %a2)
	len3 ($16, %a0, %a1, %a2)
	div.s %a0, $16
	div.s %a1, $16
	div.s %a2, $16
.end_macro

# Scale vector r * v
.macro scale2 (%a0, %a1, %sf)
	mul.s %a0, %a0, %sf
	mul.s %a1, %a1, %sf
.end_macro

# Scale vector r * v
.macro scale3 (%a0, %a1, %a2, %sf)
	mul.s %a0, %a0, %sf
	mul.s %a1, %a1, %sf
	mul.s %a2, %a2, %sf
.end_macro

# Translate vector2 v + t
.macro tl2 (%a0, %a1, %t0, %t1)
	add.s %a0, %a0. %t0
	add.s %a1, %a1, %t1
.end_macro

# Translate vector3 v + t
.macro tl3 (%a0, %a1, %a2, %t0, %t1, %t2)
	add.s %a0, %a0. %t0
	add.s %a1, %a1, %t1
	add.s %a2, %a2, %t2
.end_macro

# Translate vector2 v + t * s
.macro tl2 (%a0, %a1, %t0, %t1, %sf)
	mul.s $f16, %t0, %sf
	mul.s $f18, %t1, %sf 
	add.s %a0, %a0. $16
	add.s %a1, %a1, $18
.end_macro

# Translate vector3 v + t * s
.macro tl3 (%a0, %a1, %a2, %t0, %t1, %t2, %sf)
	mul.s $f16, %t0, %sf
	mul.s $f18, %t1, %sf 
	mul.s $f20, %t2, %sf 
	add.s %a0, %a0. $16
	add.s %a1, %a1, $18
	add.s %a2, %a2, $20
.end_macro

.macro diff2 (%to0, %to1, %a0, %a1, %b0, %b1)

.end_macro