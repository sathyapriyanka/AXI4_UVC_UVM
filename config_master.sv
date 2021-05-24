// AXI master_agent_config      
class AXI_master_agent_config extends uvm_object;
// ----------------------------Factory Registration -----------------/
              `uvm_object_utils (AXI_master_agent_config)
	virtual interface  AXI_if  intf;
	//uvm_active_passive_enum is_active = UVM_ACTIVE;
 // ----------------------------new method -----------------/
function new (string name  = "AXI_master_agent_config");
super.new(name);
endfunction 
endclass
      
      
