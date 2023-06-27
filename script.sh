#!/bin/bash
vlib work
vlog src/tb.sv src/gcd*.sv #-cover sbcef +cover=f -O0 
vsim tb -c -do src/propcheck.do #-coverage
