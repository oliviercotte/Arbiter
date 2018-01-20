
module TestBenchTOP;
	
	parameter clock_period = 200ns;

	// Signal d'horloge
	bit  clock;
	
	// Inteface d'arbitre qui servira à accéder au DUT
	if_to_arbiter bfm(clock);

	// Création du DUT et assignation de l'interface préalablement déclaré
	ArbiterTOP dut(bfm);
	
	// Instanciation du porgramme test qui pilote le comportement des interfaces
	TestProgram test(bfm);  
 	
	always begin : Clock_Generator
		#(clock_period/2) clock = ~clock;
	end

endmodule : TestBenchTOP