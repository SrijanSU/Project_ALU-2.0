
class alu_test;
  	virtual alu_if vidrv;
  	virtual alu_if vimon;
  	virtual alu_if viref;
  	
  	alu_environment env;
  	
  function new(virtual alu_if vidrv, virtual alu_if vimon, virtual alu_if viref);
  		this.vidrv = vidrv;
  		this.vimon = vimon;
  		this.viref = viref;
    endfunction
  
  	task run();
      	env = new(vidrv,vimon,viref);
      	env.build();
      $display("1");
      	env.start();      
  	endtask
endclass

class test1 extends alu_test;
  	MODE_CHECK1_00 trans;
  function new(virtual alu_if vidrv, virtual alu_if vimon, virtual alu_if viref);
      	super.new(vidrv,vimon,viref);
    endfunction
  
  	task run();
      $display("MODE CHECK 1");
      	env = new(vidrv,vimon,viref);
      	env.build();
      	begin
          	trans = new();
          	env.gen.tr_gr = trans;
        end
      	env.start();
    endtask
endclass


class test4 extends alu_test;
  	MODE_CHECK1_11 trans;
  function new(virtual alu_if vidrv, virtual alu_if vimon, virtual alu_if viref);
      	super.new(vidrv,vimon,viref);
    endfunction
  
  	task run();
      $display("MODE CHECK 1");
      	env = new(vidrv,vimon,viref);
      	env.build();
      	begin
          	trans = new();
          	env.gen.tr_gr = trans;
        end
      	env.start();
    endtask
endclass

class test5 extends alu_test;
  	MODE_CHECK0_00 trans;
  function new(virtual alu_if vidrv, virtual alu_if vimon, virtual alu_if viref);
      	super.new(vidrv,vimon,viref);
    endfunction
  
  	task run();
      $display("MODE CHECK 0");
      	env = new(vidrv,vimon,viref);
      	env.build();
      	begin
          	trans = new();
          	env.gen.tr_gr = trans;
        end 
      	env.start();
    endtask
endclass


class test8 extends alu_test;
  	MODE_CHECK0_11 trans;
  function new(virtual alu_if vidrv, virtual alu_if vimon, virtual alu_if viref);
      	super.new(vidrv,vimon,viref);
    endfunction
  
  	task run();
      $display("MODE CHECK 0");
      	env = new(vidrv,vimon,viref);
      	env.build();
      	begin
          	trans = new();
          	env.gen.tr_gr = trans;
        end 
      	env.start();
    endtask
endclass
    
 class test17 extends alu_test;
   	MUL_ONLY trans;
   function new(virtual alu_if vidrv, virtual alu_if vimon, virtual alu_if viref);
       	super.new(vidrv,vimon,viref);
     endfunction
  
   	task run();
       	env = new(vidrv,vimon,viref);
       	env.build();
       	begin
           	trans = new();
           	env.gen.tr_gr = trans;
         end 
       	env.start();
     endtask
 endclass

class test9 extends alu_test;
  	CE_LOW trans;
  function new(virtual alu_if vidrv, virtual alu_if vimon, virtual alu_if viref);
      	super.new(vidrv,vimon,viref);
    endfunction
  
  	task run();
        $display("CE_LOW");
      	env = new(vidrv,vimon,viref);
      	env.build();
      	begin
          	trans = new();
          	env.gen.tr_gr = trans;
        end 
      	env.start();
    endtask
endclass

// class test5 extends alu_test;
//   	INP_VALID_0 trans;
//   function new(virtual alu_if vidrv, virtual alu_if vimon, virtual alu_if viref);
//       	super.new(vidrv,vimon,viref);
//     endfunction
  
//   	task run();
//         $display("INP_VALID 0");
//       	env = new(vidrv,vimon,viref);
//       	env.build();
//       	begin
//           	trans = new();
//           	env.gen.tr_gr = trans;
//         end 
//       	env.start();
//     endtask
// endclass

class test10 extends alu_test;
  	SINGLE_OPERAND trans;
  function new(virtual alu_if vidrv, virtual alu_if vimon, virtual alu_if viref);
      	super.new(vidrv,vimon,viref);
    endfunction
  
  	task run();
        $display("SINGLE_OPERAND");
      	env = new(vidrv,vimon,viref);
      	env.build();
      	begin
          	trans = new();
          	env.gen.tr_gr = trans;
        end 
      	env.start();
    endtask
endclass

class test11 extends alu_test;
  	DOUBLE_OPERAND trans;
  function new(virtual alu_if vidrv, virtual alu_if vimon, virtual alu_if viref);
      	super.new(vidrv,vimon,viref);
    endfunction
  
  	task run();
      $display("DOUBLE_OPERAND");
      	env = new(vidrv,vimon,viref);
      	env.build();
      	begin
          	trans = new();
          	env.gen.tr_gr = trans;
        end 
      	env.start();
    endtask
endclass

class test12 extends alu_test;
  	INVALID_CMD trans;
  function new(virtual alu_if vidrv, virtual alu_if vimon, virtual alu_if viref);
      	super.new(vidrv,vimon,viref);
    endfunction
  
  	task run();
      $display("INVALID_CMD");
      	env = new(vidrv,vimon,viref);
      	env.build();
      	begin
          	trans = new();
          	env.gen.tr_gr = trans;
        end 
      	env.start();
    endtask
endclass

class test13 extends alu_test;
  	ERROR_CASES trans;
  function new(virtual alu_if vidrv, virtual alu_if vimon, virtual alu_if viref);
      	super.new(vidrv,vimon,viref);
    endfunction
  
  	task run();
      $display("ERROR_CASES");
      	env = new(vidrv,vimon,viref);
      	env.build();
      	begin
          	trans = new();
          	env.gen.tr_gr = trans;
        end 
      	env.start();
    endtask
endclass
class test14 extends alu_test;
  	SRIJ trans;
  function new(virtual alu_if vidrv, virtual alu_if vimon, virtual alu_if viref);
      	super.new(vidrv,vimon,viref);
    endfunction
  
  	task run();
      $display("BOUNDARY");
      	env = new(vidrv,vimon,viref);
      	env.build();
      	begin
          	trans = new();
          	env.gen.tr_gr = trans;
        end 
      	env.start();
    endtask
endclass

class test15 extends alu_test;
  	NO_VALID_2_OPERANDS trans;
  function new(virtual alu_if vidrv, virtual alu_if vimon, virtual alu_if viref);
      	super.new(vidrv,vimon,viref);
    endfunction
  
  	task run();
      $display("NO_VALID_2_OPERANDS");
      	env = new(vidrv,vimon,viref);
      	env.build();
      	begin
          	trans = new();
          	env.gen.tr_gr = trans;
        end 
      	env.start();
    endtask
endclass

class test16 extends alu_test;
  	CIN_DEPENDENT trans;
  function new(virtual alu_if vidrv, virtual alu_if vimon, virtual alu_if viref);
      	super.new(vidrv,vimon,viref);
    endfunction
  
  	task run();
      $display("CIN_DEPENDENT");
      	env = new(vidrv,vimon,viref);
      	env.build();
      	begin
          	trans = new();
          	env.gen.tr_gr = trans;
        end 
      	env.start();
    endtask
endclass



class test_regression extends alu_test;
  	alu_transaction trans0;
  	MODE_CHECK1_00 		trans1;
  	MODE_CHECK1_11 		trans4;
  	MODE_CHECK0_00 		trans5;
  	MODE_CHECK0_11 		trans8;
  	CE_LOW				trans9;
  	SINGLE_OPERAND		trans10;
  	DOUBLE_OPERAND		trans11;
  	INVALID_CMD			trans12;
  	ERROR_CASES			trans13;
  	SRIJ		trans14;
  	NO_VALID_2_OPERANDS	trans15;
  	CIN_DEPENDENT		trans16;
  	
  //CMD_MUL_ONLY_CHECK  trans3;
  	
  function new(virtual alu_if vidrv,virtual alu_if vimon,virtual alu_if viref);
      super.new(vidrv,vimon,viref);
    endfunction
  	
  	task run();
      	env = new(vidrv,vimon,viref);
      	env.build();
      	begin
          trans0 = new();
          env.gen.tr_gr = trans0;
         
        end
      	env.start();
      
      	begin
          	trans1 = new();
          	env.gen.tr_gr = trans1;
         
        end
      	env.start();
      begin
          	trans4 = new();
          	env.gen.tr_gr = trans4;
         
        end
      env.start();
       begin
          	trans5 = new();
          	env.gen.tr_gr = trans5;
         
        end
      env.start();
       begin
          	trans8 = new();
          	env.gen.tr_gr = trans8;
         
        end
      env.start();
      
      begin
          	trans9 = new();
          	env.gen.tr_gr = trans9;
         
        end
      env.start();
      
      begin
          	trans10 = new();
          	env.gen.tr_gr = trans10;
         
        end
      env.start();
      
      begin
          	trans11 = new();
          	env.gen.tr_gr = trans11;
         
        end
      env.start();
      
      begin
          	trans12 = new();
          	env.gen.tr_gr = trans12;
         
        end
      env.start();
      
      begin
          	trans13 = new();
          	env.gen.tr_gr = trans13;
         
        end
      env.start();
      
      begin
          	trans14 = new();
          	env.gen.tr_gr = trans14;
         
        end
      env.start();
      
      begin
          	trans15 = new();
          	env.gen.tr_gr = trans15;
         
        end
      env.start();
      
      begin
          	trans16 = new();
          	env.gen.tr_gr = trans16;
         
        end
      env.start();
      
   
  	endtask
endclass
