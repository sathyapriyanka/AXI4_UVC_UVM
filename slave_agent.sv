// Axi_slave_agent
class Axi_slave_agent extends uvm_agent;
// ----------------------------Factory Registration -------------------------/
   	`uvm_component_utils(Axi_slave_agent)
	// instance of driver, sequencer, monitor   
   	Axi_slave_driver   Axi_agent_slave_driver;
 	Axi_slave_sequencer  Axi_agent_slave_sequencer;
 	Axi_slave_monitor   Axi_agent_slave_monitor;   
   	//AXI_slave_agent_config s_agt_config;   
//--------------------------- constructor new method -------------------------/
function new(string name = "Axi_slave_agent", uvm_component parent);
super.new(name,parent);
     	`uvm_info("Axi_slave_agent","object created",UVM_LOW);
endfunction  
// ---------------------Build_phase Method ------------------------------//
function void build_phase(uvm_phase phase);
super.build_phase(phase);
      	Axi_agent_slave_sequencer = Axi_slave_sequencer :: type_id :: create ("Axi_agent_slave_sequencer", this);
      	Axi_agent_slave_driver = Axi_slave_driver :: type_id :: create ("Axi_agent_slave_driver", this);     	
      	Axi_agent_slave_monitor = Axi_slave_monitor :: type_id :: create ("Axi_agent_slave_monitor", this);
endfunction  
// ---------------------Connect_phase Method ------------------------------//
function void connect_phase (uvm_phase phase);     
            // port connection bw driver and sequencer
            Axi_agent_slave_driver.seq_item_port.connect(Axi_agent_slave_sequencer.seq_item_export);      
endfunction  
endclass: Axi_slave_agent