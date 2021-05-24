//slave sequence item class
class Axi_slave_seq_item extends uvm_sequence_item;
//----------------------------Factory Registration ------------------------/
  	`uvm_object_utils(Axi_slave_seq_item) 
  	//instance of master seq item
  	Axi_master_seq_item seq_item; 
  	// transaction signals
  	rand bit [31:0]RDATA[$]; 
	bit [3:0]RID,BID; 
  	bit [31:0]AWADDR, ARADDR;
    	bit [3:0] AWID, ARID;
   	bit [3:0] AWSIZE, ARSIZE;	
  	bit [3:0] AWLEN, ARLEN;	
	bit [1:0] AWBURST,ARBURST;
  	bit [3:0] WSTRB; 
  	bit [31:0]WDATA[$];
	bit [1:0] BRESP,RRESP;
	bit       RLAST,WLAST;
 
  	//master signals
	bit AWVALID,ARVALID,WVALID,BREADY,RREADY;
  	//slave signals
	bit AWREADY,ARREADY,WREADY,BVALID,RVALID;
	int x,i;

	virtual AXI_if  intf;  
   
   	extern function new (string name="Axi_slave_seq_item");
	extern function void do_print(uvm_printer printer);

endclass:Axi_slave_seq_item
//***********************************************************************************
//---------------constructor--------------------
function Axi_slave_seq_item::new (string name="Axi_slave_seq_item");
super.new(name);
endfunction 
//------------------print-----------------------    
function void Axi_slave_seq_item::do_print(uvm_printer printer);
super.do_print(printer);
  	printer.print_field("AWID",   this.AWID,    4, UVM_HEX);
  	printer.print_field("AWADDR", this.AWADDR, 32, UVM_HEX);
  	printer.print_field("AWLEN",  this.AWLEN,  4, UVM_HEX);
	printer.print_field("AWSIZE", this.AWSIZE, 3, UVM_HEX);
	printer.print_field("AWBURST", this.AWBURST, 2, UVM_HEX);
  	foreach(WSTRB[i])
               printer.print_field($sformatf("WSTRB[%0d]",i), this.WSTRB[i], 4, UVM_HEX);
	foreach(WDATA[i])
               printer.print_field($sformatf("WDATA[%0d]",i), this.WDATA[i], 32, UVM_HEX);
  	printer.print_field("ARID", this.ARID, 4, UVM_HEX);
	printer.print_field("ARADDR", this.ARADDR, 32, UVM_HEX);
	printer.print_field("ARLEN", this.ARLEN, 4, UVM_HEX);
	printer.print_field("ARSIZE", this.ARSIZE, 3, UVM_HEX);
	printer.print_field("ARBURST", this.ARBURST, 2, UVM_HEX);
  	printer.print_field("RID", this.RID, 4, UVM_HEX);
	foreach(RDATA[i])
               printer.print_field($sformatf("RDATA[%0d]",i), this.RDATA[i], 32, UVM_HEX);
	printer.print_field("RRESP", this.RRESP, 2, UVM_HEX);
endfunction:do_print
 
      
  
  


 
  