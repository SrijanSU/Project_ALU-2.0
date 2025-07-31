`include "alu_package.sv"
`include "defines.sv"
`include "design.sv"
`include "alu_transaction.sv"
 `include "alu_generator.sv"
 `include "alu_driver.sv"
 `include "alu_monitor.sv"
 `include "alu_scoreboard.sv"
 `include "alu_reference.sv"
 `include "alu_environment.sv"
 `include "alu_test.sv"
`include "alu_interface.sv"


module top;
  	import alu_package:: *;
  	bit CLK;
  	bit RESET;
  	
  	initial begin
    	CLK = 1'b0;
      forever #(`PERIOD/2) CLK = ~ CLK;	
    end
  
  	initial begin
		@(posedge CLK)
   			RESET = 1'b1;
      #60 @(posedge CLK);
      			RESET = 1'b0;
    end
  
  	alu_if intf(CLK,RESET);
  
  ALU_DESIGN #(.DW(`DATA_WIDTH),.CW(`CMD_WIDTH)) DUT(
      .CLK(CLK),
      .RST(RESET),
      .OPA(intf.OPA),
      .OPB(intf.OPB),
      .INP_VALID(intf.INP_VALID),
      .CMD(intf.CMD),
      .MODE(intf.MODE),
      .CE(intf.CE),
      .CIN(intf.CIN),
      .COUT(intf.COUT),
      .RES(intf.RES),
      .ERR(intf.ERR),
      .OFLOW(intf.OFLOW),
      .G(intf.G),
      .E(intf.E),
      .L(intf.L)
    );
  
  alu_test tb = new(intf.DRV,intf.MON,intf.REF);

  test1 tb1 = new(intf.DRV,intf.MON,intf.REF);
  test4 tb4 = new(intf.DRV,intf.MON,intf.REF);
  test5 tb5 = new(intf.DRV,intf.MON,intf.REF);
  test8 tb8 = new(intf.DRV,intf.MON,intf.REF);
  test9 tb9 = new(intf.DRV,intf.MON,intf.REF);
  test10 tb10 = new(intf.DRV,intf.MON,intf.REF);
  test11 tb11 = new(intf.DRV,intf.MON,intf.REF);
  test12 tb12 = new(intf.DRV,intf.MON,intf.REF);
  test13 tb13 = new(intf.DRV,intf.MON,intf.REF);
  test14 tb14 = new(intf.DRV,intf.MON,intf.REF);
  test15 tb15 = new(intf.DRV,intf.MON,intf.REF);
  test16 tb16 = new(intf.DRV,intf.MON,intf.REF);
	test17 Mul 	= new(intf.DRV,intf.MON,intf.REF);
  
  test_regression tb_regression = new(intf.DRV,intf.MON,intf.REF);
  
  	initial begin
      $display("=== ALU TEST BENCH STARTED ===");
      tb_regression.run();
      tb.run();
			Mul.run();
      $display("=== ALU TEST BENCH COMPLETED ===");
      $finish();
    end
  
endmodule
