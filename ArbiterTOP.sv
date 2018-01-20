


module ArbiterTOP(if_to_arbiter bfm);

 arbiter arb( // make an instance
    .clk(bfm.clock), 
    .rst(bfm.rst), 
    .roundORpriority(bfm.roundORpriority), 
    .request(bfm.request), 
    .priorit(bfm.priorit), 
    .grant(bfm.grant)
    );

endmodule : ArbiterTOP