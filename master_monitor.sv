// Axi_master_monitor	
class Axi_master_monitor extends uvm_monitor;
// --------------------Factory Registration -------------------------
 	 `uvm_component_utils(Axi_master_monitor)  
	// instance of transaction class, master agent config and virtual interface 
	virtual AXI_if intf;
	AXI_master_agent_config m_agent_config;
	Axi_master_seq_item xtn;
	int i;
  	// semaphores for 5 channels
	semaphore sem_waddr=new(1);
	semaphore sem_wdata=new(1);
	semaphore sem_resp =new(1);
	semaphore sem_raddr=new(1);
	semaphore sem_rdata=new(1);   	
	//5 analysis port
  	uvm_analysis_port #(Axi_master_seq_item) m_awddr_port;
  	uvm_analysis_port #(Axi_master_seq_item) m_wdata_port;
  	uvm_analysis_port #(Axi_master_seq_item) m_wresp_port;
  	uvm_analysis_port #(Axi_master_seq_item) m_arddr_port;
  	uvm_analysis_port #(Axi_master_seq_item) m_rdata_port;
    
	extern function new(string name = "Axi_master_monitor", uvm_component  parent);
               extern  function void build_phase(uvm_phase phase);
	extern  function void connect_phase (uvm_phase phase);
               extern task run_phase(uvm_phase phase);
               extern task collect_data(Axi_master_seq_item xtn);//collect data
 	//  5 channels task   
	extern task write_addr(Axi_master_seq_item xtn);
	extern task write_data(Axi_master_seq_item xtn);
	extern task write_resp(Axi_master_seq_item xtn);
	extern task read_addr(Axi_master_seq_item xtn);
	extern task read_data(Axi_master_seq_item xtn);
 
endclass: Axi_master_monitor
//****************************************************************************************
  
//--------------------------- constructor new method -------------------------/
function Axi_master_monitor::new(string name = "Axi_master_monitor", uvm_component parent);
	super.new(name,parent); 
  	m_awddr_port = new("m_awddr_port",this);
  	m_wdata_port = new("m_wdata_port",this);
  	m_wresp_port = new("m_wresp_port",this);
  	m_arddr_port = new("m_arddr_port",this);
  	m_rdata_port = new("m_rdata_port",this);
	//`uvm_info("Axi_master_monitor","object created",UVM_LOW);
endfunction 
// ---------------------Build_phase Method ------------------------------//
function void Axi_master_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
  	xtn = Axi_master_seq_item::type_id::create("xtn");
	// config db and create methods 
	m_agent_config = AXI_master_agent_config::type_id::create("m_agent_config");
  	if(! uvm_config_db # (virtual AXI_if ) :: get (this,"*","vms_if",m_agent_config.intf))
	`uvm_fatal("Apb_master_driver","GET Failed");      
endfunction
// ---------------------Connect_phase Method ------------------------------//
function void  Axi_master_monitor::connect_phase (uvm_phase phase);
 	intf = m_agent_config.intf;
endfunction
// ---------------------Run_phase Method ------------------------------//
task Axi_master_monitor::run_phase(uvm_phase phase);
	forever
		begin 
  			xtn=Axi_master_seq_item::type_id::create("xtn");
			collect_data(xtn);
		end
endtask
//----------------------collect task-----------------------------------
task Axi_master_monitor::collect_data(Axi_master_seq_item xtn);
 	// xtn=Axi_master_seq_item::type_id::create("xtn");//create tx for collecting all fields
	fork
		begin
			sem_waddr.get(1);
			write_addr(xtn);
			//sem_waddr.put(1); 
		end  
		begin
			sem_wdata.get(1);
 			write_data(xtn);  
			sem_wdata.put(1);
  			sem_waddr.put(1);
		end
		begin
			sem_resp.get(1);
			write_resp(xtn);
			sem_resp.put(1); 
		end   
		begin
			sem_raddr.get(1);
			read_addr(xtn);
			//sem_raddr.put(1); 
		end 
		begin
			sem_rdata.get(1);
			read_data(xtn);
			sem_rdata.put(1); 
 			sem_raddr.put(1);  
		end 
	join
endtask     
 //--------------------------------write address-----------
task Axi_master_monitor::write_addr(Axi_master_seq_item xtn);
  	@(intf.mstr_mon);
//collect data from interface and load to xtn
               wait(intf.mstr_mon.AWREADY && intf.mstr_mon.AWVALID==1)
			xtn.AWID <=intf.mstr_mon.AWID;
			xtn.AWADDR <=intf.mstr_mon.AWADDR;
			xtn.AWLEN <=intf.mstr_mon.AWLEN;
			xtn.AWSIZE <=intf.mstr_mon.AWSIZE;
			xtn.AWBURST <=intf.mstr_mon.AWBURST;        
        
          //`uvm_info("Axi_master_monitor",$sformatf("printing from master monitor write_address %s",xtn.sprint()),UVM_LOW); 
              m_awddr_port.write(xtn);//write to anlysis_port 
endtask:write_addr
      
//--------------------------------write data----------             
task Axi_master_monitor::write_data(Axi_master_seq_item xtn);
	@(intf.mstr_mon);
  	wait(intf.mstr_mon.WVALID)
  	wait(intf.mstr_mon.WREADY)
  	for(i=0;i<=intf.mstr_mon.AWLEN;i++)
    	begin
        	@(intf.mstr_mon);
			xtn.WSTRB <= intf.mstr_mon.WSTRB;
			xtn.WDATA.push_back(intf.mstr_mon.WDATA);
			@(intf.mstr_mon); 
    	end
	xtn.WLAST <= intf.mstr_mon.WLAST;    
  	//`uvm_info("Axi_master_monitor",$sformatf("printing from master monitor write data%s",xtn.sprint()),UVM_LOW); 
    
  	m_wdata_port.write(xtn);//write to anlysis_port
endtask
//--------------------------------write response------------------------
task Axi_master_monitor::write_resp(Axi_master_seq_item xtn);
          @(intf.mstr_mon);
          wait(intf.mstr_mon.BREADY ==1 && intf.mstr_mon.BVALID==1)
          xtn.BID   <=intf.mstr_mon.BID;
          xtn.BRESP <=intf.mstr_mon.BRESP;   
          m_wresp_port.write(xtn);//write to anlysis_port
endtask             
//--------------------------------read address--------------------------
task Axi_master_monitor::read_addr(Axi_master_seq_item xtn);
	@(intf.mstr_mon);
 	//collect data from interface and load to xtn 
	wait(intf.mstr_mon.ARREADY && intf.mstr_mon.ARVALID  )         
  			@(intf.mstr_mon);		
			xtn.ARID   <=intf.mstr_mon.ARID;
			xtn.ARADDR <=intf.mstr_mon.ARADDR;
			xtn.ARLEN  <=intf.mstr_mon.ARLEN;
			xtn.ARSIZE <=intf.mstr_mon.ARSIZE;
			xtn.ARBURST<=intf.mstr_mon.ARBURST;
  			//`uvm_info("Axi_master_monitor",$sformatf("printing from master monitor read address%s",xtn.sprint()),UVM_LOW);   
  			m_arddr_port.write(xtn);//write to anlysis_port
endtask
//--------------------------------read data-----------------------------
task Axi_master_monitor::read_data(Axi_master_seq_item xtn); 
	@(intf.mstr_mon);
	//@(intf.mstr_mon);
	wait(intf.mstr_mon.RREADY ==1 && intf.mstr_mon.RVALID ==1 )  
  	for(int j=0;j<=intf.mstr_mon.ARLEN;j++)
    	begin
      		@(intf.mstr_mon);     
			xtn.RID <=intf.mstr_mon.RID;
			xtn.RDATA.push_back(intf.mstr_mon.RDATA);
			xtn.RRESP <=intf.mstr_mon.RRESP;
 			@(intf.mstr_mon);
    	end
	xtn.RLAST <= intf.mstr_mon.RLAST;
              `uvm_info("Axi_master_monitor",$sformatf("printing from master monitor read data%s",xtn.sprint()),UVM_LOW);
 	m_rdata_port.write(xtn);//write to anlysis_port
endtask
    