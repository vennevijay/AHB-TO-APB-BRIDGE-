class master_agent_top extends uvm_env;
	`uvm_component_utils(master_agent_top)
	
	master_agent magt_h;
	master_config m_cfg;

	extern function new(string name="master_agent_top", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	
endclass

	function master_agent_top::new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction


	function void master_agent_top::build_phase(uvm_phase phase);
		super.build_phase(phase);
		magt_h=master_agent::type_id::create("magt_h",this);
		m_cfg=master_config::type_id::create("m_cfg");

		//	if(!uvm_config_db #(virtual master_if)::get(this,"","master_if",m_cfg.m_if))

		//	`uvm_fatal("agt","sdfghjkl")
		
		uvm_config_db #(master_config)::set(this,"*","master_config",m_cfg);
	endfunction


