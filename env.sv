// Axi_env
class Axi_env extends uvm_env;
// ----------------------------Factory Registration ------------------------------------------/
  	`uvm_component_utils(Axi_env)
               //instance of master_agent, slave_agent, scoreboard
 	Axi_slave_agent Axi_env_slave_agent;
	Axi_master_agent Axi_env_master_agent;
               Axi_scoreboard Axi_env_scoreboard;
   	// AXI_env_config e_config; 
//--------------------------- constructor new method -------------------------/
function new(string name, uvm_component parent);
super.new(name,parent);
endfunction   
// ---------------------Build_phase Method ------------------------------//
function void build_phase(uvm_phase phase);
super.build_phase(phase);
      	Axi_env_slave_agent = Axi_slave_agent :: type_id :: create("Axi_env_slave_agent", this);      
      	Axi_env_master_agent = Axi_master_agent :: type_id :: create("Axi_env_master_agent", this);     
      	Axi_env_scoreboard = Axi_scoreboard :: type_id :: create("Axi_env_scoreboard", this);     
endfunction
//---------------------connect phase---------------------------- 
function void connect_phase(uvm_phase phase); 
               // port connection between monitors and scoreboards
//master monitor analysis port connection with scoreboard analysis export	
    	Axi_env_master_agent.Axi_agent_master_monitor.m_awddr_port.connect(Axi_env_scoreboard.m_awddr_fifo.analysis_export);
	Axi_env_master_agent.Axi_agent_master_monitor.m_wdata_port.connect(Axi_env_scoreboard.m_wdata_fifo.analysis_export);
	Axi_env_master_agent.Axi_agent_master_monitor.m_wresp_port.connect(Axi_env_scoreboard.m_wresp_fifo.analysis_export);
	Axi_env_master_agent.Axi_agent_master_monitor.m_arddr_port.connect(Axi_env_scoreboard.m_arddr_fifo.analysis_export);
	Axi_env_master_agent.Axi_agent_master_monitor.m_rdata_port.connect(Axi_env_scoreboard.m_rdata_fifo.analysis_export);
//slave monitor analysis port connection with scoreboard analysis export		
    	Axi_env_slave_agent.Axi_agent_slave_monitor.s_awddr_port.connect(Axi_env_scoreboard.s_awddr_fifo.analysis_export);
    	Axi_env_slave_agent.Axi_agent_slave_monitor.s_wdata_port.connect(Axi_env_scoreboard.s_wdata_fifo.analysis_export);
    	Axi_env_slave_agent.Axi_agent_slave_monitor.s_wresp_port.connect(Axi_env_scoreboard.s_wresp_fifo.analysis_export);
    	Axi_env_slave_agent.Axi_agent_slave_monitor.s_arddr_port.connect(Axi_env_scoreboard.s_arddr_fifo.analysis_export);
    	Axi_env_slave_agent.Axi_agent_slave_monitor.s_rdata_port.connect(Axi_env_scoreboard.s_rdata_fifo.analysis_export);	    
endfunction   
endclass: Axi_env
     
     