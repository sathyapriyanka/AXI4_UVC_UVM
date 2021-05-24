// Axi_master_driver	
class Axi_master_driver extends uvm_driver #(Axi_master_seq_item);
// --------------------Factory Registration --------------------------/
	`uvm_component_utils(Axi_master_driver)  
	// instance of transaction class and virtual interface  
	virtual AXI_if intf; 
	Axi_master_seq_item xtn;
  	//agent config handle
               AXI_master_agent_config m_agent_config;
	// transaction with 5 queues
	Axi_master_seq_item q1[$],q2[$],q3[$],q4[$],q5[$];
	int i;
  	int WLAST_temp;
	// semaphores for 5 channels
	semaphore sem_waddr=new(1);
	semaphore sem_wdata=new(1);
	semaphore sem_resp =new(1);
	semaphore sem_raddr=new(1);
	semaphore sem_rdata=new(1); 
   
	extern function new(string name = "Axi_master_driver", uvm_component  parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase (uvm_phase phase);
	extern task run_phase(uvm_phase phase);
               extern task send_to_dut(Axi_master_seq_item xtn);  //drive to dut        
 	//  5 channels task   
	extern task write_addr(Axi_master_seq_item xtn);
	extern task write_data(Axi_master_seq_item xtn);
	extern task write_resp(Axi_master_seq_item xtn);
	extern task read_addr(Axi_master_seq_item xtn);
	extern task read_data(Axi_master_seq_item xtn);
 
endclass: Axi_master_driver
  
  
//--------------------------- constructor new method -------------------------/
function Axi_master_driver::new(string name = "Axi_master_driver", uvm_component parent);
	super.new(name,parent);
	`uvm_info("Axi_master_DRIVER","object created",UVM_LOW);
endfunction 
// ---------------------Build_phase Method ------------------------------//
function void Axi_master_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	// config db and create methods 
	m_agent_config = AXI_master_agent_config::type_id::create("m_agent_config");
  	if(! uvm_config_db # (virtual AXI_if ) :: get (this,"*","vms_if",m_agent_config.intf))
	`uvm_fatal("Apb_master_driver","GET Failed");      
endfunction
// ---------------------Connect_phase Method ------------------------------//
function void  Axi_master_driver::connect_phase (uvm_phase phase);
 	intf = m_agent_config.intf;
endfunction
// ---------------------Run_phase Method ------------------------------//
task Axi_master_driver::run_phase(uvm_phase phase);
	forever
	begin  
	seq_item_port.get_next_item(xtn); 
	send_to_dut(xtn);
	seq_item_port.item_done();
	end
endtask
//-------------------drive to dut -------------------------------   
task Axi_master_driver::send_to_dut(Axi_master_seq_item xtn);
	q1.push_back(xtn);
	q2.push_back(xtn);
	q3.push_back(xtn);
	q4.push_back(xtn);
	q5.push_back(xtn);  
  	`uvm_info("Axi_master_driver",$sformatf("printing from write driver %s",xtn.sprint()),UVM_LOW);
                fork
	 begin
	  	sem_waddr.get(1);
	 	 write_addr(q1.pop_front()); 
                end  
	 begin
	 	sem_wdata.get(1); 
	 	write_data(q2.pop_front());
		 sem_wdata.put(1);
 		 sem_waddr.put(1);
	 end  
	 begin
 		sem_resp.get(1);
		write_resp(q3.pop_front());
		sem_resp.put(1); 
 	end  
	begin
		sem_raddr.get(1);
		read_addr(q4.pop_front());
		//sem_raddr.put(1); 
	end 
	begin
		sem_rdata.get(1);
		read_data(q5.pop_front());
		sem_rdata.put(1);
		sem_raddr.put(1);
	end 
	join_any
endtask   
//--------------------------------write address-----------   
task Axi_master_driver::write_addr(Axi_master_seq_item xtn);
	@(intf.mstr_dr);
	intf.mstr_dr.AWVALID<=1'b1;    
	intf.mstr_dr.AWID<=xtn.AWID;
	intf.mstr_dr.AWADDR<=xtn.AWADDR;
	intf.mstr_dr.AWLEN<=xtn.AWLEN;
	intf.mstr_dr.AWSIZE<=xtn.AWSIZE;
	intf.mstr_dr.AWBURST<=xtn.AWBURST;
     
	wait(intf.mstr_dr.AWREADY)
	@(intf.mstr_dr);
	intf.mstr_dr.AWVALID<=1'b0;
endtask:write_addr             
//--------------------------------write data----------             
task Axi_master_driver::write_data(Axi_master_seq_item xtn);
	@(intf.mstr_dr);
	//@(intf.mstr_dr);
	foreach(xtn.WDATA[i])  
		begin
			intf.mstr_dr.WVALID<=1'b1; 
			intf.mstr_dr.WDATA<=xtn.WDATA[i];  
			intf.mstr_dr.WSTRB<=xtn.WSTRB;
			if(i==xtn.WDATA.size-1)
			intf.mstr_dr.WLAST<=1'b1;
			else
			intf.mstr_dr.WLAST<=1'b0;
			@(intf.mstr_dr);
			wait(intf.mstr_dr.WREADY);
			@(intf.mstr_dr);
			intf.mstr_dr.WLAST<=1'b0;
			intf.mstr_dr.WVALID<=1'b0; 
		end
endtask     
//--------------------------------write response---------------       
task Axi_master_driver::write_resp(Axi_master_seq_item xtn);
	@(intf.mstr_dr);
 	// wait(intf.mstr_dr.WLAST)
  	WLAST_temp = intf.slv_dr.WLAST; 
	intf.mstr_dr.BREADY<=1;
  	wait(WLAST_temp);
  	wait(intf.mstr_dr.BVALID);
  	@(intf.mstr_dr);
   	@(intf.mstr_dr);
	intf.mstr_dr.BREADY<=0; 
endtask            
//--------------------------------read address--------------------
task Axi_master_driver::read_addr(Axi_master_seq_item xtn);
	@(intf.mstr_dr); 
	intf.mstr_dr.ARVALID<=1;   
	intf.mstr_dr.ARID<=xtn.ARID;
	intf.mstr_dr.ARADDR<=xtn.ARADDR;
	intf.mstr_dr.ARLEN<=xtn.ARLEN;
	intf.mstr_dr.ARSIZE<=xtn.ARSIZE;
	intf.mstr_dr.ARBURST<=xtn.ARBURST;
	wait(intf.mstr_dr.ARREADY)
	@(intf.mstr_dr);
	intf.mstr_dr.ARVALID<=0;
endtask            
//--------------------------------read data----------------------
task Axi_master_driver::read_data(Axi_master_seq_item xtn);   
	@(intf.mstr_dr);
	for(int i=0;i<=xtn.ARLEN+1;i++)
		begin
			@(intf.mstr_dr);
			intf.mstr_dr.RREADY<=1'b1;
			wait(intf.mstr_dr.RVALID);
			@(intf.mstr_dr);
			intf.mstr_dr.RREADY<=1'b0;
		end
endtask