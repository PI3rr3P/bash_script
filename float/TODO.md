In floatting point arithmetic
=============================

to_strFloat:
------------
	+ (FIX) to_strFloat 20 1 
		> 0.2.0
		au lieu de 2.0
	+ (FIX) to_strFloat 2 0
		> 0.2.0
		au lieu de 2.0

divide:
-------
	+ (FIX) div 0.5 0.25
		> 2.380952380952
		au lieu de 2.0
	+ Pas de necessite a decaller le chiffre lorsque division
	
mult:
-----
	+ (FIX) mult 14.0 3.141592
		> 4398228.8000000
		au lieu de 43.982288000000004

+ Set protection toward overfloat
	just limiting number of digit in some operation

+ Integrate scientific notation

+ Implementing operator function (API)