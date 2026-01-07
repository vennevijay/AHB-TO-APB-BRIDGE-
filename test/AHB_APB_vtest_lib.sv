class test extends uvm_test;

	//`uvm_component_utils(test)
	`uvm_component_utils(test)

	environment env_h;

	master_config m_cfg;
	slave_config s_cfg;


	int has_slave_agent=1;
	int has_master_agent=1;
	
	int no_of_masters=1;
	int no_of_slaves=1;

	

	extern function new(string name="test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);



	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology;
	endfunction



endclass


	function test::new(string name="test", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void test::build_phase(uvm_phase phase);
		super.build_phase(phase);
		env_h=environment::type_id::create("env_h",this);
		
		if(has_master_agent)
		 begin
			m_cfg=master_config::type_id::create("m_cfg");
			m_cfg.is_active=UVM_ACTIVE;
			if(!uvm_config_db #(virtual AHB_APB_if)::get(this,"","master_if",m_cfg.m_if))
				`uvm_fatal("[CONFIG_MASTER_IF]","cannot getting the m_if into the master_config")

		$display("test config get",m_cfg.m_if);

			//m_cfg = m_cfg;
			uvm_config_db #(master_config)::set(this,"*","master_config",m_cfg);
		end

		if(has_slave_agent) 
		begin
			s_cfg=slave_config::type_id::create("s_cfg");
			s_cfg.is_active=UVM_ACTIVE;
			if(!uvm_config_db #(virtual AHB_APB_if)::get(this,"","slave_if",s_cfg.s_if))
				`uvm_fatal("[CONFIG_SLAVE_IF]","cannot getting the m_if into the slave_config")
			uvm_config_db #(slave_config)::set(this,"*","slave_config",s_cfg);

		end

		
	endfunction


class single_transfer_test extends test;
	`uvm_component_utils(single_transfer_test);

	single_transfer s_t;


	function new(string name="single_transfer_test", uvm_component parent);
		super.new(name, parent);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		s_t=single_transfer::type_id::create("s_t");
		s_t.start(env_h.magt_top.magt_h.m_seqrh);
		#60;
		phase.drop_objection(this);
	endtask
endclass







class incr_transfer_test extends test;
	`uvm_component_utils(incr_transfer_test);

	incr_transfer incr_t;


	function new(string name="incr_transfer_test", uvm_component parent);
		super.new(name, parent);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		incr_t=incr_transfer::type_id::create("incr_t");
		incr_t.start(env_h.magt_top.magt_h.m_seqrh);
		#200;
		phase.drop_objection(this);
	endtask
endclass





class wrap_transfer_test extends test;
	`uvm_component_utils(wrap_transfer_test);

	wrap_transfer wrap_h;


	function new(string name="wrap_transfer_test", uvm_component parent);
		super.new(name, parent);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		wrap_h=wrap_transfer::type_id::create("wrap_h");
		wrap_h.start(env_h.magt_top.magt_h.m_seqrh);
		#100;
		phase.drop_objection(this);
	endtask
endclass

