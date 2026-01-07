class slave_driver extends uvm_driver #(apb_xtn);
	`uvm_component_utils(slave_driver)
	
	virtual AHB_APB_if s_if;	

	slave_config s_cfg;
	extern function new(string name="slave_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task drive();


endclass


	function slave_driver::new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction

	function void slave_driver::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(slave_config)::get(this,"","slave_config",s_cfg))
			`uvm_fatal("[SLAVE_DRIVER]","can't get the slave_config in slave_driver")

	endfunction


	function void slave_driver::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		s_if = s_cfg.s_if;
	endfunction


	task slave_driver::run_phase(uvm_phase phase);
		super.run_phase(phase);
	
		forever
			begin
				drive();
			end
	
	endtask

	
	task slave_driver::drive();
		
					
		while(s_if.s_drv.Psel===0)
			@(s_if.s_drv);
		
	
		while(s_if.s_drv.Penable===0)
			@(s_if.s_drv);

   if(s_if.s_drv.Pwrite==0)
     begin
	repeat(2)  
           begin
	
		s_if.s_drv.Prdata <= $urandom;

		end
    end
  
  else
       s_if.s_drv.Prdata <= 0;

		repeat(2)
			@(s_if.s_drv);
			

	endtask

