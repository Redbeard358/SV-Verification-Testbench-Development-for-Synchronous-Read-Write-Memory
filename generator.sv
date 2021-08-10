class Generator;
 
  Packet pkt;
  mailbox #(Packet pkt);
  
  bit [15:0] no_of_pkts;
  
  function new (mailbox #(Packet) mbx_in, bit [15:0] gen_pkts_no = 1);
    this.no_of_pkts = gen_pkts_no;
	this.mbx        = mbx_in;
  endfunction
  
  task run;
    bit [15:0] pkt_count;
	Packet ref_pkt = new;
	
	$display("[Generator] Run task started at time = %0t", $time);
	
	// FIRST PACKET AS RESET PACKET
	pkt = new;
	pkt.kind = RESET;
	pkt.reset_cycles = 2;
	$display("[Generator] Sending %0d no of %0s type packets to the Driver at time = %0t",
	                           pkt_count,  pkt.kind.name(),                           $time); 
							 
	mbx.put(pkt);
	
    // GENERATE THE NORMAL STIMULUS
	repeat(no_of_pkts)
	 begin
	   assert(ref_pkt.randomize());
	   pkt = new;	   
	   pkt.kind = STIMULUS;
	   pkt.copy(ref_pkt);
	   mbx.put(pkt);
	   pkt_count++;
	    
       $display("[Generator] Sending %0d no of %0s type packets to the Driver at time = %0t",
	                           pkt_count,  pkt.kind.name(),                              $time); 
							   
	 end

    $display("[Generator] Run task ended at time = %0t", $time);	 
	
  endtask
	
  function void report(input string str = "Generator");
	$display("[%0s] Report : Total packets generated = %0d",str,no_of_pkts);
  endfunction
  
  
endclass


