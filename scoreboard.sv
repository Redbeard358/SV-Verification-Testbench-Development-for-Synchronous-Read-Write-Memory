class Scoreboard;

  bit [15:0] total_no_pkts_rcvd;
  Packet ref_pkt;
  Packet got_pkt;
  
  mailbox #(Packet) mbx_in;  // Connected to input monitor
  mailbox #(Packet) mbx_out; // Connected to output monitor
  
  
  bit [15:0] matched;
  bit [15:0] mismatched;
  
  function new(input mailbox #(Packet) mbx_in,
               input mailbox #(Packet) mbx_out );
			   
    this.mbx_in = mbx.in;
    this.mbx_out = mbx.out;
  endfunction
  
  task run();
    $display("[Scoreboard] Run task is started at time = %0t", $time() );
	while(1)
	  begin
	    mbx_in.get(ref_pkt);
	    mbx_in.out(got_pkt);
		total_no_pkts_rcvd;
		$display("[Scoreboard] %0d no of Packets received at time = %0t", total_no_pkts_rcvd,$time() );
		
		if(ref_pkt.compare(got_pkt) )
		  begin  
		    matched++;
			$display("[Scoreboard] Matched : %0d no of Packets", total_no_pkts_rcvd);
		  end
        else
          begin
            mismatched++;
			$display("[Scoreboard] ERROR: Mismatched : %0d no of Packets at time = %0t", total_no_pkts_rcvd, $time());
            $display("[Scoreboard] ### Expected addr = %0d, data = %0d , but received addr = %0d, data = %0d",
                                                 ref_pkt.addr, ref_pkt.data,          got_pkt.addr, got_pkt.data);        			
	      end		  
      end
    $display("[Scoreboard] Run task ended at time = %0t", $time() );  
  endtask
  
  function void report ();
    $display("[SCOREBOARD] Report : Total packets received = %0d",total_no_pkts_rcvd);   
	$display("[SCOREBOARD] Report : Matched= %0d, Mismatched = %0d",matched,mismatched);
  endfunction
			   
		