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
   
endinterface
    
    
