// Axi_slave_driver	
class Axi_slave_driver extends uvm_driver #(Axi_slave_seq_item);
// --------------------Factory Registration ------------------------------
	`uvm_component_utils(Axi_slave_driver)  
	// instance of transaction class and virtual interface; slave_agent_config 
	virtual AXI_if.sla_dr intf;
	AXI_slave_agent_config s_agent_config;
	Axi_slave_seq_item xtn_h;
	// transaction with 5 queues
	Axi_slave_seq_item q1[$],q2[$],q3[$],q4[$],q5[$];
	// semaphores for 5 channels
	semaphore sem_waddr=new(1);
	semaphore sem_wdata=new(1);
	semaphore sem_resp =new(1);
	semaphore sem_raddr=new(1);
	semaphore sem_rdata=new(1);
	int i;
	int k ;
	int x;
	int len;
	bit [31:0]rdata;//internal rdata to display the random value in slave side
  	int burst_length[$];
	int S_ARLEN[$];
	int S_ARADDR[$];
	bit [3:0] W_AWLEN;
	int S_ARSIZE[$];
  	int Rid_temp[$];
  	int r;
  	bit [3:0] AWID_temp_q[$];
  	bit [3:0] bid;
               extern  function new(string name = "Axi_slave_driver", uvm_component parent);
	extern  function void build_phase(uvm_phase phase);
	extern function void connect_phase (uvm_phase phase);
	extern  task run_phase(uvm_phase phase);
               extern task send_to_dut(Axi_slave_seq_item xtn_h);//drive to dut
               //5 tasks for 5 channel
	extern task write_addr(Axi_slave_seq_item xtn_h);
	extern task write_data(Axi_slave_seq_item xtn_h);
	extern task write_resp(Axi_slave_seq_item xtn_h);
	extern task read_addr(Axi_slave_seq_item xtn_h);
	extern task read_data(Axi_slave_seq_item xtn_h);
endclass: Axi_slave_driver
  
//--------------------------- constructor new method -------------------------/
function Axi_slave_driver::new(string name = "Axi_slave_driver", uvm_component parent);
super.new(name,parent);
	`uvm_info("Axi_slave_DRIVER","object created",UVM_LOW);
endfunction   
// ---------------------Build_phase Method ------------------------------//
function void Axi_slave_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	// config db and create methods 
	s_agent_config =  AXI_slave_agent_config::type_id::create("s_agent_config");
	if(! uvm_config_db # (virtual AXI_if) :: get (null,"*","vms_if",s_agent_config.intf))
	`uvm_fatal("Axi_slave_driver","GET Failed");
endfunction  
// ---------------------Connect_phase Method ------------------------------//
function void Axi_slave_driver::connect_phase (uvm_phase phase);
	intf = s_agent_config.intf;
endfunction
// ---------------------Run_phase Method ------------------------------//
task Axi_slave_driver::run_phase(uvm_phase phase);	
forever
begin
              seq_item_port.get_next_item(req);
              send_to_dut(req);
              seq_item_port.item_done(); 
end
endtask:run_phase
//--------------------------------send to dut-----------------------------------
task Axi_slave_driver::send_to_dut(Axi_slave_seq_item xtn_h);   
	q1.push_back(xtn_h);
	q2.push_back(xtn_h);
	q3.push_back(xtn_h);
	q4.push_back(xtn_h);
	q5.push_back(xtn_h);
 	// `uvm_info("Axi_slave_driver",$sformatf("printing from read drivern %s",xtn_h.sprint()),UVM_LOW);//it will print all deafault 0 value bcz in 	slave_seq_item fields are not random. it is coming from master sdie only rdata is generating random value in driver directly
  	//req.print();
	fork
	begin
	    sem_waddr.get(1);
	    write_addr(q1.pop_front());
	    sem_waddr.put(1);
	end  
	begin
	     sem_wdata.get(1);
	     write_data(q2.pop_front());
	     sem_wdata.put(1); 
	   // sem_waddr.put(1);
	end  
 	begin
	      sem_resp.get(1);
	      write_resp(q3.pop_front());
	      sem_resp.put(1);  
	end  
	begin
	      sem_raddr.get(1);
	      read_addr(q4.pop_front());
               end 
	begin
	     sem_rdata.get(1);
	     read_data(q5.pop_front());
	     sem_rdata.put(1);  
 	     sem_raddr.put(1); 
	end 
	join_any
endtask 
//-----------------------------------writeaddress----------------------------------------
task Axi_slave_driver::write_addr(Axi_slave_seq_item xtn_h);
	@(intf.slv_dr);
	intf.slv_dr.AWREADY<=1; 
	//@(intf.slv_dr);
	wait(intf.slv_dr.AWVALID)
	begin
	    //W_AWLEN.push_back(intf.slv_dr.AWLEN);
	      W_AWLEN <= intf.slv_dr.AWLEN;
	       k = W_AWLEN+1;
          	      AWID_temp_q.push_back(intf.slv_dr.AWID);
          	      // bid<= AWID_temp_q.pop_front;
	      // @(intf.slv_dr);
	      @(intf.slv_dr); 
	      intf.slv_dr.AWREADY<=0;
          	end
endtask  
//---------------------------------write_data---------------------------------------
task Axi_slave_driver::write_data(Axi_slave_seq_item xtn_h);
	//@(intf.slv_dr);
	//$display("k=%d",k);
 	for(int i =0;i<=k;k++)
	begin
  	     @(intf.slv_dr);
	      intf.slv_dr.WREADY<=1'b1;
	      wait(intf.slv_dr.WVALID);
	      @(intf.slv_dr);
	      intf.slv_dr.WREADY<=1'b0;
	end
endtask
//-------------------------------writresp------------------------------------------
task Axi_slave_driver::write_resp(Axi_slave_seq_item xtn_h);
  	@(intf.slv_dr);
  	@(intf.slv_dr);
	intf.slv_dr.BVALID<=1'b1;
	intf.slv_dr.BID<=AWID_temp_q.pop_front;;
  	intf.slv_dr.BRESP<=2'b00;
	wait(intf.slv_dr.BREADY)
	wait(intf.slv_dr.WLAST);
  	intf.slv_dr.BRESP<=2'b00;//okay resp (one resp after all data transfer in a burst)
	@(intf.slv_dr);
  	@(intf.slv_dr); 
	intf.slv_dr.BVALID<=1'b0;
   	intf.slv_dr.BRESP<=2'b00;
endtask  
//----------------------------readaddr---------------------------------------------
task Axi_slave_driver::read_addr(Axi_slave_seq_item xtn_h);
  	@(intf.slv_dr);
	intf.slv_dr.ARREADY<=1;
	wait(intf.slv_dr.ARVALID)
	begin  
	    //len = intf.slv_dr.ARLEN; 
	    //burst_length = intf.slv_dr.ARSIZE;
	    //burst_length = len+1; 
  	      burst_length.push_front(intf.slv_dr.ARLEN);
  	      Rid_temp.push_front(intf.slv_dr.ARID);
   	      x = burst_length.pop_back+1;
   	      r = Rid_temp.pop_back;
  	      @(intf.slv_dr);
 	    // @(intf.slv_dr);
	       intf.slv_dr.ARREADY<=0;
	end
endtask
//--------------------------------read data----------             
task Axi_slave_driver::read_data(Axi_slave_seq_item xtn_h);   
	@(intf.slv_dr);   
	@(intf.slv_dr);  
 	 //$display("x=%d",x);  
  	for(i=0;i<x;i++)    
	begin
  	     intf.slv_dr.RVALID<=1'b1;  
  	     //intf.slv_dr.RDATA <= xtn_h.RDATA[i];
	     intf.slv_dr.RID<=r;
  	     rdata<=$random;//i have added this step to print the random value
  	     intf.slv_dr.RDATA<=rdata;
  	     intf.slv_dr.RRESP<=1'b0;//n-okay resp for n-no of data in a burst transfer
  	     //$display("RDATA=%0h",rdata);
  	     if(i==x-1)
	     intf.slv_dr.RLAST<=1'b1;
	     else
	     intf.slv_dr.RLAST<=1'b0;
  	    @(intf.slv_dr);
	    wait(intf.slv_dr.RREADY);
  	    @(intf.slv_dr); 
  	    intf.slv_dr.RLAST<=1'b0;
  	    intf.slv_dr.RVALID<=1'b0; 
	end
                   intf.slv_dr.RRESP<=1'b0;
endtask
      
 