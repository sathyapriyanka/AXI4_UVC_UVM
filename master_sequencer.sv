// Axi_master_sequencer
class Axi_master_sequencer extends uvm_sequencer#(Axi_master_seq_item);
// ----------------------Factory Registration --------------------------------/
  	`uvm_component_utils(Axi_master_sequencer)
//--------------------------- constructor new method -------------------------/
function new(string name = "Axi_master_sequencer", uvm_component parent);
super.new(name, parent);
    	`uvm_info("Axi_master_SEQUENCER","object created",UVM_LOW);
endfunction 
endclass : Axi_master_sequencer