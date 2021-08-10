`include "interface.sv"
`include "memory_rtl.sv"
`include "program_block.sv"

module top;
 
  parameter reg [15:0] ADDR_WIDTH = 4; 
  parameter reg [15:0] DATA_WIDTH = 32;
  parameter reg [15:0] MEM_SIZE   = 16;
  
  bit clk;
  
  always #5 clk = !clk;
  
  //INSTANTIATING THE INTERFACE
  memory_if #(ADDR_WIDTH,DATA_WIDTH,MEM_SIZE) pif(.clk(clk));  // THIS IS CALLED PHYSICAL INTERFACE
  
  //INSTANTIATING THE DUT
  memory_rtl #(ADDR_WIDTH,DATA_WIDTH,MEM_SIZE) dut_inst ( .clk(clk),
                                                          .reset(pif.reset),
			                                              .wr(pif.wr),
			                                              .rd(pif.rd),
			                                              .addr(pif.addr),
			                                              .wdata(pif.wdata),
			                                              .rdata(pif.rdata),
			                                              .response(pif.response)
						                                );	
														
  //INSTANTIATING THE PROGRAM BLOCK	
  program_test ptest(.vif(pif));

endmodule  