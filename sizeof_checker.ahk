; sizeof() Checker class
; Instantiation:
; If your Visual C Executable (cl.exe) is not in C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\bin\, pass path to where it actually lives.

; Usage:
; Call Check(<thing>, <include>)
; eg to check the sizeof(RAWINPUTDEVICE) from Windows.h, pass:
; Check ("RAWINPUTDEVICE", "Windows.h")

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
		code := "#include <iostream>`n#include <" i ">`nint main()`n{`nstd::cout << sizeof(" t ") << std::endl;`nreturn 0;`n}"

		FileDelete, sizeof.exe
		FileDelete, sizeof.cpp
		FileAppend, % code, sizeof.cpp
		RunWait % "compile.bat"

		return this.RunWaitOne("sizeof.exe")
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
