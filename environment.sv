`include "Packet.sv"
`include "Generator.sv"
`include "Driver.sv"
`include "iMonitor.sv"
`include "oMonitor.sv"
`include "Scoreboard.sv"


class Environment;

  bit [15:0] no_of_pkts;
  mailbox #(Packet) gen_drv_mbox;     // WILL BE CONNECTED TO GENERATOR AND DRIVER
  mailbox #(Packet) mon_in_scb_mbox;  // WILL BE CONNECTED TO INPUT MONITOR AND MON_IN IN SCOREBOARD 
  mailbox #(Packet) mon_out_scb_mbox; // WILL BE CONNECTED TO OUTPUT MONITOR AND MON_OUT IN SCOREBOARD

  virtual memory_if.tb vif;
  virtual memory_if.tb_mon_in  vif_mon_in;
  virtual memory_if.tb_mon_out vif_mon_out;
  
  Generator  gen;
  Driver     drv;
  iMonitor   mon_in;
  oMonitor   mon_out;
  Scoreboard scb;

  function new(input virtual memory_if.tb vif,
               input virtual memory_if.tb_mon_in  vif_mon_in,
			   input virtual memory_if.tb_mon_out vif_mon_out,
			   input bit [15:0] no_of_pkts);
			   
	this.vif = vif;
	this.vif_mon_in  = vif_mon_in;
	this.vif_mon_out = vif_mon_out;
	this.no_of_pkts  = no_of_pkts;
  endfunction
			   
  function void build();
    $display("[Environment] Build phase started at time = %0t",$time);
	
	gen_drv_mbox = new();
	mon_in_scb_mbox = new();
	mon_out_scb_mbox = new();
	
	gen     = new(gen_drv_mbox , no_of_pkts);
	drv     = new(gen_drv_mbox , vif);
	mon_in  = new(mon_in_scb_mbox, vif_mon_in, "iMonitor");
	mon_out = new(mon_out_scb_mbox, vif_mon_out, "oMonitor");
	scb     = new(mon_in_scb_mbox, mon_out_scb_mbox);
	
	$display("[Environment] Build phase ended at time = %0t",$time);
  endfunction
  
  task run();
    $display("[Environment] Run task started at time = %0t",$time);
	build();  // Construct and connect
	
	fork
	  gen.run();
	  drv.run();
	  mon_in.run();
	  mon_out.run();
	  scb.run();
	join_any    
    repeat (10)
      @(vif.cb); // drain time
        report();
      
	$display("[Environment] Run task ended at time = %0t",$time);  	  
  endtask
  
  function void report ();
    $display("\n[Environment] *** Report started ***");
	gen.report();
	drv.report();
	mon_in.report();
	mon_out.report();
	scb.report();
	
	$display("\n**********************************");
	
	if(scb.mismatched == 0 && no_of_pkts == scb.total_pkts_rcvd)
	  begin
	    $display("************** TEST PASSED **************");
        $display("Matched = %0d, Mismatched =%0d", scb.matched, scb.mismatched);	  
	  end
	else
	  begin
	    $display("************** TEST FAILED **************");
        $display("Matched = %0d, Mismatched =%0d", scb.matched, scb.mismatched);
	  end
	$display("\n**********************************");
    $display("\n[Environment] *** Report ended ***");
endclass

