// Axi_slave_sequencer
class Axi_slave_sequencer extends uvm_sequencer#(Axi_slave_seq_item);
// ----------------------Factory Registration --------------------------------/
  	`uvm_component_utils(Axi_slave_sequencer)
//--------------------------- constructor new method -------------------------/
 function new(string name = "Axi_slave_sequencer", uvm_component parent);
 super.new(name, parent);
    	`uvm_info("Axi_slave_SEQUENCER","object created",UVM_LOW);
endfunction 
endclass : Axi_slave_sequencer