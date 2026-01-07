class master_driver extends uvm_driver#(src_xtn);
	`uvm_component_utils(master_driver)
	
	virtual AHB_APB_if.M_DRV  m_if;
	
	master_config m_cfg;	

	extern function new(string name="master_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task drive(src_xtn xtn);


endclass


	function master_driver::new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction

	function void master_driver::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(master_config)::get(this,"","master_config",m_cfg))
			`uvm_fatal("[MASTER_DRIVER]","can't get the master_config in master_driver")
	
	//	$display("m_driver config get",m_cfg.m_if);
	endfunction

	function void master_driver::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		m_if = m_cfg.m_if;
			
	//	$display("--------------------hresp signal-----",m_if.m_drv.Hrdata);

	endfunction

	task master_driver::run_phase(uvm_phase phase);
		super.run_phase(phase);
		@(m_if.m_drv);
		
		m_if.m_drv.Hrstn <= 0;
		@(m_if.m_drv);
		m_if.m_drv.Hrstn <= 1;
		@(m_if.m_drv);
		
	forever begin	
		seq_item_port.get_next_item(req);

		drive(req);
	
		seq_item_port.item_done();
		end
	endtask


	task master_driver::drive(src_xtn xtn);
		
		while(m_if.m_drv.Hreadyout!==1)
			@(m_if.m_drv);

		m_if.m_drv.Htrans <= xtn.Htrans;
		m_if.m_drv.Haddr <= xtn.Haddr;
		m_if.m_drv.Hsize <= xtn.Hsize;
		m_if.m_drv.Hburst <= xtn.Hburst;
		m_if.m_drv.Hwrite <= xtn.Hwrite;
		m_if.m_drv.Hreadyin<=1'b1;

		@(m_if.m_drv);

		while(m_if.m_drv.Hreadyout!==1)
			@(m_if.m_drv);
			
	//	if(m_if.m_drv.Hwrite)
		if(xtn.Hwrite)
			m_if.m_drv.Hwdata<=xtn.Hwdata;
			else
			m_if.m_drv.Hwdata<=0;
			`uvm_info("MASTER_DRIVER",$sformatf("printing from master driver \n %s",xtn.sprint()),UVM_LOW)
	endtask
				

	


	
