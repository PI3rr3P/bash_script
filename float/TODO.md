In floatting point arithmetic
=============================

to_strFloat:
------------
	+ to_strFloat 20 1 
		> 0.2.0
		au lieu de 2.0
	+ to_strFloat 2 0
		> 0.2.0
		au lieu de 2.0

divide:
-------
	+ div 0.5 0.25
		> 2.380952380952
		au lieu de 2.0
	
mult:
-----
	+ mult 14.0 3.141592
		> 4398228.8000000
		au lieu de 43.982288000000004
