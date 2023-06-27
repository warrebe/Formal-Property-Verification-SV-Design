class Bus;
rand bit[15:0] addr;
rand bit[31:0] data;
constraint  word_align {addr[1:0]==2'b0; data <= 444;}
//constraint  low_addr   {addr == 500; addr >= 10;}

endclass
