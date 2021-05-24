class Axi_master_seq_item extends uvm_sequence_item;
// ----------------------------Factory Registration ------------------------/
          `uvm_object_utils(Axi_master_seq_item) 
// transaction signals  
          rand bit [3:0]  AWID,   ARID;
          rand bit [31:0] AWADDR, ARADDR;
          rand bit [3:0]  AWSIZE, ARSIZE;
          rand bit [3:0]  AWLEN,  ARLEN;
          rand bit [1:0]  AWBURST,ARBURST;
          rand bit [3:0]  WSTRB;
          rand bit [31:0] WDATA[$];  
          bit [3:0]  BID, RID;
          bit [1:0]  BRESP,  RRESP;  
          bit [31:0]  RDATA[$];
          bit  WLAST,  RLAST;
//master signals
         bit AWVALID,ARVALID,WVALID,BREADY,RREADY;
//slave signals
        bit AWREADY,ARREADY,WREADY,BVALID,RVALID;
   
//**********constraints************* 
         //constraint c1	{AWSIZE inside {[0:2]};}
        //constraint c2{ARSIZE inside {[0:2]};}
       //constraint c3{AWLEN==3 ;}
      //constraint c4{ARLEN==3 ;}   
     //constraint c5{AWBURST==1;}
     constraint c6  {WDATA.size==AWLEN+1;}     
     constraint c7  {ARLEN==AWLEN;}
     constraint c8  {AWSIZE==2;}
     constraint c9  {ARSIZE==2;}
     constraint c10 {WSTRB==4'b1111;} 
     //constraint c11 {AWID == BID;} 
    //constraint c12 {ARID == RID;}
    constraint c13 {AWBURST != 2'b11;}
  
//internal signals for address calculations      
     int start_address;
     int number_bytes;
     int data_bus_bytes=4;
     int aligned_address;
     int burst_length;
     //int address_N;
     int wrap_boundary;
     int lower_byte_lane;
     int upper_byte_lane;
     int address_1;
     int address_[];
     int wrap_limit;
     extern function new (string name = "Axi_master_seq_item");//constructor 
     extern function void do_print(uvm_printer printer);//print fields
     extern function wr_adrs_calc();
     extern function rd_adrs_calc();
     extern function void post_randomize(); 
endclass:Axi_master_seq_item 
//----------------------constructor---------------------
function Axi_master_seq_item::new (string name = "Axi_master_seq_item");
super.new(name);
endfunction 
//--------------------address calculations---------------   
function Axi_master_seq_item::wr_adrs_calc();
     address_=new[AWLEN+1'b1];
     start_address=AWADDR;
     number_bytes=2**AWSIZE;
     burst_length=AWLEN+1'b1;
     aligned_address=(int'(start_address/number_bytes))*number_bytes;
//--------------------Fixed burst--------------- 
     if(AWBURST==2'b00)//fixed burst type
     for(int i=0; i<burst_length; i++)
     address_[i]=start_address; //1st address on so on
     //address_[i]=AWADDR;
//--------------------Increment burst-------------- 
     if(AWBURST==2'b01)//incremented burst type
     for(int i=0; i<burst_length; i++)
     address_[i] = aligned_address + (i * number_bytes);//1st address on so on but 
//--------------------Wrap burst---------------   
     if(AWBURST==2'b10)//wrap burst type
     begin
     start_address=aligned_address;
     wrap_boundary=(int'(start_address/(number_bytes*burst_length))) * (number_bytes*burst_length);
     wrap_limit = wrap_boundary+(number_bytes*burst_length);
     for(int i=0; i<burst_length; i++)
     begin
         address_[i] = aligned_address + (i * number_bytes);
         if(address_[i]==wrap_boundary+(number_bytes*burst_length))
          begin
              address_[i]=wrap_boundary;
          for(int j=i+1; j<burst_length; j++)
          begin
               address_[j]=start_address+((j)*number_bytes)-(number_bytes*burst_length);
              //address_[j]=aligned_address+((j-1)*number_bytes)-(number_bytes*burst_length);//in pdf, (n-1)*no.ofbytes?????????
           end
           break;
           end
           end
           end
endfunction:wr_adrs_calc
//-------------------read calculation----------------------------
/*function Axi_master_seq_item::rd_adrs_calc();
           address_=new[ARLEN+1'b1];
           start_address=ARADDR;
           number_bytes=2**ARSIZE;
           burst_length=ARLEN+1'b1;
           aligned_address=(int'(start_address/number_bytes))*number_bytes;
//--------------------Fixed burst--------------- 
          if(ARBURST==2'b00)//fixed burst type
         for(int i=0; i<burst_length; i++)
         address_[i]=start_address; //1st address on so on
        //address_[i]=ARADDR;
//--------------------Increment burst--------------- 
        if(AWBURST==2'b01)//incremented burst type
        for(int i=0; i<burst_length; i++)
        address_[i] = aligned_address + (i * number_bytes);//1st address on so on but FOR INCR STARTING ADRS NEED TO BE ALIGNED?? 
//--------------------Wrap burst--------------- 
         if(AWBURST==2'b10)//wrap burst type
         begin
           start_address=aligned_address;
           wrap_boundary=(int'(start_address/(number_bytes*burst_length))) * (number_bytes*burst_length);
           wrap_limit = wrap_boundary+(number_bytes*burst_length);
         for(int i=0; i<burst_length; i++)
         begin
           address_[i] = aligned_address + (i * number_bytes);
         if(address_[i]==wrap_boundary+(number_bytes*burst_length))
         begin
           address_[i]=wrap_boundary;
         for(int j=i+1; j<burst_length; j++)
         begin
            address_[j]=start_address+((j-1)*number_bytes)-(number_bytes*burst_length);//in pdf, (n-1)*no.ofbytes?????????
            //address_[j]=aligned_address+((j-1)*number_bytes)-(number_bytes*burst_length);//in pdf, (n-1)*no.ofbytes?????????
          end
          break;
          end
          end
          end
endfunction:rd_adrs_calc*/
//------------------------post randomization--------------    
function void Axi_master_seq_item::post_randomize();
         wr_adrs_calc();
         //rd_adrs_calc();
endfunction
//------------------------------ print method-----------------------------------
function void Axi_master_seq_item::do_print(uvm_printer printer);
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
  	foreach(address_[i])
  	printer.print_field($sformatf("address_[%0d]",i), this.address_[i], 32, UVM_HEX);//print internal address
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