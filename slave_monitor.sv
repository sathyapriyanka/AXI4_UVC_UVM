// Axi_slave_monitor	
class Axi_slave_monitor extends uvm_monitor;
// --------------------Factory Registration --------------------------/
  	`uvm_component_utils(Axi_slave_monitor)  
  	// instance of slave transaction class and virtual interface and slave_agent_config
  	virtual AXI_if intf;
  	Axi_slave_seq_item xtn_h;
  	AXI_slave_agent_config s_agent_config;
  	int i;
  	// semaphores for 5 channels
	semaphore sem_waddr=new(1);
	semaphore sem_wdata=new(1);
	semaphore sem_resp =new(1);
	semaphore sem_raddr=new(1);
	semaphore sem_rdata=new(1); 
  	//analysis port
  	uvm_analysis_port #(Axi_slave_seq_item) s_awddr_port;
  	uvm_analysis_port #(Axi_slave_seq_item) s_wdata_port;
  	uvm_analysis_port #(Axi_slave_seq_item) s_wresp_port;
  	uvm_analysis_port #(Axi_slave_seq_item) s_arddr_port;
  	uvm_analysis_port #(Axi_slave_seq_item) s_rdata_port;
    
  	extern  function new(string name = "Axi_slave_monitor", uvm_component  parent);
               extern  function void build_phase(uvm_phase phase);
	extern  function void connect_phase (uvm_phase phase);
	extern  task run_phase(uvm_phase phase);
               extern  task collect_data(Axi_slave_seq_item xtn_h);

 	//  5 channels task   
  	extern task write_addr(Axi_slave_seq_item xtn_h);
  	extern task write_data(Axi_slave_seq_item xtn_h);
  	extern task write_resp(Axi_slave_seq_item xtn_h);
  	extern task read_addr(Axi_slave_seq_item xtn_h);
  	extern task read_data(Axi_slave_seq_item xtn_h);
endclass: Axi_slave_monitor
//*********************************************************************************   
//--------------------------- constructor new method -------------------------/
function Axi_slave_monitor::new(string name = "Axi_slave_monitor", uvm_component parent);
	super.new(name,parent);
  	s_awddr_port = new("s_awddr_port",this);
  	s_wdata_port = new("s_wdata_port",this);
  	s_wresp_port = new("s_wresp_port",this);
  	s_arddr_port = new("s_arddr_port",this);
  	s_rdata_port = new("s_rdata_port",this);
	//`uvm_info("Axi_master_monitor","object created",UVM_LOW);
endfunction 
// ---------------------Build_phase Method ------------------------------//
function void Axi_slave_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	xtn_h = Axi_slave_seq_item::type_id::create("xtn_h");
	// config db and create methods 
  	s_agent_config = AXI_slave_agent_config::type_id::create("s_agent_config");
  	if(! uvm_config_db # (virtual AXI_if ) :: get (this,"*","vms_if",s_agent_config.intf))
	`uvm_fatal("Apb_master_driver","GET Failed");      
endfunction
// ---------------------Connect_phase Method ------------------------------//
function void  Axi_slave_monitor::connect_phase (uvm_phase phase);
 	intf = s_agent_config.intf;
endfunction
    
// ---------------------Run_phase Method ------------------------------//
task Axi_slave_monitor::run_phase(uvm_phase phase);
  	forever
	begin  
          	xtn_h=Axi_slave_seq_item::type_id::create("xtn_h");
          	collect_data(xtn_h);
	end
endtask
//------------------collect information-------------------------------- 
task Axi_slave_monitor::collect_data(Axi_slave_seq_item xtn_h);
 	// xtn=Axi_master_seq_item::type_id::create("xtn");//create tx for collecting all fields
	fork
	begin
			sem_waddr.get(1);
  			write_addr(xtn_h);
			sem_waddr.put(1); 
	end  
	begin
			sem_wdata.get(1);
  			write_data(xtn_h);  
			sem_wdata.put(1);
          	//sem_waddr.put(1); 
	end
	begin
			sem_resp.get(1);
  			write_resp(xtn_h);
			sem_resp.put(1); 
	end    
	begin
			sem_raddr.get(1);
  			read_addr(xtn_h);

	end 
	begin
			sem_rdata.get(1);
  			read_data(xtn_h);
			sem_rdata.put(1);
  			sem_raddr.put(1); 
	end 
	join
endtask     
//--------------------------------write address----------- 
task Axi_slave_monitor::write_addr(Axi_slave_seq_item xtn_h);
      @(intf.slv_mon);
      
 	  //collect data from interface and load to xtn
      wait(intf.slv_mon.AWREADY && intf.slv_mon.AWVALID==1)       		
      		//@(intf.mstr_mon);      
	xtn_h.AWID <=intf.slv_mon.AWID;
	xtn_h.AWADDR <=intf.slv_mon.AWADDR;
	xtn_h.AWLEN <=intf.slv_mon.AWLEN;
	xtn_h.AWSIZE <=intf.slv_mon.AWSIZE;
	xtn_h.AWBURST <=intf.slv_mon.AWBURST;       
endtask:write_addr
//--------------------------------write data----------             
task Axi_slave_monitor::write_data(Axi_slave_seq_item xtn_h);              
      @(intf.slv_mon);
      wait(intf.slv_mon.WVALID)
      wait(intf.slv_mon.WREADY)
       for(int k=0;k<=intf.mstr_mon.AWLEN;k++)
       begin
        	@(intf.slv_mon); 
	xtn_h.WSTRB <= intf.slv_mon.WSTRB;             
      	xtn_h.WDATA.push_back(intf.slv_mon.WDATA);
      	@(intf.slv_mon);  
        end
	 xtn_h.WLAST <= intf.slv_mon.WLAST;   
        s_wdata_port.write(xtn_h);//write to anlysis_port
endtask
//--------------------------------write response---------------------       
task Axi_slave_monitor::write_resp(Axi_slave_seq_item xtn_h);
         @(intf.slv_mon);
          wait(intf.slv_mon.BREADY ==1 && intf.slv_mon.BVALID==1)        	
        	xtn_h.BID   <=intf.slv_mon.BID;
        	xtn_h.BRESP <=intf.slv_mon.BRESP;  
          s_wresp_port.write(xtn_h);//write to anlysis_port
endtask             
//--------------------------------read address----------------------            
task Axi_slave_monitor::read_addr(Axi_slave_seq_item xtn_h);
      @(intf.slv_mon);
 //collect data from interface and load to xtn
     wait(intf.slv_mon.ARREADY && intf.slv_mon.ARVALID  )         
      @(intf.slv_mon);		
	xtn_h.ARID <=intf.slv_mon.ARID;
	xtn_h.ARADDR <=intf.slv_mon.ARADDR;
	xtn_h.ARLEN <=intf.slv_mon.ARLEN;
	xtn_h.ARSIZE <=intf.slv_mon.ARSIZE;
	xtn_h.ARBURST <=intf.slv_mon.ARBURST;
      s_arddr_port.write(xtn_h);//write to anlysis_port
endtask             
//--------------------------------read data---------------------------         
task Axi_slave_monitor::read_data(Axi_slave_seq_item xtn_h); 
    @(intf.slv_mon);
     wait(intf.slv_mon.RREADY ==1 && intf.slv_mon.RVALID ==1 ) 
  	for(int l=0;l<=intf.slv_mon.ARLEN;l++)
    	begin
	     xtn_h.RID <=intf.slv_mon.RID;
      	@(intf.slv_mon);
	     xtn_h.RDATA.push_back(intf.slv_mon.RDATA);
	     xtn_h.RRESP <=intf.slv_mon.RRESP;
      	@(intf.slv_mon);
    	end
	     xtn_h.RLAST <= intf.slv_mon.RLAST;
      	`uvm_info("Axi_slave_monitor",$sformatf("printing from slave monitor read data%s",xtn_h.sprint()),UVM_LOW);  
     	// $display("RDATA=%p",xtn_h.RDATA);   
    	s_rdata_port.write(xtn_h);//write to anlysis_port
endtask
