// USING THE PREVIOUSLY WRITTEN CODE FOR MEMORY MODEL - COMPLETED ON SV DAY 5
// DECLARING RTL INSIDE MODULE, USING VERILOG STYLE OF CODING

// STEP 5 : DECLARING A PORT dif OF TYPE INTERFACE, INISDE THE RTL PORT LIST
module memory_rtl(memory_if.dut_ports dif);

  parameter reg [15:0] ADDR_WIDTH = 4;  // By writng 15:0 we are restricing that the value of ADDR_WIDTH is limited to max 16bit value, i.e. (2^16 - 1). Betond that it will throw error or truncate
  parameter reg [15:0] DATA_WIDTH = 32;
  parameter reg [15:0] MEM_SIZE   = 16;
      
  reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];
    
  reg [DATA_WIDTH-1:0] data_out;
  reg out_enable;  // CONTROLS WHEN TO PASS READ DATA  ON RDATA PIN
  
  integer i;
  
  // RTL SAMPLING PROCESS OR THREAD
  // Asynchronous reset and synchronous write
  always @(posedge dif.clk or posedge dif.reset)  // Its asynchronous reset, but writing is done synchronously
  begin
    if(dif.reset)  // SAMPLING THE VALUES
	   begin
	      for(i=0;i<MEM_SIZE-1;i=i+1)
		     mem[i] <= 'b0;  // we can't write it as DATA_WIDTH'0 , this won't work
	   end
    else if(dif.wr)
	  begin
	  // FOR INSERTING BUG MANUALLY
	  /*  if(addr == 5)
		  begin
		    storage[addr] <= 8'hff;
			response <= 1'b1;
		  end	
		else */
		//  begin 
	        mem[dif.addr] <= dif.wdata;  // SAMPLING THE VALUES
	        dif.response  <= 1'b1;
		//  end	
	  end
	else
	   dif.response  <= 1'b0;
  end
   
  //Synchronous read
  always @(posedge dif.clk)
  begin  
    if(dif.rd==1) //same as if(rd)
	  begin
       data_out   <= mem[dif.addr];
	   out_enable <= 1'b1;
	  end
    else
       out_enable <= 1'b0;  	
	   
  end
   
  // IF rd=0, RDATA SHOULD BE IN HIGH IMPEDANCE STATE   
  // IF rd=1, RDATA SHOULD BE CONTENT OF MEMORY WITH GIVEN ADDRESS   
  assign dif.rdata = out_enable ? data_out : 'bz;  
  
endmodule