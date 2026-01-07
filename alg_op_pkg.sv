`timescale 1ns / 1ps
package alg_op_pkg; 

parameter N = 128;
parameter K = 116;
parameter T = (N-K)/2;
parameter DATA_WIDTH = 128; 

parameter PREST = 10;  // GF(2^4)
parameter PRESTx2 = 2*PREST;

parameter PRIM_POL = 11'b1_0000001001; //X^10+x^3+1

function logic [PRESTx2-1:0] PMULT( logic[PREST-1:0] d0, logic[PREST-1:0] d1 );
	logic [PRESTx2-1:0] res;	res = 0;
	for(int x=0; x<PREST; x++) 
		if (d1[x]) res = res ^ (d0 << x);
	PMULT = res;	
endfunction

function logic [PRESTx2-1:0][PREST-1:0] LOCSCRC (logic [PRESTx2-1:0] d, logic[PREST-1:0] c);
	logic [PREST-1:0] cint;
	logic last_bit;
	logic [PRESTx2-1:0][PREST-1:0] cint_;
	cint = c;

	for(int dstep=PRESTx2-1; dstep>=0; dstep--) begin
		last_bit = cint[PREST-1];
		for(int rstep=PREST-1; rstep>0; rstep--) cint[rstep]= (PRIM_POL[rstep]) ? cint[rstep-1] ^ d[dstep] ^ last_bit : cint[rstep-1];
		cint[0] = d[dstep] ^ last_bit;
		cint_[PRESTx2-1-dstep] = cint;
	end

	LOCSCRC = cint_;
endfunction

function logic [PREST-1:0][PREST-1:0] REVCRC (logic[PREST-1:0] c);
	logic [PREST-1:0] cint;
	logic [PREST-1:0][PREST-1:0] cint_;
	logic last_bit;
	cint = c;

	for (int dstep=0; dstep<PREST; dstep++) begin
		last_bit = cint[0];
		for(int rstep=0; rstep<PREST-1; rstep++)
			cint[rstep] = (PRIM_POL[rstep+1]) ? cint[rstep+1] ^ last_bit : cint[rstep+1];
		cint[PREST-1] = last_bit;
		cint_[dstep] = cint;
	end

	REVCRC = cint_;
endfunction

function logic [PREST-1:0] PDIV ( logic [PRESTx2-1:0] d );
	logic [PRESTx2-1:0][PREST-1:0] crc30;
	logic [PREST-1:0][PREST-1:0] crc40;

	 	crc30 = LOCSCRC(d,0);
	 	crc40 = REVCRC(crc30[PRESTx2-1]);
	 	PDIV = crc40[PREST-1];
endfunction

function logic [PREST-1:0] MULTGF ( logic[PREST-1:0] d0,  logic[PREST-1:0] d1 );
		 MULTGF = PDIV( PMULT(d0,d1));
endfunction

endpackage