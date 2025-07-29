`include"defines.sv"
class alu_environment;
  	virtual alu_if vidrv;
  	virtual alu_if vimon;
  	virtual alu_if viref;
  
  mailbox #(alu_transaction) mbx_g2d;
  mailbox #(alu_transaction) mbx_d2r;
  mailbox #(alu_transaction) mbx_m2s;
  mailbox #(alu_transaction) mbx_r2s;
  
  	alu_generator gen;
  	alu_driver drv;
  	alu_monitor mon;
  	alu_reference_model ref_model;
  	alu_scoreboard scb;
  
  function new(virtual alu_if vidrv,virtual alu_if vimon,virtual alu_if viref);
    	this.vidrv = vidrv;
      	this.vimon = vimon;
      	this.viref = viref;
    endfunction
  
  	task build();
      mbx_g2d = new();
      mbx_d2r = new();
      mbx_m2s = new();
      mbx_r2s = new();
      
      gen = new(mbx_g2d);
      drv = new(mbx_g2d,mbx_d2r,vidrv);
      mon = new(mbx_m2s,vimon);
      ref_model = new(mbx_d2r,mbx_r2s,viref);
      scb = new(mbx_m2s,mbx_r2s);
  	endtask
  	
  	task start();
      	fork
          	gen.start();
          drv.start(); 
          	mon.start();
          	scb.start();
          	ref_model.start();
        join
  	endtask
endclass
