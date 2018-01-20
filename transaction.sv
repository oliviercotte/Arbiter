///////////////////////////////////////////////
//
// Transaction.v
//
///////////////////////////////////////////////

package pkg_arbiter_transaction;

import pkg_arbiter_types::*;

class Transaction;

	rand logic payload_roundORpriority;                     
	rand logic [NUMUNITS-1:0] payload_request;            
	rand logic [ADDRESSWIDTH-1:0] payload_priority[NUMUNITS-1:0];
	int transactionID;

	//logic [(ADDRESSWIDTH*NUMUNITS)-1 : 0] payload_priorit;
	
	constraint Limit {
		payload_roundORpriority inside {[0:1]};
		payload_request inside {[0:255]};
		unique {payload_priority};
	}

	extern function new();
	
	function print();
		$display("--transaction %d--", transactionID );
		$display("fixed=1, roundrobin=0 : %b", payload_roundORpriority );
		$display("request : %b ", payload_request );
		
		//$display("DRIVER : mode is roundrobin (0) %b", transaction.payload_roundORpriority );
	endfunction

endclass

	function Transaction::new();
	endfunction

	// function Transaction::setPayloadPriority();
	// 	payload_priorit[2:0] 	= (priorit + 0) % NUMUNITS;
	// 	payload_priorit[5:3] 	= (priorit + 1) % NUMUNITS;
	// 	payload_priorit[8:6] 	= (priorit + 2) % NUMUNITS;
	// 	payload_priorit[11:9] 	= (priorit + 3) % NUMUNITS;
	// 	payload_priorit[14:12] 	= (priorit + 4) % NUMUNITS;
	// 	payload_priorit[17:15] 	= (priorit + 5) % NUMUNITS;
	// 	payload_priorit[20:18] 	= (priorit + 6) % NUMUNITS;
	// 	payload_priorit[23:21] 	= (priorit + 7) % NUMUNITS;
	// endfunction

endpackage : pkg_arbiter_transaction
