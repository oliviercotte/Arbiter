package pkg_arbiter_virtualArbiter;

import pkg_arbiter_transaction::*;
import pkg_arbiter_types::*;

class VirtualArbiter;

	int roundRobinIndex = NUMUNITS-1; //This is only for initialization. This is because we want first shot to analyse device 0.

	function logic [NUMUNITS-1 : 0] getArbiterResponse(Transaction transaction);

		logic [ADDRESSWIDTH-1 : 0] min;
		int minPrioIndex = 0;
	
		//fixed prio
		//holds the priorities
		logic [ADDRESSWIDTH-1 : 0] prio [NUMUNITS-1 : 0];
		logic [ADDRESSWIDTH-1 : 0] tmp_prio;
		logic [ADDRESSWIDTH-1 : 0] selectPrio [NUMUNITS-1 : 0];

		//Initialize grant to 0
		logic [NUMUNITS-1 : 0] grant;

		for(int i = 0; i < NUMUNITS; i=i+1)
			grant[i]=0;

		//$display("VirtualArbiter : rrbit %b, received request %b", transaction.payload_roundORpriority, transaction.payload_request);

		//if payload_roundORpriority == 0, round robin
		if(!transaction.payload_roundORpriority) begin
			//round robin
			
			//On trouve la prochaine device a s'executer
			for(int i = 1; i < NUMUNITS-1 ; i=i+1) begin
				
				roundRobinIndex = (roundRobinIndex + 1) % NUMUNITS;
				//$display("rr idx : %d", roundRobinIndex);
				if (transaction.payload_request[roundRobinIndex] == 1) begin
					//$display("VirtualArbiter : found RR device %d", roundRobinIndex);
					break;
				end
			end

		grant[roundRobinIndex] = 1;
		
		end
		else begin
			// //On vectorise les priorites
			// for (int i=0; i<NUMUNITS; i=i+1) 
			// begin
			// 	for (int j=0; j<ADDRESSWIDTH; j=j+1)
			// 		tmp_prio[j] = transaction.payload_priorit[i*ADDRESSWIDTH + j];
			// 	prio[i] = tmp_prio;
			// end

			//Met aux maximum les prio des devices ne faisant pas de request			
			for(int i = 0; i < NUMUNITS; i=i+1)
				begin
					selectPrio[i] = transaction.payload_request[i] ? transaction.payload_priority[i] : NUMUNITS-1;
					//$display("transactionPrio[%d] : %d", i, transaction.payload_priority[i]);
					//$display("selectPrio[%d] : %d", i, selectPrio[i]);
				end

			// for(int i = 0; i < NUMUNITS; i=i+1)
			// 	$display("VirutalArbiter : prio %d = %b", i, selectPrio[i]);

			//Trouver la prio minimale
			min = selectPrio[0];
			for(int i = 0; i < NUMUNITS; i=i+1) 
			begin
			 	if(selectPrio[i] < min)
			 		min = selectPrio[i];
			end

			for(int i = 0; i < NUMUNITS; i=i+1)
				if(selectPrio[i] == min)
				begin
					minPrioIndex = i;
					break;
				end

			if(transaction.payload_request)
				grant[minPrioIndex] = 1;

			roundRobinIndex = minPrioIndex;

		end
		//$display("VirtualArbiter : returning grant %b", grant);
		return grant;

	endfunction

endclass


endpackage : pkg_arbiter_virtualArbiter