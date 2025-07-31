`include "defines.sv"

class alu_transaction;
  
  rand logic [`DATA_WIDTH-1:0] OPA;
  rand logic [`DATA_WIDTH-1:0] OPB;
  rand logic [`CMD_WIDTH-1:0] CMD;
  rand logic MODE;
  rand logic CIN;
  rand logic [1:0] INP_VALID;
  rand logic CE;
  
  logic [`DATA_WIDTH:0] RES;
  logic COUT;
  logic OFLOW;
  logic G, E, L;
  logic ERR;
  
  constraint valid_CMD{if(MODE==1) 
    soft CMD inside {[0:8]}; 
                       else
                       soft CMD inside {[0:13]};}
  
  constraint valid_INP_VALID{soft INP_VALID inside {3};
                            soft CE dist {1:=90,0:=10};}
  constraint valid_MODE{soft MODE inside {0,1};}
  
  
  
  virtual function alu_transaction copy();
    alu_transaction c = new();
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CMD       = this.CMD;
    c.MODE      = this.MODE;
    c.CIN       = this.CIN;
    c.INP_VALID = this.INP_VALID;
    c.CE		= this.CE;
    return c;
  endfunction

endclass

class MODE_CHECK1_00 extends alu_transaction;			//All arithmetic commands
  	    constraint valid_CMD{if(MODE==1) 
          CMD inside {[0:8]}; 
                       else
                         CMD inside {[0:13]};}
  
  constraint valid_INP_VALID{INP_VALID inside {0};
                            CE == 1;}
  constraint valid_MODE{MODE inside {1};}
  
  
  
  	virtual function alu_transaction copy();
    	MODE_CHECK1_00 copy1;
      	copy1 = new();
      	copy1.INP_VALID = this.INP_VALID;
      	copy1.MODE = this.MODE;
      	copy1.CMD = this.CMD;
      	copy1.CE = this.CE;
      	copy1.OPA = this.OPA;
      	copy1.OPB = this.OPB;
      	copy1.CIN = this.CIN;
      	return copy1;
    endfunction
endclass


class MODE_CHECK1_11 extends alu_transaction;			//All arithmetic commands
  	    constraint valid_CMD{if(MODE==1) 
          CMD inside {[0:8]}; 
                       else
                         CMD inside {[0:13]};}
  
  constraint valid_INP_VALID{INP_VALID inside {3};
                            CE == 1;}
  constraint valid_MODE{MODE inside {1};}
  
  
  
  	virtual function alu_transaction copy();
    	MODE_CHECK1_00 copy1;
      	copy1 = new();
      	copy1.INP_VALID = this.INP_VALID;
      	copy1.MODE = this.MODE;
      	copy1.CMD = this.CMD;
      	copy1.CE = this.CE;
      	copy1.OPA = this.OPA;
      	copy1.OPB = this.OPB;
      	copy1.CIN = this.CIN;
      	return copy1;
    endfunction
endclass




class MODE_CHECK0_00 extends alu_transaction;				// All logical commands
  constraint valid_CMD {
    if (MODE == 0)
      CMD inside {[0:13]};  
    else
      CMD inside {[0:8]};
  }

  constraint valid_INP_VALID {
    INP_VALID inside {0};
    CE == 1;
  }

  constraint valid_MODE {
    MODE inside {0};
  }

  virtual function alu_transaction copy();
    MODE_CHECK0_00 copy0;
    copy0 = new();
    copy0.INP_VALID = this.INP_VALID;
    copy0.MODE = this.MODE;
    copy0.CMD = this.CMD;
    copy0.CE = this.CE;
    copy0.OPA = this.OPA;
    copy0.OPB = this.OPB;
    copy0.CIN = this.CIN;
    return copy0;
  endfunction
endclass


class MODE_CHECK0_11 extends alu_transaction;				// All logical commands
  constraint valid_CMD {
    if (MODE == 0)
      CMD inside {[0:13]};  
    else
      CMD inside {[0:8]};
  }

  constraint valid_INP_VALID {
    INP_VALID inside {3};
    CE == 1;
  }

  constraint valid_MODE {
    MODE inside {0};
  }

  virtual function alu_transaction copy();
    MODE_CHECK0_11 copy0;
    copy0 = new();
    copy0.INP_VALID = this.INP_VALID;
    copy0.MODE = this.MODE;
    copy0.CMD = this.CMD;
    copy0.CE = this.CE;
    copy0.OPA = this.OPA;
    copy0.OPB = this.OPB;
    copy0.CIN = this.CIN;
    return copy0;
  endfunction
endclass

class CMD_MUL_ONLY_CHECK extends alu_transaction;
  constraint MUL_CMD_ONLY {
    CMD inside {9, 10};
  }

  constraint MODE_ARITHMETIC {
    MODE == 1;
  }

  constraint VALID_INP {
    INP_VALID == 3;
    CE == 1;
  }

  virtual function alu_transaction copy();
    CMD_MUL_ONLY_CHECK copy_mul;
    copy_mul = new();
    copy_mul.INP_VALID = this.INP_VALID;
    copy_mul.MODE = this.MODE;
    copy_mul.CMD = this.CMD;
    copy_mul.CE = this.CE;
    copy_mul.OPA = this.OPA;
    copy_mul.OPB = this.OPB;
    copy_mul.CIN = this.CIN;
    return copy_mul;
  endfunction
endclass

class CE_LOW extends alu_transaction;

  // Constraint: CE must be 0
  constraint CE_ZER {
    CE == 0;
  }

  // Constraint: CMD between 0 and 13
  constraint VALID_CMD {
    if (MODE == 0)
      CMD inside {[0:13]};  
    else
      CMD inside {[0:8]};
  }


  
  constraint VALID_INP {
    INP_VALID inside {3};
  }

 
  constraint mode_range {
    MODE inside {0, 1};
  }

  
  virtual function alu_transaction copy();
    CE_LOW c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.CE        = this.CE;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    return c;
  endfunction

endclass

// class INP_VALID_0 extends alu_transaction;       //Advised not to check this in regression
  
//   constraint INP_INVALID_00 {
//     INP_VALID == 0;
//   }

//   virtual function alu_transaction copy();
//     INP_VALID_0 c = new();
//     c.INP_VALID = this.INP_VALID;
//     c.MODE      = this.MODE;
//     c.CMD       = this.CMD;
//     c.CE        = this.CE;
//     c.OPA       = this.OPA;
//     c.OPB       = this.OPB;
//     c.CIN       = this.CIN;
//     return c;
//   endfunction

// endclass


class MUL_ONLY extends alu_transaction;
  constraint c_mode { MODE inside {1}; }
  constraint c_cmd  { CMD inside {9,10};}
  constraint c_valid { INP_VALID inside {[0:3]}; CE == 1; }

  virtual function alu_transaction copy();
    MUL_ONLY c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.CE        = this.CE;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    return c;
  endfunction
endclass

class SINGLE_OPERAND extends alu_transaction;
  constraint c_mode { MODE inside {0,1}; }
  constraint c_cmd  { if (MODE==1) CMD inside {4,5,6,7}; else CMD inside {6,7};}
  constraint c_valid { INP_VALID inside {[0:3]}; CE == 1; }

  virtual function alu_transaction copy();
    SINGLE_OPERAND c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.CE        = this.CE;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    return c;
  endfunction
  
endclass
                     
class DOUBLE_OPERAND extends alu_transaction;
  constraint c_mode { MODE inside {0,1}; }
  constraint c_cmd  { if (MODE==1) CMD inside {0,1,2,3,8}; else CMD inside {[0:5],[8:13]};}
  constraint c_valid { INP_VALID inside {[0:3]}; CE == 1; }

  virtual function alu_transaction copy();
    DOUBLE_OPERAND c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.CE        = this.CE;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    return c;
  endfunction
  
endclass

class INVALID_CMD extends alu_transaction;
  constraint c_mode { MODE inside {0,1}; }
  constraint c_cmd  { if (MODE==1) CMD>10; else CMD>13;}
  constraint c_valid { INP_VALID inside {[0:3]}; CE == 1; }

  virtual function alu_transaction copy();
    INVALID_CMD c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.CE        = this.CE;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    return c;
  endfunction
  
endclass

class ERROR_CASES extends alu_transaction;
  constraint c_mode { MODE inside {0}; }
  constraint c_cmd  { if (MODE==1) CMD inside {[0:10]}; else CMD inside {12,13};}
  constraint c_valid { INP_VALID inside {[0:3]}; CE == 1; }

  virtual function alu_transaction copy();
    ERROR_CASES c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.CE        = this.CE;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    return c;
  endfunction
  
endclass

class SRIJ  extends alu_transaction;
	 constraint c_valid { INP_VALID inside {[0:3]}; CE == 1; }
 	 constraint opa	{OPA inside {{`DATA_WIDTH{1'b1}},{`DATA_WIDTH{1'b0}}};}
   constraint opb	{OPB inside {{`DATA_WIDTH{1'b1}},{`DATA_WIDTH{1'b0}}};}

  virtual function alu_transaction copy();
    SRIJ c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.CE        = this.CE;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    return c;
  endfunction
  
endclass

class NO_VALID_2_OPERANDS extends alu_transaction;
  constraint c_mode { MODE inside {0,1}; }
  constraint c_cmd  { if(MODE==1)CMD inside {0,1,2,3,8};else CMD inside {0,1,2,3,4,5,8,9,10,11,12,13};  }
  constraint c_valid { INP_VALID inside {[0:2]}; CE == 1; }

  virtual function alu_transaction copy();
    NO_VALID_2_OPERANDS  c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.CE        = this.CE;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    return c;
  endfunction
  
endclass

class CIN_DEPENDENT extends alu_transaction;
  constraint c_mode { MODE inside {0,1}; }
  constraint c_cmd  { if(MODE==1)CMD inside {0,1,2,3,8};else CMD inside {0,1,2,3,4,5,8,9,10,11,12,13};  }
  constraint c_valid { INP_VALID inside {[0:2]}; CE == 1; }
  constraint c_in	{CIN inside {0,1};}
  virtual function alu_transaction copy();
    CIN_DEPENDENT  c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.CE        = this.CE;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    return c;
  endfunction
  
endclass



