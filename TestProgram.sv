import pkg_arbiter_types::*;
import pkg_arbiter_driver::*;
import pkg_arbiter_receiver::*;
import pkg_arbiter_generator::*;
import pkg_arbiter_scoreboard::*;

program automatic TestProgram(if_to_arbiter bfm);
	parameter  	num_unit  =  NUMUNITS;
	parameter  	addr_wd   =  ADDRESSWIDTH;

	
	MiniDriver	drvr;
	MiniReceiver rcvr;
	Generator generator;
	Scoreboard scoreboard;

	mailbox generator_driver_mailbox, scorebard_driver_mailbox, scoreboard_receiver_mailbox;

	initial begin

			//1 slot in mailbox to prevent memory overflow
			generator_driver_mailbox = new(1024);
			scorebard_driver_mailbox = new(1024);
			scoreboard_receiver_mailbox = new(1);
      		drvr = new("drvr[0]", bfm, generator_driver_mailbox, scorebard_driver_mailbox);
      		rcvr = new("rcvr[0]", bfm, scoreboard_receiver_mailbox);
      		generator = new(generator_driver_mailbox);
  			scoreboard = new(scorebard_driver_mailbox, scoreboard_receiver_mailbox);
  			
      		reset();

		fork : test
      			drvr.start(); 
      			rcvr.start();
      			generator.start();
      			scoreboard.start();
		join_any;
		disable test;

		$display ($time, " [END] Test done.");
		scoreboard.bilan();
		
		$finish;
	end
		
	task reset();
 		$display ($time, " [RESET]  Design Reset Start");
		bfm.reset_if();
  		$display ($time, " [RESET]  Design Reset End");
	endtask

endprogram
