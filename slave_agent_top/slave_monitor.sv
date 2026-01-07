class slave_monitor extends uvm_monitor;
	`uvm_component_utils(slave_monitor)

	uvm_analysis_port #(apb_xtn) ap_s;

	virtual AHB_APB_if s_if;
	apb_xtn xtn_h;
	slave_config s_cfg;

	extern function new(string name="slave_monitor", uvm_component parent);	
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
			


endclass


	function slave_monitor::new(string name,uvm_component parent);
		super.new(name,parent);	
		ap_s = new("apb_xtn",this);
	endfunction

	function void slave_monitor::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(slave_config)::get(this,"","slave_config",s_cfg))
			`uvm_fatal("[SLAVE_MONITOR]","can't get the slave_config in slave_monitor")

	endfunction

	function void slave_monitor::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		s_if = s_cfg.s_if;
	endfunction


	task slave_monitor::run_phase(uvm_phase phase);
		super.run_phase(phase);
		@(s_if.s_mon);
		forever 
			begin	
				collect_data();
			//	`uvm_info("SLAVE MONITOR",$sformatf("printing from slave monitor \n %s",xtn_h.sprint()),UVM_LOW);

				ap_s.write(xtn_h);

			end

	endtask


		
	task slave_monitor::collect_data();
		
		xtn_h = apb_xtn::type_id::create("xtn_h");
			@(s_if.s_mon);

		while(s_if.s_mon.Penable===0)
			@(s_if.s_mon);
		
		while(s_if.s_drv.Psel===0)
		@(s_if.s_drv);

		xtn_h.Paddr = s_if.s_mon.Paddr;
		xtn_h.Pwrite = s_if.s_mon.Pwrite;
		xtn_h.Psel = s_if.s_mon.Psel;
		xtn_h.Penable = s_if.s_mon.Penable;

	

		if(s_if.s_mon.Pwrite)begin
			xtn_h.Pwdata = s_if.s_mon.Pwdata;
			$display("====================xtn_h.pwdata============================",s_if.s_mon.Pwdata);
				end	
		else 
			xtn_h.Prdata = s_if.s_mon.Prdata;


	//	repeat(2)
			@(s_if.s_mon);
			
		
	endtask

		
