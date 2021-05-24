`ifndef axi__PKG
`define axi__PKG
package Axi_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "config_slave.sv"
`include "config_master.sv"
`include "master_sequence_item.sv"
`include "slave_sequence_item.sv"
`include "master_sequence.sv"
`include "slave_sequence.sv"
`include "master_sequencer.sv"
`include "slave_sequencer.sv"
`include "master_driver.sv"
`include "slave_driver.sv"
`include "master_monitor.sv"
`include "slave_monitor.sv"
`include "master_agent.sv"
`include "slave_agent.sv"
`include "env_config.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "test.sv"
endpackage
`endif