class Driver;
  
  Packet pkt;
  mailbox #(packet) mbx; 
  virtual memory_if vif;
  bit [15:0] no_of_pkts_rcvd;
  
  
  function new(
                input mailbox #(Packet) mbx_in,
                input virtual memory_if.tb vif_in 
			  );
	this.mbx = mbx_in;
	this.vif = vif_in;
  
  endfunction

  extern task run();
  extern task drive(Packet pkt);
  extern task drive_reset(Packet pkt);
  extern task drive_stimulus(Packet pkt);
  extern task write(Packet pkt);
  extern task read(Packet pkt);
  extern function void report(input string = "Driver"); 
  
endclass

task Driver::run();
  $display("[Driver] Run task is started at time = %0t", $time() );
  
  while(1) // can also use forever, but forever won't work if there is nothing inside the mailbox
    begin
	  mbx.get(pkt);
	  no_of_pkts_rcvd++;
	  $display("[Driver] Received %0d no of %0s type packets from the Generator at time = %0t",
	                        no_of_pkts_rcvd, pkt.kind.name(),                             $time); 
							
	  drive(pkt);
	  $display("[Driver] Driving completed for %0d no of %0s type packets to the DUT at time = %0t",
	                        no_of_pkts_rcvd, pkt.kind.name(),                             $time);
	end
endtask

task Driver::drive(Packet pkt);
  $display("[DRIVER DRIVE] Checking for Packet type = %0t",$time());
  case(pkt.kind)
    RESET    : drive_reset(pkt);
	STIMULUS : drive_stimulus(pkt);
	default  : $display("[Error] Unknown packet received in driver");
  endcase
endtask

task Driver::drive_reset(Packet pkt);
  $display("[DRIVER RESET] Driving reset transaction into DUT at time  = %0t",$time());
  vif.reset <= 1'b1;
  repeat(pkt.reset_cycles)
    @(vif.cb);
	  vif.reset <= 1'b0;

  $display("[DRIVER RESET] Driving reset transaction completed at time  = %0t",$time());    
endtask						 

task Driver::drive_stimulus(Packet pkt);
  $display("[DRIVER STIMULUS] Driving stimulus at time  = %0t",$time());
  write(pkt);
  read(pkt);
endtask

task Driver::write(Packet pkt)
  @(vif.cb)
    $display("Driver_Write] Write operation has started with addr = %0d, and data = %0d, at time = %0t", 
	                                                               pkt.addr,      pkt.data,       $time());
    vif.cb.wr   <= 1'b1; 
	vif.cb.addr <= pkt.addr;
	vif.cb.data <= pkt.data;
	
	@(vif.cb)
	  vif.cb.wr <= 1'b0;
	  $display("Driver_Write] Write operation has ended with addr = %0d, and data = %0d, at time = %0t", 
	                                                              pkt.addr,      pkt.data,       $time());
endtask

task Driver::read(Packet pkt)
  @(vif.cb)
    $display("Driver_Read] Read operation has started with addr = %0d, at time = %0t", 
	                                                            pkt.addr,       $time());
    vif.cb.rd   <= 1'b1; 
	vif.cb.addr <= pkt.addr;	
	
	@(vif.cb)
	  vif.cb.rd <= 1'b0;
	  $display("Driver_Read] Read operation has ended with addr = %0d, at time = %0t", 
	                                                            pkt.addr,       $time());
endtask

function void Driver::report(input string str = "Driver");
  $display("[%0s] Report : Total packets received = %0d",str,no_of_pkts_rcvd);
endfunction

 