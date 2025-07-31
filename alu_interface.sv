`include "defines.sv"

interface alu_if(input bit CLK, input bit RESET);

  logic [`DATA_WIDTH-1:0] OPA;
  logic [`DATA_WIDTH-1:0] OPB;
  logic [`CMD_WIDTH-1:0] CMD;
  logic MODE;
  logic CIN;
  logic [1:0] INP_VALID;
  logic CE;

  logic [(`DATA_WIDTH)+1:0] RES;
  logic COUT, OFLOW, G, E, L, ERR;
  
  clocking drv_cb @(posedge CLK);
    default input #0 output #0;
    output OPA, OPB, CMD, MODE, CIN, INP_VALID, CE; 
  endclocking
  
  clocking mon_cb @(posedge CLK);
    default input #0 output #0;
    input RES, COUT, OFLOW, G, E, L, ERR;
  endclocking
  
  clocking ref_cb @(posedge CLK or posedge RESET);
    default input #0 output #0;
    input RESET;
  endclocking
  
  modport DRV(clocking drv_cb);
  modport MON(clocking mon_cb);
  modport REF(clocking ref_cb);
  

	property check_reset;
		@(posedge CLK)RESET |=> ##[1:10] (RES == 9'bzzzzzzzz && ERR == 1'bz && E == 1'bz && G == 1'bz && L == 1'bz && COUT == 1'bz && OFLOW == 1'bz);
	endproperty
	assert property(check_reset)
		$display("RESET assertion PASS %0t",$time);
	else
		$info("RESET assertion FAIL %0t",$time);


		property wait_16_arithmetic;
			@(posedge CLK) disable iff(RESET) (CE && MODE && (CMD == `ADD || CMD == `SUB || CMD == `ADD_CIN || CMD == `SUB_CIN || CMD == `SHIFT_MUL || CMD == `INC_MUL) && (INP_VALID == 2'b01 || INP_VALID == 2'b10)) |-> ##16 (ERR == 1'b1);
		endproperty
		assert property(wait_16_arithmetic)
			$display("16 wait for arithmetic(MODE=1)assertion PASS at time %0t", $time);
		else
      $warning("16 wait for arithmetic(MODE=1) assertion FAIL at time %0t", $time);


		property wait_16_logical;
		  @(posedge CLK) disable iff(RESET) (CE && (!MODE)&&(CMD == `AND || CMD == `OR || CMD == `NAND || CMD == `XOR || CMD == `XNOR || CMD == `NOR || CMD == `SHR1_A || CMD == `SHR1_B || CMD == `SHL1_A || CMD == `SHL1_B || CMD == `ROR_A_B  || CMD == `ROL_A_B) && (INP_VALID == 2'b01 || INP_VALID == 2'b10)) |-> ##16 (ERR == 1'b1);
		endproperty
		assert property(wait_16_logical)
			$display("16 wait for arithmetic(MODE=1)assertion PASS at time %0t", $time);
    else
      $warning("16 wait for arithmetic(MODE=1) assertion FAIL at time %0t", $time);


		property out_of_range_arithmetic;
			@(posedge CLK) (MODE && CMD > 10) |=> (ERR == 1);
		endproperty
		assert property(out_of_range_arithmetic)
			$display("CMD out of range for arithmetic assertion PASS at time %0t", $time);
		else
			$info("CMD out of range for arithmetic assertion FAIL at time %0t", $time);


		property out_of_range_logical;
      @(posedge CLK) (!MODE && CMD > 13) |=> (ERR == 1);
    endproperty
    assert property(out_of_range_logical)
      $display("CMD out of range for logical assertion PASS at time %0t", $time);
    else
      $info("CMD out of range for logical assertion FAIL at time %0t", $time);	

		

		property inp_valid_00;
			@(posedge CLK) (INP_VALID == 2'b00) |=> (ERR==1 );
		endproperty
		assert property(inp_valid_00)
			$display("INP_VALID 00  assertion PASS at time %0t", $time);
		else
			$display("INP_VALID 00  assertion FAIL at time %0t", $time);

			
		property clock_enable;
			@(posedge CLK) disable iff(RESET) !CE |-> ##1 ($stable(RES) && $stable(COUT) && $stable(OFLOW) && $stable(G) && $stable(L) && $stable(E) && $stable(ERR));
		endproperty
		assert property(clock_enable)
			$display("Clock Enable assertion PASS at time %0t", $time);
		else
			$info("Clock Enable assertion FAIL at time %0t", $time);


		sequence seq1;
        CE ==1 && (((MODE ==1) && CMD inside{0,1,2,3,4,5,6,7,8}) || MODE == 0);
      endsequence 
      
	  property clock_cycle_delay_1;
    @(posedge CLK) seq1 |=> RES;
  	endproperty
    assert property (clock_cycle_delay_1)
			$display("Single clock cycle delay aplied");
    else 
			$warning("No result after 1 clock cycle");
       
       sequence seq2;
         CE == 1 && (MODE == 1 && CMD inside {9,10});
       endsequence
       
       property clock_cycle_delay_2;
         @(posedge CLK) seq2 ##2 RES;
       endproperty 
       assert property (clock_cycle_delay_2)
				 $display("2 clock cycle delay aplied for multiplication");
			 else
	       $warning("No resut for multiplication after 2 clock cycle ");
	


endinterface
   
    
