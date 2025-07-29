`include "defines.sv"

class alu_generator;
  	alu_transaction tr_gr;
    mailbox #(alu_transaction) mbx_g2d;
  
    function new(mailbox #(alu_transaction) mbx_g2d);
    	this.mbx_g2d = mbx_g2d;
   	 	this.tr_gr = new();
  	endfunction
  
    task start();
      for (int i = 0; i < `NUM_TRANSACTIONS; i++) begin
        assert(tr_gr.randomize())
          mbx_g2d.put(tr_gr.copy());
        
        $display("GENERATOR Randomized transactions MODE=%0d CMD=%0d OPA=%0d OPB=%0d CIN=%0d CE=%0d INP_VALID=%0d @%o0t",tr_gr.MODE, tr_gr.CMD, tr_gr.OPA, tr_gr.OPB, tr_gr.CIN,tr_gr.CE, tr_gr.INP_VALID, $time);

    end
  	endtask

endclass

