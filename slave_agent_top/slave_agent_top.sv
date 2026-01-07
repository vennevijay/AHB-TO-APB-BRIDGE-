class slave_agent_top extends uvm_env;
	`uvm_component_utils(slave_agent_top)

	slave_agent sagt_h;
	slave_config s_cfg;
	extern function new(string name="slave_agent_top", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	
endclass

	function slave_agent_top::new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction


	function void slave_agent_top::build_phase(uvm_phase phase);
		super.build_phase(phase);
		sagt_h=slave_agent::type_id::create("sagt_h",this);

		uvm_config_db #(slave_config)::set(this,"*","slave_config",s_cfg);

	endfunction

