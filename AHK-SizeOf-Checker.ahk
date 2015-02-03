/*
sizeof() Checker class

ToDo:
* Cater for non-x86.
  Check SizeOf(int) in C before other checks to detect if Visual Studio x86?
  Check A_PtrSize to see if AHK x86 / x64 ?

Instantiation:
If your Visual C Executable (cl.exe) is not in C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\bin\, pass path to where it actually lives.

Usage:
Call Check(<thing>, <include>)
eg to check the sizeof(RAWINPUTDEVICE) from Windows.h, pass:
Check ("RAWINPUTDEVICE", "Windows.h")
*/

; Returns size
Class SizeofChecker {
	BatCreated := 0
	__New(VS_Path := "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\bin\"){
		this.VS_Path := VS_Path
		if (!this.BatCreated){
			this.CreateBat()
		}
	}
	
	CreateBat(){
		FileDelete, compile.bat
		;code := "@echo off`ncall """ this.VS_Path "vscvars32.bat""`n"
		code := "@echo off`ncall """ this.VS_Path "vcvars32.bat""`n""" this.VS_Path "cl.exe"" sizeof.cpp"
		FileAppend, % code, compile.bat
		return 
	}
	
	Check(t, i){
		if (!i.MaxIndex() && i){
			i := [i]
		}
		includes := ""
		Loop % i.MaxIndex(){
			if (i[A_Index] == ""){
				msgbox % "*" i[A_Index] "*"
				continue
			}
			includes .= "#include <" i[A_Index] ">`n"
		}
		code := "#include <iostream>`n#include <windows.h>`n" includes "int main()`n{`nstd::cout << sizeof(" t ") << std::endl;`nreturn 0;`n}"

		FileDelete, sizeof.exe
		FileDelete, sizeof.cpp
		FileAppend, % code, sizeof.cpp
		RunWait % "compile.bat"

		ret := this.RunWaitOne("sizeof.exe")
		return ret
	}
	
	RunWaitOne(command) {
		; WshShell object: http://msdn.microsoft.com/en-us/library/aew9yb99
		shell := ComObjCreate("WScript.Shell")
		; Execute a single command via cmd.exe
		exec := shell.Exec(ComSpec " /C " command)
		; Read and return the command's output
		return exec.StdOut.ReadAll()
	}

}
