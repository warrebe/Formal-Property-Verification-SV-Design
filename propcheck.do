
# Compile Section
vlib work
vlog -sv +define+FORMAL src/gcd*.sv

vlog -sv -mfcu -cuname sva_bind +define+FORMAL src/properties.sv


# PropCheck Section
onerror {exit 1}
###### add directives
#Fix one of the nets to a value
#netlist constant clk_bypasss 1'b1
netlist reset reset_n -active_low -async
netlist clock clk -period 100


###### Run PropCheck
formal compile -d gcd -cuname sva_bind
formal verify -timeout 60s


exit 0