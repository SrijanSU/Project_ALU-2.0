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
    CMD inside {0}; 
                       else
                         CMD inside {[0:13]};}
  
  constraint valid_INP_VALID{INP_VALID inside {3};
                            CE == 1;}
  constraint valid_MODE{MODE inside {[0:1]};}
  
  
  
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

class MODE_CHECK1 extends alu_transaction;			//All arithmetic commands
  	    constraint valid_CMD{if(MODE==1) 
          CMD inside {[0:8]}; 
                       else
                         CMD inside {[0:13]};}
  
  constraint valid_INP_VALID{INP_VALID inside {3};
                            CE == 1;}
  constraint valid_MODE{MODE inside {1};}
  
  
  
  	virtual function alu_transaction copy();
    	MODE_CHECK1 copy1;
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

class MODE_CHECK0 extends alu_transaction;				// All logical commands
  constraint valid_CMD {
    if (MODE == 0)
      CMD inside {[0:13]};  
    else
      CMD inside {[0:8]};
  }

  constraint valid_INP_VALID {
    INP_VALID inside {[0:3]};
    CE == 1;
  }

  constraint valid_MODE {
    MODE inside {0};
  }

  virtual function alu_transaction copy();
    MODE_CHECK0 copy0;
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

// class CMD_MUL_ONLY_CHECK extends alu_transaction;
//   constraint mul_CMD_only {
//     CMD inside {9, 10};
//   }

//   constraint mode_arithmetic {
//     MODE == 1;
//   }

//   constraint full_inputs {
//     INP_VALID == 3;
//     CE == 1;
//   }

//   virtual function alu_transaction copy();
//     CMD_MUL_ONLY_CHECK copy_mul;
//     copy_mul = new();
//     copy_mul.INP_VALID = this.INP_VALID;
//     copy_mul.MODE = this.MODE;
//     copy_mul.CMD = this.CMD;
//     copy_mul.CE = this.CE;
//     copy_mul.OPA = this.OPA;
//     copy_mul.OPB = this.OPB;
//     copy_mul.CIN = this.CIN;
//     return copy_mul;
//   endfunction
// endclass

// class CE_LOW extends alu_transaction;

//   // Constraint: CE must be 0
//   constraint ce_zero {
//     CE == 0;
//   }

//   // Constraint: CMD between 0 and 13
//   constraint valid_CMD {
//     if (MODE == 0)
//       CMD inside {[0:13]};  
//     else
//       CMD inside {[0:10]};
//   }


  
//   constraint inp_valid_range {
//     INP_VALID inside {[0:3]};
//   }

 
//   constraint mode_range {
//     MODE inside {0, 1};
//   }

  
//   virtual function alu_transaction copy();
//     CE_LOW c;
//     c = new();
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

// class INP_VALID_0_Trans extends alu_transaction;
  
//   constraint c_inp_valid {
//     INP_VALID == 0;
//   }

//   virtual function alu_transaction copy();
//     INP_VALID_0_Trans c = new();
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

// class INP_VALID_1_Trans extends alu_transaction;
  
//   constraint c_inp_valid {
//     INP_VALID == 1;
//   }

//   virtual function alu_transaction copy();
//     INP_VALID_1_Trans c = new();
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

// class INP_VALID_2_Trans extends alu_transaction;
  
//   constraint c_inp_valid {
//     INP_VALID == 2;
//   }

//   virtual function alu_transaction copy();
//     INP_VALID_2_Trans c = new();
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

// class INP_VALID_3_Trans extends alu_transaction;
  
//   constraint c_inp_valid {
//     INP_VALID == 3;
//   }

//   virtual function alu_transaction copy();
//     INP_VALID_3_Trans c = new();
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

