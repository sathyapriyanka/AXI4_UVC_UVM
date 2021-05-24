 //AXI_env_config:
class AXI_env_config  extends  uvm_object;
// ----------------------------Factory Registration ------------------------------------------/
              `uvm_object_utils (AXI_env_config)
	//bit has_scoreboard = 1;
	//bit has_AXI_slave_agent = 1; 
//bit has_AXI_master_agent = 1; 
   	AXI_slave_agent_config  s_config;
   	AXI_master_agent_config  m_config;
               virtual  AXI_if intf;
//--------------------------- constructor new method ----------------/
function new (string name = "AXI_env_config");
super.new(name);
endfunction 
endclass