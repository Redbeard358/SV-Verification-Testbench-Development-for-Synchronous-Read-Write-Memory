`define ADDR_WIDTH 4
`define DATA_WIDTH 32

typedef enum {IDLE,STIMULUS,RESET} pkt_type_t; // THIS TELLS US WHAT IS THE TYPE OF PACKET WE ARE GENERATING

class Packet:
  rand bit [AADR_WIDTH-1:0] addr;
  rand bit [DATA_WIDTH-1:0] data;
  
  rand bit       wr;  
  pkt_type_t kind;  
  bit slv_rsp; // IF 0 INDICATES ERROR; IF 1 INDICATES OK
  bit [3:0] reset_cycles;
  
  constraint valid {
                      addr iniside {[0:15]]};
                      data iniside {[10:999]]};
					  addr != prev_addr; 
					  data != prev_data; 
				   }
  
  function void post_randomize();
    prev_addr = addr;
    prev_data = data;  
  endfunction
  
  extern function new();
  extern function void print();
  extern function void copy(Packet pkt);
  extern function void compare(Packet pkt);
  
endclass

function void Packet::print();
  $display("[Packet] time = %0t, addr = %0d, data = %0d", $time,addr,data);
endfunction

function void Packet::copy(Packet pkt);
  if(pkt == null)
    $display("[Packet] Error null object passed to copy method");
	return; 
	
	this.addr = pkt.addr;
	this.data = pkt.data;
endfunction

function bit Packet::compare(Packet pkt);
  bit result;
  if(pkt == null)
   begin  
    $display("[Packet] Error null object passed to compare object");
	return;
   end

  result = (this.addr == pkt.addr) & (this.data == pkt.data);   	
endfunction 
