cd .\Testing

g++ -o Assembler Assembler.cpp

cd ..

.\Testing\Assembler.exe

quartus_map --read_settings_files=on --write_settings_files=off CPU_Testing -c CPU

quartus_sh -t "c:/intelfpga_lite/20.1/quartus/common/tcl/internal/nativelink/qnativesim.tcl" --rtl_sim "CPU_Testing" "CPU"