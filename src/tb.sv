`timescale 1ns/1ns
`include "covergroups.sv"
`include "src/bus.sv"

module tb; //testbench module 

integer input_file, output_file, in, out;
integer i;

parameter CYCLE = 100; 

reg clk, reset_n;
reg start, done;
reg [31:0] a_in, b_in; 
reg [31:0] result;
reg [31:0] result2;

//clock generation for write clock
initial begin
  clk <= 0; 
  forever #(CYCLE/2) clk = ~clk;
end

//release of reset_n relative to two clocks
initial begin
    input_file  = $fopen("input.data", "rb");

    if (input_file==0) begin 
      $display("ERROR : CAN NOT OPEN input_file"); 
    end
    output_file = $fopen("output.data", "wb");
    if (output_file==0) begin 
      $display("ERROR : CAN NOT OPEN output_file"); 
    end
    a_in='x;
    b_in='x;
    start=1'b0;
    reset_n <= 0;
    #(CYCLE * 1.5) reset_n = 1'b1; //reset for 1.5 clock cycles
end

Bus cts = new;
cg_out cgout2 = new; 
cg_out cgout = new; 
cg_ain cgain0 = new;
cg_fsmtrans cgfsm0 = new;

reg done2;
reg [31:0] aa,bb;
gcd gcd_1(.result(result2), .a_in(aa), .b_in(bb), .clk, .reset_n, .done(done2), .start);
gcd gcd_0(.*); //instantiate the gcd unit


initial begin

//  repeat(5)
  if (cts.randomize() ==1) 
	begin
	aa = cts.addr; 
	bb = cts.data;
	$display("addr=%b, data=%d", cts.addr,cts.data);
	end
  else
	$error("no cigar");

  #(CYCLE*4);  //delay after reset
  while(! $feof(input_file)) begin 
   $fscanf(input_file,"%d %d", a_in, b_in);
   start=1'b1;
   $display("\n\n t=%0t start=%b", $time,start); 
   #(CYCLE);
   start=1'b0;
   while(done != 1'b1) #(CYCLE);
   $display ("t=%0t, %d cycles later, a_in=%d   b_in=%d   result=%d", $time, $time/CYCLE, a_in, b_in, result);
   #(CYCLE*2); //2 cycle delay between trials
  end
$stop;
$fclose(input_file);
$fclose(output_file);
end

endmodule
