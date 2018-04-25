Syntax description:
The language allows to have integers and strings, they are assigned to variables using an arrow and simply writing the number for integers, 
while using single quotes for strings. Other operations allowed are logical operations and mathematical operations. Parenthesis are also acepted.
Each statement ends when a new line is found, in case of logical operation statement are divided by tabs.


Logical operators:

eq 	//equal operator
lt	//less then operator
gt	//greater then operator

Mathematical operators:

sum	// "+" to do a sum
sub	// "-" to do a subtraction
div 	// "/" to do a division
prod	// "*" to do a multiplication

Other operators:

tellMe()	//prints a string or a variable
concat		//Concatenates two strings

Examples:


ab <- 7				//Assigns 7 to variable ab
cd <- 'Hello world' 		//Assigns string 'Hello World' to variable cd
ef <- 8 sum 9			//Assigns 17 to variable ef
hg <- (9 prod 2) div 3		//Assigns 5 to variable hg
jk <- 'Hello ' concat cd	//Assings 'Hello Hello World' to variable jk
ab lt ef			//Returns 1 (true)
ab gt 20			//Returns 0 (false)
17 eq (8 sum 9)			//Returns 1 (true)

ab gt ef			//This is evaluated
	tellMe(jk)		//since ab is less than ef this is not executed
else				//else
	tellMe(cd)		//This will be executed


Other examples can be find in the input files, type error are managed, for example, in case of operations between integers and strings.
