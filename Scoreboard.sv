///////////////////////////////////////////////
//
// Scoreboard.v
//
///////////////////////////////////////////////

package pkg_arbiter_scoreboard;

import pkg_arbiter_transaction::*;
import pkg_arbiter_virtualArbiter::*;
import pkg_arbiter_types::*;


class Scoreboard;

	mailbox driver_mailbox, receiver_mailbox;
	int err_num;
	
	extern function new(mailbox driver_mailbox, mailbox receiver_mailbox);
	extern function bilan();
	extern virtual task start();
	
	Transaction transaction = new();		
	logic [NUMUNITS-1 : 0] grant_response;

	VirtualArbiter virtualArbiter = new();
	logic [NUMUNITS-1 : 0] virtualArbiterGrant;

	covergroup TransactionCoverGroup;
		roundORpriority : coverpoint transaction.payload_roundORpriority;                     
		request : coverpoint transaction.payload_request;
		//priorit : coverpoint transaction.payload_priority;
	endgroup

endclass

function Scoreboard::new(mailbox driver_mailbox, mailbox receiver_mailbox);
	this.driver_mailbox = driver_mailbox;
	this.receiver_mailbox = receiver_mailbox;
	this.err_num = 0;
	TransactionCoverGroup = new;
endfunction


task Scoreboard::start();
	forever begin
		
		logic [NUMUNITS-1 : 0] grant_response;

		//Since those calls are blocking, it should work without the need to add a 2 cycles wait for the receiver
		driver_mailbox.get(transaction);
		if($get_coverage() > 80)
		 	break;

		receiver_mailbox.get(grant_response);

		virtualArbiterGrant = virtualArbiter.getArbiterResponse(transaction);
		
		TransactionCoverGroup.sample();

		assert(virtualArbiterGrant==grant_response)
			$display("PASSED Treating request : %b, received %b, virtualGrant %b, mode (0 = rr) %b", transaction.payload_request, grant_response, virtualArbiterGrant, transaction.payload_roundORpriority);
        else begin
        	$display("ERROR Treating request : %b, received %b, virtualGrant %b, mode (0 = rr) %b", transaction.payload_request, grant_response, virtualArbiterGrant, transaction.payload_roundORpriority);
           
           err_num +=1;
        end
		
	end // forever
endtask

function Scoreboard::bilan();
  $display("Nombre d'erreurs : %d",err_num); 
endfunction

endpackage : pkg_arbiter_scoreboard


