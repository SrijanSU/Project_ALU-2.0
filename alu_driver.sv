`include "defines.sv"
class alu_driver;
  alu_transaction tr_dr;
  alu_transaction temp_trans;
  mailbox #(alu_transaction) mbx_g2d;
  mailbox #(alu_transaction) mbx_d2r;
  virtual alu_if.DRV vif;
  bit found_valid_11;
//   bit flag=0;
// event ev_dr;
  	covergroup cg_drv;
    	INPUT_VALID : coverpoint tr_dr.INP_VALID { bins valid_opa = {2'b01};
             	                                       bins valid_opb = {2'b10};
                	                                   bins valid_both = {2'b11};
                    	                               bins invalid = {2'b00};
                        	                         }
    	COMMAND : coverpoint tr_dr.CMD { bins arithmetic[] = {[0:10]};
        	                                 bins logical[] = {[0:13]};
            	                             bins arithmetic_invalid[] = {[11:15]};
                	                         bins logical_invalid[] = {14,15};
                    	                    }
    	MODE : coverpoint tr_dr.MODE { bins arithmetic = {1};
            	                           bins logical = {0};
                	                     }
    	CLOCK_ENABLE : coverpoint tr_dr.CE { bins clock_enable_valid = {1};
        	                                     bins clock_enable_invalid = {0};
                                               }
      OPERAND_A : coverpoint tr_dr.OPA { bins opa[]={[0:(2**`DATA_WIDTH)-1]};}
      OPERAND_B : coverpoint tr_dr.OPB { bins opb[]={[0:(2**`DATA_WIDTH)-1]};} 
   	    CARRY_IN : coverpoint tr_dr.CIN { bins cin_high = {1};
                                         	  bins cin_low = {0};
                                            }
    	MODE_CMD_: cross MODE,COMMAND;
  	endgroup
  
  function new(mailbox #(alu_transaction) mbx_g2d,mailbox #(alu_transaction) mbx_d2r,virtual alu_if.DRV vif);	
      	this.mbx_g2d = mbx_g2d;
      	this.mbx_d2r = mbx_d2r;
      	this.vif = vif;
    	//this.ev_dr = ev_dr;
      	cg_drv = new();
  	endfunction
  
  function bit is_single_operand_operation(alu_transaction tr_dr);
      	if(tr_dr.MODE == 1'b1)begin
      		case (tr_dr.CMD)
           		`INC_A,`INC_B,`DEC_A,`DEC_B: return 1;
           	 	default : return 0;
            endcase
      	end
      
      	else begin
       		case(tr_dr.CMD)
           		`NOT_A,`NOT_B,`SHR1_A,`SHL1_A,`SHR1_B,`SHL1_B : return 1;
           	 	default : return 0;
       		endcase
       	end
  	endfunction
  
  	task start();
     repeat (1) @(vif.drv_cb);
      		for(int i=0;i<`NUM_TRANSACTIONS;i++)begin
//                if(flag)
//                     @(vif.drv_cb)$display($time);
              	tr_dr = new();
              	mbx_g2d.get(tr_dr);
              	if(is_single_operand_operation(tr_dr))begin
                  repeat(1)@(vif.drv_cb)begin
              			vif.drv_cb.INP_VALID <= tr_dr.INP_VALID;
                  		vif.drv_cb.CMD <= tr_dr.CMD;
                  		vif.drv_cb.MODE <= tr_dr.MODE;
                  		vif.drv_cb.OPA <= tr_dr.OPA;
                  		vif.drv_cb.OPB <= tr_dr.OPB;
                  		vif.drv_cb.CIN <= tr_dr.CIN;
                  		vif.drv_cb.CE <= tr_dr.CE;
                    	@(vif.drv_cb)
                    $display("Driver driving the data to interface IPV_VALID = %0d,MODE = %0d, CMD = %0d, CE = %0d, OPA =%0d, OPB = %0d, CIN = %0d",vif.drv_cb.INP_VALID,vif.drv_cb.MODE,vif.drv_cb.CMD,vif.drv_cb.CE,vif.drv_cb.OPA,vif.drv_cb.OPB,vif.drv_cb.CIN,$time);
                  		mbx_d2r.put(tr_dr);
                    	//-> ev_dr;
                  		cg_drv.sample();
                  		$display("INPUT FUNCTIONAL COVERAGE =%.2f ",cg_drv.get_coverage());
                  end
              	end
              	
              	else if(tr_dr.INP_VALID == 2'b11 || tr_dr.INP_VALID == 2'b00)begin
                  repeat(1)@(vif.drv_cb)
              			vif.drv_cb.INP_VALID <= tr_dr.INP_VALID;
                  		vif.drv_cb.CMD <= tr_dr.CMD;
                  		vif.drv_cb.MODE <= tr_dr.MODE;
                  		vif.drv_cb.OPA <= tr_dr.OPA;
                  		vif.drv_cb.OPB <= tr_dr.OPB;
                  		vif.drv_cb.CIN <= tr_dr.CIN;
                  		vif.drv_cb.CE <= tr_dr.CE;
                   		 @(vif.drv_cb)
                   $display("Driver driving the data to interface IPV_VALID = %0d,MODE = %0d, CMD = %0d, CE = %0d, OPA =%0d, OPB = %0d, CIN = %0d",vif.drv_cb.INP_VALID,vif.drv_cb.MODE,vif.drv_cb.CMD,vif.drv_cb.CE,vif.drv_cb.OPA,vif.drv_cb.OPB,vif.drv_cb.CIN,$time);
                    
                    
                      	if (tr_dr.MODE && (tr_dr.CMD == `INC_MUL || tr_dr.CMD == `SHIFT_MUL)) begin
//                           $display("HI");
//                           flag=1;
                          repeat(2)@(vif.drv_cb)
         				  mbx_d2r.put(tr_dr);
                          //-> ev_dr;
          				  cg_drv.sample();
          				  $display("INPUT FUNCTIONAL COVERAGE = %.2f", cg_drv.get_coverage());
        				end 
        				else begin
//                           flag=0;
         					@(vif.drv_cb)
           					mbx_d2r.put(tr_dr);
                          //-> ev_dr;
           					cg_drv.sample();
         					$display("INPUT FUNCTIONAL COVERAGE =%.2f ",cg_drv.get_coverage());    
       					 end
                	
              	end
              
              	else begin
                  @(vif.drv_cb)
                		vif.drv_cb.INP_VALID <= tr_dr.INP_VALID;
                  		vif.drv_cb.CMD <= tr_dr.CMD;
                  		vif.drv_cb.MODE <= tr_dr.MODE;
                  		vif.drv_cb.OPA <= tr_dr.OPA;
                  		vif.drv_cb.OPB <= tr_dr.OPB;
                  		vif.drv_cb.CIN <= tr_dr.CIN;
                  		vif.drv_cb.CE <= tr_dr.CE;
                   @(vif.drv_cb)
                  $display("3 Driver driving the data to interface IPV_VALID = %0d,MODE = %0d, CMD = %0d, CE = %0d, OPA =%0d, OPB = %0d, CIN = %0d",vif.drv_cb.INP_VALID,vif.drv_cb.MODE,vif.drv_cb.CMD,vif.drv_cb.CE,vif.drv_cb.OPA,vif.drv_cb.OPB,vif.drv_cb.CIN,$time);
                  		mbx_d2r.put(tr_dr);
                  		//-> ev_dr;
                  		cg_drv.sample();
                  		$display("INPUT FUNCTIONAL COVERAGE =%2f ",cg_drv.get_coverage());
                   found_valid_11 = 1'b0;
                  //	alu_transaction temp_trans;
                    temp_trans = new();
                  
                  for(int clk_count = 0; clk_count < `MAX_CYCLE_WAIT && !found_valid_11; clk_count++)begin
                    	temp_trans.CMD.rand_mode(0);
                    	temp_trans.MODE.rand_mode(0);
                    
                    	temp_trans.CMD = tr_dr.CMD;
                    	temp_trans.MODE = tr_dr.MODE;
                    	void'(temp_trans.randomize());
                      	@(vif.drv_cb)begin
                          	vif.drv_cb.INP_VALID<= temp_trans.INP_VALID;
                        	vif.drv_cb.CMD<= temp_trans.CMD;
                         	vif.drv_cb.MODE <= temp_trans.MODE;
                  			vif.drv_cb.OPA <= temp_trans.OPA;
                  			vif.drv_cb.OPB <= temp_trans.OPB;
                  			vif.drv_cb.CIN <= temp_trans.CIN;
                  			vif.drv_cb.CE <= temp_trans.CE;
                          $display("1 Driver driving the data to interface IPV_VALID = %0d,MODE = %0d, CMD = %0d, CE = %0d, OPA =%0d, OPB = %0d, CIN = %0d",vif.drv_cb.INP_VALID,vif.drv_cb.MODE,vif.drv_cb.CMD,vif.drv_cb.CE,vif.drv_cb.OPA,vif.drv_cb.OPB,vif.drv_cb.CIN,$time);
                  			mbx_d2r.put(temp_trans);
                          	@(vif.drv_cb)
                           // -> ev_dr;
                  			cg_drv.sample();
                  			$display("INPUT FUNCTIONAL COVERAGE =%.2f ",cg_drv.get_coverage()); 
                    	end
                    
                    	if(temp_trans.INP_VALID == 2'b11)begin
                      		found_valid_11 = 1'b1;
                          	$display("FOUND INP_VALID == 11 AT CYCLE %0d ",clk_count+1);
                            break;
                    	end
      				end
                  	
                  	if(!found_valid_11)begin
                      $display("DID NOT FOUND INP_VALID == 1 WITHIN %0d CLOCK CYCLE",`MAX_CYCLE_WAIT);
                      temp_trans.CMD.rand_mode(1);
                      temp_trans.MODE.rand_mode(1);
                  	end
                end
            end
    endtask
  
  	
endclass
