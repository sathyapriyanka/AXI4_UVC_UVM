// Axi_test
class Axi_test extends uvm_test;
	// ----------------------------Factory Registration --------------------------------------/
  	`uvm_component_utils(Axi_test)
	// instance for sequence and env and configs
  	Axi_env Axi_test_env;
  	Axi_master_sequence m_sequence;
  	Axi_slave_sequence s_sequence;
  	//AXI_env_config e_config;
  	//AXI_master_agent_config m_config;
  	//AXI_slave_agent_config  s_config;
  	//int has_master=1;
  	//int has_slave=1;
  	//--------------------------- constructor new method -------------------------/
  	function new(string name = "Axi_test", uvm_component parent);
		super.new(name,parent);
    	`uvm_info("Axi_test","object created",UVM_LOW);
	endfunction : new 
  	//---------------build phase-----------------------
 	function void build_phase(uvm_phase phase);
 		super.build_phase(phase);
    // e_config = AXI_env_config::type_id::create("e_config");   
	//uvm_config_db # (AXI_env_config):: set (this,"*","AXI_env_config", e_config);
	Axi_test_env = Axi_env::type_id::create("Axi_test_env",this);   
	m_sequence = Axi_master_sequence::type_id::create("m_sequence",this);
   	s_sequence = Axi_slave_sequence::type_id::create("s_sequence",this);
       
	/* if(has_master) 
 			begin    
				m_config=AXI_master_agent_config::type_id::create("m_config",this);
				m_config.is_active = UVM_ACTIVE;
  			end    
  		if(has_slave) 
			begin   
            	s_config=AXI_slave_agent_config::type_id::create("s_config",this);    
                s_config.is_active = UVM_ACTIVE; 
      		end*/    
	endfunction		
  	//--------------------run phase------------------------
  	task  run_phase(uvm_phase phase);
		super.run_phase(phase);
    	uvm_top.print_topology();
    	// starting sequence                
    	`uvm_info("AXI_TEST","Calling AXI_sequence",UVM_LOW)
    	phase.raise_objection(this);
    	fork
    		m_sequence.start(Axi_test_env.Axi_env_master_agent.Axi_agent_master_sequencer);
    		s_sequence.start(Axi_test_env.Axi_env_slave_agent.Axi_agent_slave_sequencer);
    	join    
    	#1000;
    	phase.drop_objection(this);
  	endtask
  
endclass :Axi_test