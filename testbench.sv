// Code your testbench here
`include "package.sv"
// interface

//*********************INTERFACE*************
interface AXI_if(input bit ACLK, RESETn);
//*************write_address_and_control_channel_signals
//logic RESETn;
logic [3:0]  AWID;
logic [31:0] AWADDR;
logic [3:0]  AWLEN;
logic [3:0]  AWSIZE;
logic [1:0]  AWBURST;
logic AWVALID;
logic AWREADY;
//****************************write_data_channel_signals
//logic [3:0]  WID;// not there for AXI4
logic [31:0] WDATA;
logic [3:0] WSTRB;
logic WLAST;
logic WVALID;
logic WREADY;
//******************************write_response_channel
logic [3:0] BID;
logic [1:0] BRESP;
logic BVALID;
logic BREADY;
//**************************read_address_and_control_channel_signals
logic [3:0] ARID;
logic [31:0] ARADDR;
logic [3:0] ARLEN;
logic [3:0] ARSIZE;
logic [1:0] ARBURST;
logic ARVALID;
logic ARREADY;
//**************************read_data_and_response_channel_signas
logic [3:0] RID;
logic [31:0] RDATA;
logic [1:0]RRESP;
logic RLAST;
logic RVALID;
logic RREADY;
//***********************master driver clocking block  
clocking mstr_dr @ (posedge ACLK);
 default input #1 output #1;
//output RESETn;
output AWID;
output AWADDR;
output AWLEN;
output AWSIZE;
output AWBURST;
output AWVALID;  
input AWREADY;
 
  
output WDATA;
output WSTRB;
output WLAST;
output WVALID;    
input WREADY;
  
input BID;
input BRESP;
input BVALID;  
output BREADY;
  
output ARID;
output ARADDR;
output ARLEN;
output ARSIZE;
output ARBURST;
output ARVALID;
input ARREADY;
  
input RID;
input RDATA;
input RRESP;
input RLAST;
input RVALID;  
output RREADY;
 
endclocking
//***********************slave driver clocking block  
clocking slv_dr @ (posedge ACLK);
 default input #1 output #1;
//output RESETn;
input AWID;
input AWADDR;
input AWLEN;
input AWSIZE;
input AWBURST;
input AWVALID;  
output AWREADY;
  

input WDATA;
input WSTRB;
input WLAST;
input WVALID;    
output WREADY;
  
output BID;
output BRESP;
output BVALID;
input BREADY;  
 
input ARID;
input ARADDR;
input ARLEN;
input ARSIZE;
input ARBURST;
input ARVALID;  
output ARREADY;
  
output RID;  
output RDATA;
output RRESP;
output RLAST;
output RVALID;
input RREADY;
  
endclocking
//***********************master monitor clocking block    
clocking mstr_mon @(posedge ACLK);
default input #1 output #1;
//input RESETn;
input AWID;
input AWADDR;
input AWLEN;
input AWSIZE;
input AWBURST;
input AWVALID;
input AWREADY;

input WDATA;
input WSTRB;
input WLAST;
input WVALID;
input WREADY;
  
input BID;
input BRESP;
input BVALID;
input BREADY;
  
input ARID;
input ARADDR;
input ARLEN;
input ARSIZE;
input ARBURST;
input ARVALID;
input ARREADY;
  
input RID;  
input RDATA;
input RRESP;
input RLAST;
input RVALID;
input RREADY;

endclocking
  
//***********************slave monitor clocking block    
clocking slv_mon @(posedge ACLK);
default input #1 output #1;
//input RESETn;
input AWID;
input AWADDR;
input AWLEN;
input AWSIZE;
input AWBURST;
input AWVALID;
input AWREADY;

  
input WDATA;
input WSTRB;
input WLAST;
input WVALID;
input WREADY;
  
input BID;
input BRESP;
input BVALID;
input BREADY;
  
input ARID;
input ARADDR;
input ARLEN;
input ARSIZE;
input ARBURST;
input ARVALID;
input ARREADY;
  
input RID;  
input RDATA;
input RRESP;
input RLAST;
input RVALID;
input RREADY;

endclocking
//***********************modport**********************
  modport mas_dr (clocking mstr_dr);

  modport sla_dr (clocking slv_dr);

  modport mas_mon (clocking mstr_mon);

  modport sla_mon (clocking slv_mon);
endinterface
//******************************************************************************************************
//top module
//******************************************************************************************************

module top ();
	bit ACLK;
  	bit RESETn;
    // interface instantiation   
    AXI_if mas_slav_if(ACLK, RESETn);
	
	// clock generation  
	always
	# 5 ACLK = ~ACLK;  
  
 	// reset generation and set interface handle in config db and get in below hierarchy
 	initial
 	  begin  
        RESETn= 0;
        //make all the input signal to dut as default value
        //ARVALID, AWVALID, and WVALID LOW
        //RVALID and BVALID LOW
        repeat(2) RESETn = 1;
         uvm_config_db # (virtual AXI_if) :: set (null,"*","vms_if",mas_slav_if);
         run_test("Axi_test");		// Call run_test
 	end
  	//generate waveform
 	initial
 	 begin
      $dumpfile("Axi_master_slave.vcd");
 	  $dumpvars();
 	 end
  	//end of simulation (and 1000 delay also added in test.sv before "phase.drop_objection(this);")
 	initial  
	#1000 $finish;
endmodule 

