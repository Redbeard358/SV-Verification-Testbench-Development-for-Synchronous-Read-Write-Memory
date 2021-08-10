`include "environment.sv"

class Test;
   
  bit [15:0] no_of_pkts;   
  virtual memory_if.tb vif;
  virtual memory_if.tb_mon_in  vif_mon_in;
  virtual memory_if.tb_mon_out vif_mon_out;
  environment env;
  
  function new(input virtual memory_if.tb vif,
               input virtual memory_if.tb_mon_in  vif_mon_in,
			   input virtual memory_if.tb_mon_out vif_mon_out);
	
	this.vif = vif;
	this.vif_mon_in  = vif_mon_in;
	this.vif_mon_out = vif_mon_out;	
  endfunction
  
  function void build();
    $display("[Test] Build phase started at time = %0t",$time);
    no_of_pkts = 10;
	env = new(vif, vif_mon_in, vif_mon_out, no_of_pkts);
	$display("[Test] Build phase ended at time = %0t",$time);
  endfunction
  
  task run();
    $display("[Test] Run task started at time = %0t",$time);
	  build();
	  env.run();
	
	
	
	
    $display("[Test] Run task ended at time = %0t",$time);
	
  endtask
  
endclass
  