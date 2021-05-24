class Axi_scoreboard extends uvm_scoreboard;
// ----------------------------Factory Registration ------------------------------------------/
  `uvm_component_utils(Axi_scoreboard)
// fifos declaration
  
  uvm_tlm_analysis_fifo#(Axi_master_seq_item,Axi_scoreboard)  m_awddr_fifo;
  uvm_tlm_analysis_fifo #(Axi_master_seq_item,Axi_scoreboard) m_wdata_fifo;
  uvm_tlm_analysis_fifo #(Axi_master_seq_item,Axi_scoreboard) m_wresp_fifo;
  uvm_tlm_analysis_fifo #(Axi_master_seq_item,Axi_scoreboard) m_arddr_fifo;
  uvm_tlm_analysis_fifo #(Axi_master_seq_item,Axi_scoreboard) m_rdata_fifo;
  
  uvm_tlm_analysis_fifo #(Axi_slave_seq_item,Axi_scoreboard) s_awddr_fifo;
  uvm_tlm_analysis_fifo #(Axi_slave_seq_item,Axi_scoreboard) s_wdata_fifo;
  uvm_tlm_analysis_fifo #(Axi_slave_seq_item,Axi_scoreboard) s_wresp_fifo;
  uvm_tlm_analysis_fifo #(Axi_slave_seq_item,Axi_scoreboard) s_arddr_fifo;
  uvm_tlm_analysis_fifo #(Axi_slave_seq_item,Axi_scoreboard) s_rdata_fifo;  
// seq items handles
  Axi_master_seq_item m_xtn; 
  Axi_slave_seq_item s_xtn;
  extern function new(string name="Axi_scoreboard",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task check_info();
endclass: Axi_scoreboard
//--------------------------- constructor new method -------------------------/
function Axi_scoreboard::new(string name = "Axi_scoreboard", uvm_component parent);
super.new(name,parent);
   `uvm_info("Axi_scoreboard","object created",UVM_LOW);
    m_awddr_fifo = new("m_awddr_fifo",this);
    m_wdata_fifo = new("m_wdata_fifo",this);
    m_wresp_fifo = new("m_wresp_fifo",this);
    m_arddr_fifo = new("m_arddr_fifo",this);
    m_rdata_fifo = new("m_rdata_fifo",this);   
    s_awddr_fifo = new("s_awddr_fifo",this);
    s_wdata_fifo = new("s_wdata_fifo",this);
    s_wresp_fifo = new("s_wresp_fifo",this);
    s_arddr_fifo = new("s_arddr_fifo",this);
    s_rdata_fifo = new("s_rdata_fifo",this);
endfunction    
// ---------------------Build_phase Method ------------------------------//
function void Axi_scoreboard::build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction
//make the port connection in env
// ---------------------Run_phase Method ------------------------------//
task Axi_scoreboard::run_phase(uvm_phase phase);
forever
begin
    fork
    begin
      m_awddr_fifo.get(m_xtn);               
      m_wdata_fifo.get(m_xtn);
      m_wresp_fifo.get(m_xtn);
      m_arddr_fifo.get(m_xtn);
      m_rdata_fifo.get(m_xtn);
     `uvm_info("SCOREBOARD", " WRITE_CHANNEL_INFO from SCOREBOARD", UVM_LOW)
   end
   begin
       s_awddr_fifo.get(s_xtn);
       s_wdata_fifo.get(s_xtn);
       s_wresp_fifo.get(s_xtn);
       s_arddr_fifo.get(s_xtn);
       s_rdata_fifo.get(s_xtn);
       `uvm_info("SCOREBOARD", " READ_CHANNEL_INFO from SCOREBOARD", UVM_LOW)
     end
     join
        check_info();
     end		
endtask
//---------------------------check task------------------------------------
task Axi_scoreboard::check_info();
        if(m_xtn.AWADDR == s_xtn.AWADDR)//but in slave. we are not generating awaddr nor driving awaddr????????
        begin
              `uvm_info("CHECK_DATA_SB", $sformatf("MASTER & SLAVE AWADDR MATCHED %h=%h",m_xtn.AWADDR,s_xtn.AWADDR), UVM_LOW)
        end
        else
              `uvm_info("CHECK_DATA_SB", "MASTER & SLAVE AWADDR MIS-MATCHED ", UVM_LOW)
        if(m_xtn.AWBURST == s_xtn.AWBURST)
        begin
              `uvm_info("CHECK_DATA_SB", $sformatf("MASTER & SLAVE AWBURST MATCHED %h=%h",m_xtn.AWBURST,s_xtn.AWBURST), UVM_LOW)
        end
        else
             `uvm_info("CHECK_DATA_SB", "MASTER & SLAVE AWBURST MIS-MATCHED ", UVM_LOW)
        if(m_xtn.AWLEN == s_xtn.AWLEN)
        begin
             `uvm_info("CHECK_DATA_SB", $sformatf("MASTER & SLAVE AWLEN MATCHED %h=%h",m_xtn.AWLEN,s_xtn.AWLEN), UVM_LOW)
        end
        else
              `uvm_info("CHECK_DATA_SB", "MASTER & SLAVE AWLEN MIS-MATCHED ", UVM_LOW)
        if(m_xtn.AWSIZE == s_xtn.AWSIZE)
        begin
	`uvm_info("CHECK_DATA_SB", $sformatf("MASTER & SLAVE AWSIZE MATCHED %h=%h",m_xtn.AWSIZE,s_xtn.AWSIZE), UVM_LOW)
        end
        else
              `uvm_info("CHECK_DATA_SB", "MASTER & SLAVE AWSIZE MIS-MATCHED ", UVM_LOW)
        if(m_xtn.BID == s_xtn.BID)
        begin
              `uvm_info("CHECK_DATA_SB", $sformatf("MASTER & SLAVE BID MATCHED %h=%h",m_xtn.BID,s_xtn.BID),  UVM_LOW)
        end
        else
             `uvm_info("CHECK_DATA_SB", "MASTER & SLAVE BID MIS-MATCHED ", UVM_LOW)
        if(m_xtn.BRESP == s_xtn.BRESP)
        begin
             `uvm_info("CHECK_DATA_SB", "MASTER & SLAVE BRESP MATCHED ", UVM_LOW)
        end
        else
            `uvm_info("CHECK_DATA_SB", "MASTER & SLAVE BRESP MIS-MATCHED ", UVM_LOW)
        if(m_xtn.ARADDR == s_xtn.ARADDR)
        begin
              `uvm_info("CHECK_DATA_SB", $sformatf("MASTER & SLAVE ARADDR MATCHED %h=%h",m_xtn.ARADDR,s_xtn.ARADDR), UVM_LOW)
        end
        else
          `uvm_info("CHECK_DATA_SB", "MASTER & SLAVE ARADDR MIS-MATCHED ", UVM_LOW)
        if(m_xtn.ARBURST == s_xtn.ARBURST)
        begin
              `uvm_info("CHECK_DATA_SB", $sformatf("MASTER & SLAVE ARBURST MATCHED %h=%h",m_xtn.ARBURST,s_xtn.ARBURST), UVM_LOW)
        end
        else
            `uvm_info("CHECK_DATA_SB", "MASTER & SLAVE ARBURST MIS-MATCHED ", UVM_LOW)
       if(m_xtn.ARLEN == s_xtn.ARLEN)
       begin
            `uvm_info("CHECK_DATA_SB", $sformatf("MASTER & SLAVE ARLEN MATCHED %h=%h",m_xtn.ARLEN,s_xtn.ARLEN), UVM_LOW)
       end
       else
           `uvm_info("CHECK_DATA_SB", "MASTER & SLAVE ARLEN MIS-MATCHED ", UVM_LOW)
       if(m_xtn.ARSIZE == s_xtn.ARSIZE)
       begin
              `uvm_info("CHECK_DATA_SB", $sformatf("MASTER & SLAVE ARSIZE MATCHED %h=%h",m_xtn.ARSIZE,s_xtn.ARSIZE), UVM_LOW)
       end
       else
	`uvm_info("CHECK_DATA_SB", "MASTER & SLAVE ARSIZE MIS-MATCHED ", UVM_LOW)
      if(m_xtn.RID == s_xtn.RID)
      begin
              `uvm_info("CHECK_DATA_SB", $sformatf("MASTER & SLAVE RID MATCHED %h=%h",m_xtn.RID,s_xtn.RID), UVM_LOW)
      end
      else
              `uvm_info("CHECK_DATA_SB", "MASTER & SLAVE RID MIS-MATCHED ", UVM_LOW)
     if(m_xtn.RRESP == s_xtn.RRESP)
     begin
              `uvm_info("CHECK_DATA_SB", $sformatf("MASTER & SLAVE RRESP MATCHED %h=%h",m_xtn.RRESP,s_xtn.RRESP), UVM_LOW)
     end
     else
          `uvm_info("CHECK_DATA_SB", "MASTER & SLAVE RRESP MIS-MATCHED ", UVM_LOW)
endtask		  