class master_monitor extends uvm_monitor;
	`uvm_component_utils(master_monitor)
	
	uvm_analysis_port #(src_xtn) ap_m;
	
	master_config m_cfg;
	virtual AHB_APB_if.M_MON m_if;
	src_xtn xtn;


	extern function new(string name="master_monitor", uvm_component parent);	
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();


endclass


	function master_monitor::new(string name, uvm_component parent);
		super.new(name,parent);	
	endfunction


	function void master_monitor::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(master_config)::get(this,"","master_config",m_cfg))
			`uvm_fatal("[MASTER_DRIVER]","can't get the master_config in master_driver")
		ap_m = new("src_xtn",this);


	endfunction

	function void master_monitor::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		m_if = m_cfg.m_if;
	endfunction

	
	task master_monitor::run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever
			begin
			collect_data();	

				ap_m.write(xtn);
				
			end
	endtask

	task master_monitor::collect_data();
		xtn=src_xtn::type_id::create("xtn");
	//	@(m_if.m_mon);
		while(m_if.m_mon.Hreadyout!==1)
			@(m_if.m_mon);
		while((m_if.m_mon.Htrans!==2'b10) && (m_if.m_mon.Htrans!==2'b11))
			@(m_if.m_mon);


	//	wait(m_if.m_mon.Htrans===2 || m_if.m_mon.Htrans===3)begin


		xtn.Haddr=m_if.m_mon.Haddr;
		xtn.Hresetn=m_if.m_mon.Hrstn;
		xtn.Hwrite=m_if.m_mon.Hwrite;
		xtn.Htrans=m_if.m_mon.Htrans;
		xtn.Hsize=m_if.m_mon.Hsize;
		xtn.Hburst=m_if.m_mon.Hburst;
		xtn.Hresp=m_if.m_mon.Hresp;
		
	
		@(m_if.m_mon);

		while(m_if.m_mon.Hreadyout!==1)
			@(m_if.m_mon);
		while((m_if.m_mon.Htrans!==2'b10) && (m_if.m_mon.Htrans!==2'b11))
			@(m_if.m_mon);

		
//	while(m_if.m_mon.Hreadyout && (m_if.m_mon.Htrans!==2'b10) && (m_if.m_mon.Htrans!==2'b11))
//			@(m_if.m_mon);
		
		if(m_if.m_mon.Hwrite)
			xtn.Hwdata=m_if.m_mon.Hwdata;
		
		else
			xtn.Hrdata=m_if.m_mon.Hrdata;
		
				`uvm_info("MASTER_MONITOR",$sformatf("printing from master monitor \n %s",xtn.sprint()),UVM_LOW)
	
	endtask
