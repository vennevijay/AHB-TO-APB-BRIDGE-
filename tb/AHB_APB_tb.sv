class environment extends uvm_env;

	`uvm_component_utils(environment)

	master_agent_top magt_top;
	slave_agent_top sagt_top;
	scoreboard sb;
	extern function new(string name="environment", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);


endclass

function environment::new(string name="environment", uvm_component parent);	
	super.new(name,parent);
endfunction


function void environment::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	
	magt_top.magt_h.m_monh.ap_m.connect(sb.af_m.analysis_export);
	sagt_top.sagt_h.s_monh.ap_s.connect(sb.af_s.analysis_export);

endfunction

function void environment::build_phase(uvm_phase phase);
	super.build_phase(phase);
	magt_top=master_agent_top::type_id::create("magt_top",this);
	sagt_top=slave_agent_top::type_id::create("sagt_top",this);
	sb = scoreboard::type_id::create("sb",this);
endfunction


