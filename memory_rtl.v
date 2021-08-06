module memory_rtl(clk,reset,wr,rd,addr,wdata,rdata,response);

  parameter reg [15:0] ADDR_WIDTH = 4;  // By writng 15:0 we are restricing that the value of ADDR_WIDTH is limited to max 16bit value, i.e. (2^16 - 1). Betond that it will throw error or truncate
  parameter reg [15:0] DATA_WIDTH = 32;
  parameter reg [15:0] MEM_SIZE   = 16;
  
  input clk,reset;
  input wr; // if wr=1, write should happen
  input rd; // if rd=1, read should happen
  
  input  [ADDR_WIDTH-1:0]addr;    // 0 - 255 locations
  input  [DATA_WIDTH-1:0]wdata;
  output [DATA_WIDTH-1:0]rdata;
  output reg response;  // PROVIDES RESPONSE TO MASTER ON SUCCESSFUL WRITE
  
  wire [DATA_WIDTH-1:0]rdata;
  
  reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];
  //  NO OF CHOCOLATES       TOTAL NO OF CANS 
  //  INSIDE EACH CAN 
  
  reg [DATA_WIDTH-1:0] data_out;
  reg out_enable;  // CONTROLS WHEN TO PASS READ DATA  ON RDATA PIN
  
  integer i;
  
  // RTL SAMPLING PROCESS OR THREAD
  // Asynchronous reset and synchronous write
  always @(posedge clk or posedge reset)  // Its asynchronous reset, but writing is done synchronously
  begin
    if(reset)  // SAMPLING THE VALUES
	   begin
	      for(i=0;i<MEM_SIZE-1;i=i+1)
		     mem[i] <= 'b0;  // we can't write it as DATA_WIDTH'0 , this won't work
	   end
    else if(wr)
	  begin
	  // FOR INSERTING BUG MANUALLY
	  /*  if(addr == 5)
		  begin
		    storage[addr] <= 8'hff;
			response <= 1'b1;
		  end	
		else */
		//  begin 
	        mem[addr] <= wdata;  // SAMPLING THE VALUES
	        response  <= 1'b1;
		//  end	
	  end
	else
	   response  <= 1'b0;
  end
   
  //Synchronous read
  always @(posedge clk)
  begin  
    if(rd==1) //same as if(rd)
	  begin
       data_out   <= mem[addr];
	   out_enable <= 1'b1;
	  end
    else
       out_enable <= 1'b0;  	
	   
  end
   
  // IF rd=0, RDATA SHOULD BE IN HIGH IMPEDANCE STATE   
  // IF rd=1, RDATA SHOULD BE CONTENT OF MEMORY WITH GIVEN ADDRESS   
  assign rdata = out_enable ? data_out : 'bz;  
  
endmodule