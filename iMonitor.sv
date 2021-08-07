class iMonitor;
   
   Packet pkt;   
   string name;
   bit [15:0] no_of_pkts_rcvd;
   virtual memory_if.tb_mon_in vif;
   mailbox #(Packet) mbx;
   
   function new(input mailbox #(Packet) mbx_in, 
                input virtual memory_if.tb_mon_in vif_in,
				input string name = "iMonitor");
				
	 this.mbx = mbx_in;
	 this.vif = vif_in;
	 this.name = name;
   endfunction
   
   task run();
     bit [15:0] addr;
	 $display("[iMonitor] Run task is started at time = %0t", $time() );
     
	 while(1) 
	   begin
	    @(vif.cb_mon_in.wdata);
		if(vif.cb_mon_in.wr == 0)
		  continue;
		pkt = new;
		pkt.addr = vif.cb_mon_in.addr;
		pkt.data = vif.cb_mon_in.wdata; // write data
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
   