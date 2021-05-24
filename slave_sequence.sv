// AXI slave_sequence
class Axi_slave_sequence extends uvm_sequence # (Axi_slave_seq_item); 
// ----------------------------Factory Registration ------------------------/
  	`uvm_object_utils(Axi_slave_sequence)	
  	//instance of seq_item
 	//Axi_master_seq_item Axi_master_seq_item_h;  
//------------------constructor----------------------
function new (string name = "Axi_slave_sequence");
super.new(name);   
endfunction  
//------------------Body ----------------------
task body();
      repeat(3)
      begin
           `uvm_do(req);
      end
endtask  
endclass :Axi_slave_sequence


//-----------------sequence for fixed type-----------------
class fixed_slv_seq extends Axi_slave_sequence;
       `uvm_object_utils(fixed_slv_seq)
//------------------constructor----------------------  
function new(string name = "fixed_slv_seq");
super.new(name);
endfunction
 //------------------body----------------------
task body();
       repeat(3)
       begin
          `uvm_do_with(req, {req.AWBURST == 2'b00;})
       end
endtask
endclass:fixed_slv_seq
//-----------------sequence for incr type-----------------
class incr_slv_seq extends Axi_slave_sequence;
         `uvm_object_utils(incr_slv_seq)
//------------------new method---------------------- 
function new(string name = "incr_slv_seq");
super.new(name);
endfunction
//------------------body----------------------
task body();
     repeat(3)
     begin
          `uvm_do_with(req, {req.AWBURST == 2'b01;})
     end
endtask
endclass:incr_slv_seq
//-----------------sequence for wrap type-----------------
class wrap_slv_seq extends Axi_slave_sequence;
          `uvm_object_utils(wrap_slv_seq)
//------------------constructor----------------------  
function new(string name = "wrap_slv_seq");
super.new(name);
endfunction
//------------------body----------------------  
task body();
       repeat(3)
       begin
          `uvm_do_with(req, {req.AWBURST == 2'b10;})
       end
endtask
endclass:wrap_slv_seq              
