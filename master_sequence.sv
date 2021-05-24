// AXI_master_sequence
class Axi_master_sequence extends uvm_sequence # (Axi_master_seq_item); 
// ----------------------------Factory Registration ------------------------/
  	`uvm_object_utils(Axi_master_sequence)	 
//----------------------constructor---------------------
function new (string name = "Axi_master_sequence");
super.new(name);
endfunction  
  
virtual task body();
      repeat(3)
      begin
               //req=Axi_master_seq_item::type_id::create("req");
    	`uvm_do(req);
      end
endtask 
endclass :Axi_master_sequence

//-----------------sequence for fixed type-----------------
class fixed_mstr_seq extends Axi_master_sequence;
      `uvm_object_utils(fixed_mstr_seq)
//----------------------constructor---------------------  
function new(string name = "fixed_mstr_seq");
super.new(name);
endfunction

task body();
     repeat(3)
     begin
     `uvm_do_with(req, {req.AWBURST == 2'b00;})
     end
endtask
endclass:fixed_mstr_seq

//-----------------sequence for incr type-----------------
class incr_mstr_seq extends Axi_master_sequence;
  `uvm_object_utils(incr_mstr_seq)
 //----------------------constructor--------------------- 
function new(string name = "incr_mstr_seq");
super.new(name);
endfunction
  
task body();
    repeat(3)
    begin
    `uvm_do_with(req, {req.AWBURST == 2'b01;})
    end
endtask
endclass:incr_mstr_seq

//-----------------sequence for wrap type-----------------
class wrap_mstr_seq extends Axi_master_sequence;
  `uvm_object_utils(wrap_mstr_seq)
//----------------------constructor---------------------  
function new(string name = "wrap_mstr_seq");
super.new(name);
endfunction
  
task body();
   repeat(3)
   begin
   `uvm_do_with(req, {req.AWBURST == 2'b10;})
    end
endtask
endclass:wrap_mstr_seq              