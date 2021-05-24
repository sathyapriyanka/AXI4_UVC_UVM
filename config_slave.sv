//AXI_Slave_agt_config:
class AXI_slave_agent_config extends  uvm_object;
// ----------------------------Factory Registration ------------------------/
  	`uvm_object_utils (AXI_slave_agent_config)
	virtual interface AXI_if  intf;
	//uvm_active_passive_enum  is_active = UVM_ACTIVE;
 // ----------------------------new method -----------------/
function new (string name  = "Apb_slave_agent_config");
super.new(name);
endfunction 
endclass