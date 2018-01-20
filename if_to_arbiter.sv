

interface if_to_arbiter(input bit clock);
	import pkg_arbiter_types::*;

	parameter num_units  =   NUMUNITS;
  	parameter addr_wd   =   ADDRESSWIDTH; //number of bits needed to address NUMUNITS

	logic rst;                                 
	logic roundORpriority;                     
	logic [num_units-1 : 0] request;            
	logic [addr_wd*num_units-1 : 0] priorit;  
	logic [num_units-1 : 0] grant;

  	default clocking cb @(posedge clock);
		output roundORpriority;
     		output request;
     		output priorit;
		output rst;
     		input grant;
  	endclocking

	task reset_if();
  		@(cb) cb.rst <= 1'b0;
  		##5; cb.rst <= 1'b1;
	endtask : reset_if

	task write_request_if(input logic roudORpriority, input logic[num_units-1 : 0] request, input logic[addr_wd*num_units-1 : 0] priorit);
		cb.roundORpriority <=  roudORpriority; 
		cb.request <= request; 
		cb.priorit <= priorit;
	endtask : write_request_if

	task read_grant_if(output logic [NUMUNITS-1:0] grant );
		grant = cb.grant;
	endtask : read_grant_if

	task wait_clk(input integer cycles);
		##cycles;
	endtask : wait_clk
endinterface
