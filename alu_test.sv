
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
  	MODE_CHECK1 trans;
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

class test2 extends alu_test;
  	MODE_CHECK0 trans;
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
    
class test_regression extends alu_test;
  	alu_transaction trans0;
  	MODE_CHECK1 trans1;
  	MODE_CHECK0 trans2;
  function new(virtual alu_if vidrv,virtual alu_if vimon,virtual alu_if viref);
      super.new(vidrv,vimon,viref);
    endfunction
  	
  	task run();
      $display("MODE_CHECK1 test");
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
          	trans0 = new();
          	env.gen.tr_gr = trans0;
         
        end
  	endtask
endclass
