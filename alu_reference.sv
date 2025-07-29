`include "defines.sv"

class alu_reference_model;

  mailbox #(alu_transaction) mbx_d2r;  // From driver
  mailbox #(alu_transaction) mbx_r2s;  // To scoreboard

  virtual alu_if.REF vif;

  function new(mailbox #(alu_transaction) mbx_d2r,
               mailbox #(alu_transaction) mbx_r2s,
               virtual alu_if.REF vif);
    this.mbx_d2r = mbx_d2r;
    this.mbx_r2s = mbx_r2s;
    this.vif = vif;
  endfunction

  bit single_operand_cmd;

  task start();
    alu_transaction ref_trans;
    for (int i = 0; i < `NUM_TRANSACTIONS; i++) begin
      ref_trans = new();
      mbx_d2r.get(ref_trans);
      single_operand_cmd = 1'bz;

      ref_trans.RES = 1'bz;
      ref_trans.COUT = 1'bz;
      ref_trans.OFLOW = 1'bz;
      ref_trans.G = 1'bz;
      ref_trans.E = 1'bz;
      ref_trans.L = 1'bz;
      ref_trans.ERR = 1'bz;

      if (ref_trans.MODE) begin
        case (ref_trans.CMD)
          4, 5, 6, 7: single_operand_cmd = 1;
          default: single_operand_cmd = 0;
        endcase
      end else begin
        case (ref_trans.CMD)
          6, 8, 9, 7, 10, 11: single_operand_cmd = 1;
          default: single_operand_cmd = 0;
        endcase
      end

      if (ref_trans.INP_VALID == 0) begin
        ref_trans.ERR = 1;
        mbx_r2s.put(ref_trans);

      end else if ((single_operand_cmd &&
                   !((ref_trans.INP_VALID[0] == 1 && (
                          (ref_trans.MODE && (ref_trans.CMD == 4 || ref_trans.CMD == 5)) ||
                          (!ref_trans.MODE && (ref_trans.CMD == 6 || ref_trans.CMD == 8 || ref_trans.CMD == 9))
                        )) ||
                     (ref_trans.INP_VALID[1] == 1 && (
                          (ref_trans.MODE && (ref_trans.CMD == 6 || ref_trans.CMD == 7)) ||
                          (!ref_trans.MODE && (ref_trans.CMD == 7 || ref_trans.CMD == 10 || ref_trans.CMD == 11))
                        )))) ||
                  (!single_operand_cmd && ref_trans.INP_VALID != 3)) begin

        if (!single_operand_cmd) begin  // Wait up to 16 cycles
          int count = 0;
         
          while (ref_trans.INP_VALID != 3 && count < `MAX_CYCLE_WAIT) begin
           
            mbx_d2r.get(ref_trans);
           
            count++;
          end

          if (ref_trans.INP_VALID != 3) begin
            count=0;
            ref_trans.ERR = 1;
            $display(" Error as INP_VALID is not 3 even after 16 cycles. CMD=%0d MODE=%0d", ref_trans.CMD, ref_trans.MODE);
            mbx_r2s.put(ref_trans);
          end else begin
            count=0;
            operation(ref_trans);
            if (ref_trans.CMD == `INC_MUL || ref_trans.CMD == `SHIFT_MUL) begin
              repeat (2) @(vif.ref_cb);
              mbx_r2s.put(ref_trans);
            end else begin
              @(vif.ref_cb);
              mbx_r2s.put(ref_trans);
            end
          end

        end else begin
          ref_trans.ERR = 1;
          $display("Invalid input for single operand in 1 cycle CMD=%0d MODE=%0d INP_VALID=%0d",
                   ref_trans.CMD, ref_trans.MODE, ref_trans.INP_VALID);
          mbx_r2s.put(ref_trans);
        end

      end else begin
        $display("Hi");
        operation(ref_trans);
        if (ref_trans.MODE && (ref_trans.CMD == `INC_MUL || ref_trans.CMD == `SHIFT_MUL)) begin
          repeat (2) @(vif.ref_cb);
          mbx_r2s.put(ref_trans);
        end else begin
          @(vif.ref_cb);
          mbx_r2s.put(ref_trans);
         
        end
      end
    end
  endtask

  task operation(alu_transaction ref_trans);  // no delays used
    if (vif.ref_cb.RESET == 1'b1) begin
      ref_trans.RES = 9'bz;
      ref_trans.COUT = 1'bz;
      ref_trans.ERR = 1'bz;
      ref_trans.OFLOW = 1'bz;
      ref_trans.G = 1'bz;
      ref_trans.E = 1'bz;
      ref_trans.L = 1'bz;

    end else if (ref_trans.CE == 1'b1) begin
      ref_trans.RES = 9'bz;
      ref_trans.COUT = 1'bz;
      ref_trans.ERR = 1'bz;
      ref_trans.OFLOW = 1'bz;
      ref_trans.G = 1'bz;
      ref_trans.E = 1'bz;
      ref_trans.L = 1'bz;

      case (ref_trans.MODE)
        1'b1: begin  // Arithmetic
          
          case (ref_trans.CMD)
            0: begin
              ref_trans.RES = ref_trans.OPA + ref_trans.OPB;
              ref_trans.COUT = ref_trans.RES[`DATA_WIDTH] ? 1 : 0;
            end
            1: begin
              ref_trans.RES = ref_trans.OPA - ref_trans.OPB;
              ref_trans.OFLOW = (ref_trans.OPA < ref_trans.OPB) ? 1 : 0;
            end
            2: begin
              ref_trans.RES = ref_trans.OPA + ref_trans.OPB + ref_trans.CIN;
              ref_trans.COUT = ref_trans.RES[`DATA_WIDTH] ? 1 : 0;
            end
            3: begin
              ref_trans.RES = ref_trans.OPA - ref_trans.OPB - ref_trans.CIN;
              ref_trans.OFLOW = ((ref_trans.OPA < ref_trans.OPB) ||
                                ((ref_trans.OPA == ref_trans.OPB) && ref_trans.CIN)) ? 1 : 0;
            end
            4: ref_trans.RES = ref_trans.OPA + 1;
            5: ref_trans.RES = ref_trans.OPA - 1;
            6: ref_trans.RES = ref_trans.OPB + 1;
            7: ref_trans.RES = ref_trans.OPB - 1;
            8: begin
              ref_trans.RES = 0;
              ref_trans.E = (ref_trans.OPA == ref_trans.OPB);
              ref_trans.G = (ref_trans.OPA > ref_trans.OPB);
              ref_trans.L = (ref_trans.OPA < ref_trans.OPB);
            end
            9: ref_trans.RES = (ref_trans.OPA + 1) * (ref_trans.OPB + 1);
            10: ref_trans.RES = (ref_trans.OPA << 1) * ref_trans.OPB;
            default: begin
              ref_trans.RES = 0;
              ref_trans.ERR = 1;
            end
          endcase
        end

        1'b0: begin  // Logical
          case (ref_trans.CMD)
            0:  ref_trans.RES = {1'b0, ref_trans.OPA & ref_trans.OPB};
            1:  ref_trans.RES = {1'b0, ~(ref_trans.OPA & ref_trans.OPB)};
            2:  ref_trans.RES = {1'b0, ref_trans.OPA | ref_trans.OPB};
            3:  ref_trans.RES = {1'b0, ~(ref_trans.OPA | ref_trans.OPB)};
            4:  ref_trans.RES = {1'b0, ref_trans.OPA ^ ref_trans.OPB};
            5:  ref_trans.RES = {1'b0, ~(ref_trans.OPA ^ ref_trans.OPB)};
            6:  ref_trans.RES = {1'b0, ~ref_trans.OPA};
            7:  ref_trans.RES = {1'b0, ~ref_trans.OPB};
            8:  ref_trans.RES = {1'b0, ref_trans.OPA >> 1};
            9:  ref_trans.RES = {1'b0, ref_trans.OPA << 1};
            10: ref_trans.RES = {1'b0, ref_trans.OPB >> 1};
            11: ref_trans.RES = {1'b0, ref_trans.OPB << 1};
            12: begin
              ref_trans.RES = {1'b0,
                (ref_trans.OPA << ref_trans.OPB[`ROR_WIDTH-1:0]) |
                (ref_trans.OPA >> (`DATA_WIDTH - ref_trans.OPB[`ROR_WIDTH-1:0]))
              };
              if (ref_trans.OPB[`DATA_WIDTH-1:`ROR_WIDTH+1] || 0)
                ref_trans.ERR = 1;
            end
            13: begin
              ref_trans.RES = {1'b0,
                (ref_trans.OPA >> ref_trans.OPB[`ROR_WIDTH-1:0]) |
                (ref_trans.OPA << (`DATA_WIDTH - ref_trans.OPB[`ROR_WIDTH-1:0]))
              };
              if (ref_trans.OPB[`DATA_WIDTH-1:`ROR_WIDTH+1] || 0)
                ref_trans.ERR = 1;
            end
            default: begin
              ref_trans.RES = 0;
              ref_trans.ERR = 1;
            end
          endcase
        end
      endcase

    end else begin
      ref_trans.RES = 9'bz;
      ref_trans.COUT = 1'bz;
      ref_trans.ERR = 1'bz;
      ref_trans.OFLOW = 1'bz;
      ref_trans.G = 1'bz;
      ref_trans.E = 1'bz;
      ref_trans.L = 1'bz;
    end
  endtask

endclass

