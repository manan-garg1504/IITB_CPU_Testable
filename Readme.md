# IITB-CPU (Testable)

Code for the course projects in courses EE224 and EE337. This has a testable feature, which allows you to write "assembly" (Details on how to write below) in file code.txt and run the script.ps1 power shell script to get the state of the registers after the execution of each instruction, to be able to test the CPU's correctness. 

You will need the quartus software installed, along with a c++ compiler and will have to enable external powershell scripts for this project to work on your machine. 

The syntax to write instructions into code.txt is simple, and uses the format on the "instructions encoding" page of the given problem statement (Available in the Testing Directory). Also given in this project is sample code to show you how each instruction can be written. Do note, that as of now, the assembler DOES NOT detect errors in code.txt, and wrong syntax would most likely cause a stall or at least an infinite loop.

(In essence, each line of code.txt will initiallize one memory address, starting from zero. The rest are initialized to 0)
