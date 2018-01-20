///////////////////////////////////////////////
//
// Receiver.v
//
///////////////////////////////////////////////

package pkg_arbiter_receiver;

import pkg_arbiter_types::*;

class MiniReceiver;

	virtual if_to_arbiter bfm;	// interface signal   // 
 	string    name;				// unique identifier

	logic [NUMUNITS-1 : 0] grant_response;

	mailbox scoreboard_mailbox;

	extern function new(string name = "Receiver", virtual if_to_arbiter bfm, mailbox scoreboard_mailbox);
  	extern virtual task start();

endclass

function MiniReceiver::new(string name = "Receiver", virtual if_to_arbiter bfm, mailbox scoreboard_mailbox);
	this.scoreboard_mailbox = scoreboard_mailbox;
	this.name = name;
	this.bfm = bfm;
endfunction

task MiniReceiver::start();
	
	//Wait one cycle for sending the data, plus one cycle for the data to be ready
	bfm.wait_clk(2);
	
	forever begin
	
	bfm.read_grant_if(grant_response);
	scoreboard_mailbox.put(grant_response);
	//$display (" [RECEIVER]  Attribution du bus obtenu %b", grant_response );
	
	bfm.wait_clk(1);

	end //forever
	
endtask

endpackage : pkg_arbiter_receiver
