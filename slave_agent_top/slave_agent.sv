class slave_agent extends uvm_agent;
	`uvm_component_utils(slave_agent)


	slave_driver s_drvh;
	slave_monitor s_monh;
	slave_sequencer s_seqrh;
	slave_config s_cfg;
	extern function new(string name="slave_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

	
endclass


	function slave_agent::new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction

	function void slave_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(slave_config)::get(this,"","slave_config",s_cfg))
			`uvm_fatal("SLAVE_CONFIG","in slave agent not getting the config");
			
		s_monh=slave_monitor::type_id::create("s_monh",this);
		
		s_drvh=slave_driver::type_id::create("s_drvh",this);
		s_seqrh=slave_sequencer::type_id::create("s_seqrh",this);
	endfunction

	function void slave_agent::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	
		s_drvh.seq_item_port.connect(s_seqrh.seq_item_export);
	endfunction


