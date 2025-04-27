#!/bin/bash
echo "hello"
source /tools/Xilinx/Vivado/2022.2/settings64.sh
vivado -mode batch -source go.tcl
