module top;
	import ahb_pkg::*;

	import uvm_pkg::*;


	`include "uvm_macros.svh" 
	
	bit clk;
	always
		begin
		//	#0 clk = 1'b0;
			#5 clk = ~clk;
		end


	
	


	AHB_APB_if m_if(clk);
	AHB_APB_if s_if(clk);

	rtl_top DUV(.Hclk(clk), .Hresetn(m_if.Hrstn), .Htrans(m_if.Htrans), .Hsize(m_if.Hsize), .Hreadyin(m_if.Hreadyin), .Hwdata(m_if.Hwdata), .Haddr(m_if.Haddr), .Hwrite(m_if.Hwrite), .Prdata(s_if.Prdata), .Hrdata(m_if.Hrdata), .Hresp(m_if.Hresp), .Hreadyout(m_if.Hreadyout), .Pselx(s_if.Psel), .Pwrite(s_if.Pwrite), .Penable(s_if.Penable), .Paddr(s_if.Paddr), .Pwdata(s_if.Pwdata));


	initial begin
			`ifdef VCS                      //for waveform
         		$fsdbDumpvars(0, top);
        		`endif

		uvm_config_db #(virtual AHB_APB_if)::set(null,"*","master_if",m_if);
	
		uvm_config_db #(virtual AHB_APB_if)::set(null,"*","slave_if",s_if);

		run_test();
	end

endmodule


