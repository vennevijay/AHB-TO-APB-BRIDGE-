class master_agent extends uvm_agent;
	`uvm_component_utils(master_agent)

	master_driver m_drvh;
	master_monitor m_monh;
	master_sequencer m_seqrh;
	master_config m_cfg;
	
	
	extern function new(string name="master_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

	
endclass


	function master_agent::new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction

	function void master_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(master_config)::get(this,"","master_config",m_cfg))
			`uvm_fatal("MASTER_CONFIG","in master agent not getting the config");
		m_monh=master_monitor::type_id::create("m_monh",this);
		if(m_cfg.is_active)
		m_drvh=master_driver::type_id::create("m_drvh",this);
		m_seqrh=master_sequencer::type_id::create("m_seqrh",this);
	
	endfunction


	function void master_agent::connect_phase(uvm_phase phase);	
		super.connect_phase(phase);
		if(m_cfg.is_active)		
		m_drvh.seq_item_port.connect(m_seqrh.seq_item_export);
	endfunction
