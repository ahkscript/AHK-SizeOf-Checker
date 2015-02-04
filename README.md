# AHK-SizeOf-Checker
A library that can check the number of bytes of a windows define.  

Dependencies:  
Visual Studio must be installed.  

##What?
A Utility to check the size, in bytes, of Windows Structures, datatypes etc.

##Why?
Written for use with HotkeyIt's _Struct - to check that structure definitions are correct by cheking the size that _Struct thinks the structure is, compared to what windows thinks it is.

##How?
It creates a C source text file with the needed C code to check the size of the data type.  
It then builds a windows batch file to:  
1) Set up the Visual Studio compiler to work at the command-line.  
2) Run the Visual C compiler to compile the C code  
It then runs the batch file to create an EXE. 
It then runs the compiled EXE and returns the result.  
