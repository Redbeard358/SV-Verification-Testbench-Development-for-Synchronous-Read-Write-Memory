class oMonitor;
   
   Packet pkt;   
   string name;
   bit [15:0] no_of_pkts_rcvd;
   virtual memory_if.tb_mon_in vif;
   mailbox #(Packet) mbx;
   
   function new(input mailbox #(Packet) mbx_in, 
                input virtual memory_if.tb_mon_in vif_in,
				input string name = "oMonitor");
				
	 this.mbx = mbx_in;
	 this.vif = vif_in;
	 this.name = name;
   endfunction
   
   task run();
     bit [15:0] addr;
	 $display("[oMonitor] Run task is started at time = %0t", $time() );
     
	 while(1) 
	   begin
	    @(vif.cb_mon_out.rdata);
		
		if(vif.cb_mon_out.rdata === 'z || vif.cb_mon_out.rdata === 'x )
		  begin 
		    $display("[DEBUG] At time = %0t, from %0s , rdata = %0d",$time,name,vif.cb_mon_out.rdata);
            continue;
		  end
				
		pkt = new;
		pkt.addr = vif.cb_mon_out.addr;
		pkt.data = vif.cb_mon_out.rdata; // write data
		mbx.put(pkt);
		no_of_pkts_rcvd++;
		pkt.print();
		$display("[%0s] %0d no of packets sent to scoreboard at time = %0t",name,no_of_pkts_rcvd,$time() );
      end
    
    $display("[%0s] Run task ended at time = %0t", name, $time() );		
   
   endtask
   
   function void report ();
     $display("[%0s] Report : Total packets received = %0d",name,no_of_pkts_rcvd);   
   endfunction
   
endclass 
   