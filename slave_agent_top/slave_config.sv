class slave_config extends uvm_object;
	`uvm_object_utils(slave_config)

	
	
	virtual AHB_APB_if s_if;

	uvm_active_passive_enum is_active=UVM_ACTIVE;

	extern function new(string name="slave_config");
endclass

	function slave_config::new(string name="slave_config");
		super.new(name);
	endfunction


