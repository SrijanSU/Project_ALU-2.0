`include "defines.sv"

class alu_monitor;
	alu_transaction tr_mn;
  mailbox #(alu_transaction) mbx_m2s;
  	virtual alu_if.MON vif;
  	
  
  
  covergroup output_cg;
  	coverpoint tr_mn.RES;
  	coverpoint tr_mn.ERR;
  	coverpoint tr_mn.OFLOW;
  	coverpoint tr_mn.COUT;
  	coverpoint tr_mn.G;
  	coverpoint tr_mn.E;
  	coverpoint tr_mn.L;
  endgroup

  
  function new(mailbox #(alu_transaction) mbx_m2s,virtual alu_if.MON vif);
    this.mbx_m2s = mbx_m2s;
    this.vif = vif;
    output_cg=new();
  	endfunction
  
  	task start();
      repeat(2) @(vif.mon_cb);
      	for(int i=0;i<`NUM_TRANSACTIONS;i++)begin
      		tr_mn = new();
          repeat(2) @(vif.mon_cb);
      			tr_mn.RES = vif.mon_cb.RES;
      			tr_mn.COUT = vif.mon_cb.COUT;
      			tr_mn.ERR = vif.mon_cb.ERR;
      			tr_mn.OFLOW = vif.mon_cb.OFLOW;
      			tr_mn.G = vif.mon_cb.G;
      			tr_mn.E = vif.mon_cb.E;
      			tr_mn.L = vif.mon_cb.L;
         
          
          $display("[MONITOR]DUT MONITOR PASSING DATA TO SCOREBOARD RES = %0d, COUT = %0d, ERR = %0d, OFLOW = %0d, G = %0d, E = %0d, L = %0d",tr_mn.RES,tr_mn.COUT,tr_mn.ERR,tr_mn.OFLOW,tr_mn.G,tr_mn.E,tr_mn.L,$time);   		
      		mbx_m2s.put(tr_mn);
          
          output_cg.sample();
          $display("OUTPUT FUNCTIONAL COVERAGE = %.2f", output_cg.get_coverage());
      	end
  	endtask
endclass
