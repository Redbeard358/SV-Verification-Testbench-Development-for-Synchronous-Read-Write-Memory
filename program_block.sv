`include "test.sv"

program program_test (memory_if vif);
  Test t1;
  
  initial begin
    $display("[PROGRAM BLOCK] Simulation started at time = %0t", $time());
    Test = new(vif,vif.tb_mon_in,vif.tb_mon_out);
	t1.run();
	$display("[PROGRAM BLOCK] Simulation finished at time = %0t", $time());
  end
  
endprogram