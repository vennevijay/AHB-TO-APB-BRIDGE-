package ahb_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

        `include "slave_config.sv"
	`include "master_config.sv"
	`include "AHB_APB_config.sv"
	`include "apb_xtn.sv"
	`include "src_xtn.sv"
        `include "master_driver.sv"
        `include "master_monitor.sv"
        `include "master_sequencer.sv"
        `include "master_agent.sv"
        `include "master_agent_top.sv"

	`include "master_seqs.sv"
	`include "slave_sequencer.sv"
		`include "slave_monitor.sv"
		`include "slave_driver.sv"
		`include "slave_agent.sv"
	`include "AHB_APB_scoreboard.sv"
	
	`include "slave_agent_top.sv"
	`include "AHB_APB_tb.sv"
	`include "AHB_APB_vtest_lib.sv"
endpackage
