class master_config extends uvm_object;
	`uvm_object_utils(master_config)

	
	
	virtual AHB_APB_if m_if;

	uvm_active_passive_enum is_active=UVM_ACTIVE;

	extern function new(string name="master_config");
endclass

	function master_config::new(string name="master_config");
		super.new(name);
	endfunction


