
package pkg_arbiter_driver;

import pkg_arbiter_types::*;
import pkg_arbiter_transaction::*;

class MiniDriver;

	virtual if_to_arbiter bfm;	// interface signal   // 
 	string    name;		// unique identifier

	mailbox generator_mailbox, scoreboard_mailbox;

	extern function new(string name = "Driver", virtual if_to_arbiter bfm, mailbox generator_mailbox, mailbox scoreboard_mailbox);
  	extern virtual task start();

endclass

function MiniDriver::new(string name = "Driver", virtual if_to_arbiter bfm, mailbox generator_mailbox, mailbox scoreboard_mailbox);
	this.name = name;
	this.bfm = bfm;
	this.generator_mailbox = generator_mailbox;
	this.scoreboard_mailbox = scoreboard_mailbox;
endfunction

task MiniDriver::start();
	int get_flag = 10; 
	logic [(ADDRESSWIDTH*NUMUNITS)-1 : 0] priority_vector;

	$display ($time, " Driver Started");
	forever begin
		Transaction transaction = new;

		generator_mailbox.get(transaction);
		scoreboard_mailbox.put(transaction);

		//zero-out priority vector
		for(int i = 0; i < ADDRESSWIDTH*NUMUNITS ; i=i+1)
			priority_vector[i] = 0;

		foreach(transaction.payload_priority[i]) 
		begin
			priority_vector = priority_vector | transaction.payload_priority[i] << i*3;
		end
		
		//$display("DRIVER: sending transaction : ");
		//transaction.print();
		// $display("DRIVER : received priority vector %b", priority_vector );
		// $display("DRIVER : received request %b", transaction.payload_request );
		// $display("DRIVER : mode is roundrobin (0) %b", transaction.payload_roundORpriority );

		bfm.write_request_if(transaction.payload_roundORpriority, transaction.payload_request, priority_vector);
		//bfm.write_request_if(transaction., transaction.payload_request, priority_vector);
			   
		bfm.wait_clk(1); // On attend deux cycle afin de palier au delai du pipeline de l'arbitre. Ceci gaspille un cycle parcontre...

		//$display ($time, " [DRIVER] Requete effectue %b",transaction.payload_request );	
	end //forever

endtask

endpackage : pkg_arbiter_driver
