#singleinstance force
#include AHK-SizeOf-Checker.ahk

t := "RAWINPUTDEVICE"
i := "windows.h"

sc := new SizeofChecker()
val := sc.Check(t, i)

msgbox % "Size Of " t " from " i " is: " val
