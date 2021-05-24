// Axi_master_agent
class Axi_master_agent extends uvm_agent;
// ----------------------------Factory Registration -------------------------/
   	`uvm_component_utils(Axi_master_agent)
	// instance of driver, sequencer, monitor
               Axi_master_driver   Axi_agent_master_driver;
 	Axi_master_sequencer  Axi_agent_master_sequencer;
 	Axi_master_monitor   Axi_agent_master_monitor;  
  	//AXI_master_agent_config m_agt_config;
//--------------------------- constructor new method -------------------------/
function new(string name = "Axi_master_agent", uvm_component parent);
super.new(name,parent);
     	`uvm_info("Axi_master_agent","object created",UVM_LOW);
endfunction  
//---------------------Build_phase Method ------------------------------//
function void build_phase(uvm_phase phase);
super.build_phase(phase);
       	// config db and create methods 
     	// m_agt_config = AXI_master_agent_config :: type_id :: create ("m_agt_config", this);    
    	// uvm_config_db # (AXI_master_agent_config) :: set (null,"*","vms_if",m_agt_config);
// create memory for sequencer, driver, monitor
      	Axi_agent_master_sequencer = Axi_master_sequencer :: type_id :: create ("Axi_agent_master_sequencer", this);
      	Axi_agent_master_driver = Axi_master_driver :: type_id :: create ("Axi_agent_master_driver", this);
      	Axi_agent_master_monitor = Axi_master_monitor :: type_id :: create ("Axi_agent_master_monitor", this);
endfunction  
// ---------------------Connect_phase Method ------------------------------//
function void connect_phase (uvm_phase phase);   
      	// port connection between driver and sequencer
      	Axi_agent_master_driver.seq_item_port.connect(Axi_agent_master_sequencer.seq_item_export);    
endfunction  
endclass: Axi_master_agent