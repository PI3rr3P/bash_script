In floatting point arithmetic
=============================

to_strFloat:
------------
	+ (FIXED) to_strFloat 20 1 
		> 0.2.0
		au lieu de 2.0
	+ (FIX) to_strFloat 2 0
		> 0.2.0
		au lieu de 2.0

divide:
-------
	+ (FIXED) div 0.5 0.25
		> 2.380952380952
		au lieu de 2.0
	+ Pas de necessite a decaller le chiffre lorsque division
	
mult:
-----
	+ (FIXED) mult 14.0 3.141592
		> 4398228.8000000
		au lieu de 43.982288000000004

Entire operation
----------------
	+ (//) operator pour division entiere
		> 2.25 // 1.745
			= 1.0
		> 2.25 % 1.745
		 	2.25 - ( 2.25 // 1.745 ) * 1.745 
		 	= 0.5049999999999999

Power
-----
	+ power_int 14 -2
	only implemented for integer exponent
	not handle floatting number -> remove (()) for mult!

Sqrt
----
	+ should works with recurse continuous fraction algorithm
	+ Allow to compute arbitrary power (dichotimie on the exponent !!)

Exp/Ln/Cos/Sin/Tan
------------------
	+ Should use pade apprximant

Overflow/Underflow
------------------
	+ Set protection toward overfloat
	just limiting number of digit in some operation
	+ Setting a NaN algebra

Scientific format
-----------------
	+ Integrate scientific notation

API for all functions
---------------------
	+ function op
		op A + B
		op A - B
		op A * B
		op A / B
		op A // B
		op A % B
		op A ^ B
		op exp A
		op sin A

