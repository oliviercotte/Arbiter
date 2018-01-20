///////////////////////////////////////////////
//
// Generator.v
//
///////////////////////////////////////////////

package pkg_arbiter_generator;

import pkg_arbiter_transaction::*;
import pkg_arbiter_types::*;

class Generator;

	mailbox driver_mailbox;

	extern function new(mailbox driver_mailbox);
	extern virtual task start();
	
	Transaction transaction;

endclass

	function Generator::new(mailbox driver_mailbox);
		this.driver_mailbox = driver_mailbox;
		this.transaction = new;
	endfunction

	task Generator::start();
		int packets_sent = 0;
		int numberOfOnes = 0;
		Transaction dummy = new;
		$display ($time, " Generator Started");
		forever 
		begin
			
			transaction.randomize();
			transaction.transactionID = packets_sent++;

			//$display ("Treating transaction %d", i);
			
			//nombre de 1 dans la requete :
			numberOfOnes = 0;
			for(int k = 0; k < NUMUNITS; k=k+1)
			begin
				if(transaction.payload_request[k] == 1)
					numberOfOnes = numberOfOnes + 1;
			end

			//On rejoue la requete le nombre de 1 de fois : c'est pour s'assurer qu'en RR, tous les demandeurs seront servis
			for(int j = 0; j < numberOfOnes; j=j+1)
			begin
				//transaction.print();
				driver_mailbox.put(transaction);
			end

			//Send ending transaction to the scoreboard
		
			// dummy.payload_request = 8'b11101010;
			// dummy.transactionID = 0;
			// foreach(dummy.payload_priority[i]) begin
			// 	dummy.payload_priority[i] = 2;
			// end
			// dummy.payload_roundORpriority = 1;

			// dummy.payload_priority[1] = 1;

			// driver_mailbox.put(dummy);


			// dummy.payload_request = 8'b01000000;
			// dummy.transactionID = 1;
			// foreach(dummy.payload_priority[i]) begin
			// 	dummy.payload_priority[i] = 2;
			// end
			// dummy.payload_roundORpriority = 1;

			// dummy.payload_priority[6] = 1;

			// driver_mailbox.put(dummy);

		end //forever
	endtask

endpackage : pkg_arbiter_generator