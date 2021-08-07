interface memory_if(input clk); // This is a physical interface
  
  parameter reg [15:0] ADDR_WIDTH = 4;
  parameter reg [15:0] DATA_WIDTH = 32;
  parameter [15:0] MEM_SIZE = 16;
  
  logic reset;
  logic slv_rsp;
  logic wr; // for write wr = 1
  logic rd; // for write rd = 1

  logic [ADDR_WIDTH-1:0] addr;
  logic [DATA_WIDTH-1:0] wdata;
  logic [DATA_WIDTH-1:0] rdata;
  
  clocking cb @(posedge clk)
   // all directions are wrt to testbench
   output wr;
   output rd;
   output addr;
   input wdata;
   input rdata;
  endclocking
  
  clocking cb_mon_in @(posedge clk)
   // all directions are wrt to testbench
   input wr;
   input rd;
   input addr;
   input wdata;   
  endclocking
  
  clocking cb_mon_out @(posedge clk)
   // all directions are wrt to testbench
   input wr;
   input rd;
   input addr;
   input rdata;
  endclocking
  
  
  modport tb(clocking cb, output reset, input slv_rsp);
  modport tb_mon_in(clocking cb_mon_in);
  modport tb_mon_out(clocking cb_mon_out);                                         
  
endinterface