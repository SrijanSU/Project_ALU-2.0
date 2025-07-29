`include "defines.sv"
class alu_scoreboard;
  	alu_transaction r2s_tr,m2s_tr;
  mailbox #(alu_transaction) mbx_m2s;
  mailbox #(alu_transaction) mbx_r2s;
  	static int MATCH,MISMATCH,percent;
  	
  function new(mailbox #(alu_transaction) mbx_m2s,mailbox #(alu_transaction) mbx_r2s);
    	this.mbx_m2s = mbx_m2s;
      	this.mbx_r2s= mbx_r2s;
  	endfunction
  
  	task start();
    	for(int i=0;i<`NUM_TRANSACTIONS;i++)begin 
          	r2s_tr= new();
          	m2s_tr =new();
          	fork
              	begin
          			mbx_m2s.get(m2s_tr);
                  $display("DUT MONITOR TO SCOREBOARD DATA RES = %0d, COUT = %0d, ERR = %0d,OFLOW = %0d, G = %0d, E = %0d, L = %0d",m2s_tr.RES,m2s_tr.COUT,m2s_tr.ERR,m2s_tr.OFLOW,m2s_tr.G,m2s_tr.E,m2s_tr.L,$time);
                end
              	begin
          			mbx_r2s.get(r2s_tr);
                 	$display("REFERENCE MODEL TO SCOREBOARD DATA RES = %0d, COUT = %0d, ERR = %0d,OFLOW = %0d, G = %0d, E = %0d, L = %0d",r2s_tr.RES,r2s_tr.COUT,r2s_tr.ERR,r2s_tr.OFLOW,r2s_tr.G,r2s_tr.E,r2s_tr.L,$time);
                end
            join
          compare_report();
          percent++;
          $display("===FINAL REPORT===");
          $display("TOTAL TRANSACTION = %0d",percent);
          $display("MATCHES = %0d",MATCH);
          $display("MISMATCHES = %0d",MISMATCH);
          $display("SUCCESS RATE = %0.2f%%",(MATCH*100.00)/percent);
    	end
  	endtask
  	
  	task compare_report();
      bit res_match = (r2s_tr.RES === m2s_tr.RES);
      bit cout_match = (r2s_tr.COUT === m2s_tr.COUT);
      bit oflow_match = (r2s_tr.OFLOW === m2s_tr.OFLOW);
      bit err_match = (r2s_tr.ERR === m2s_tr.ERR);
      bit greater_match = (r2s_tr.G === m2s_tr.G);
      bit equality_match = (r2s_tr.E === m2s_tr.E);
      bit lesser_match = (r2s_tr.L === m2s_tr.L);
      
      	if(res_match && cout_match && oflow_match && err_match && greater_match && equality_match && lesser_match)begin
			MATCH++;
          	$display("SCOREBOARD: MATCH -expected RES = %0d,COUT = %0d, ERR = %0d, OFLOW = %0d, G = %0d, E = %0d, L = %0d",m2s_tr.RES,m2s_tr.COUT,m2s_tr.ERR,m2s_tr.OFLOW,m2s_tr.G,m2s_tr.E,m2s_tr.L,$time);
      	end
      	else begin
          	MISMATCH++;
          	$display("SCOREBOARD: MISMATCH -expected RES = %0d,COUT = %0d, ERR = %0d, OFLOW = %0d, G = %0d, E = %0d, L = %0d\n Recieved - RES = %0d,COUT = %0d, ERR = %0d, OFLOW = %0d, G = %0d, E = %0d, L = %0d ",r2s_tr.RES,r2s_tr.COUT,r2s_tr.ERR,r2s_tr.OFLOW,r2s_tr.G,r2s_tr.E,r2s_tr.L,m2s_tr.RES,m2s_tr.COUT,m2s_tr.ERR,m2s_tr.OFLOW,m2s_tr.G,m2s_tr.E,m2s_tr.L,$time);
        end
  	endtask
endclass
