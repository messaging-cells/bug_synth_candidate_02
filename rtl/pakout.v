
`include "hglobal.v"

`default_nettype	none

`define NS_SHOW_ERR 1

`define NS_MSG_WITH_FIRST_VALS(mg) `NS_REG_MSG_RED_EQ(mg, 3, 2, 5, 15)

module pakout
#(parameter 
	PSZ=`NS_PACKET_SIZE, 
	FSZ=`NS_PACKOUT_FSZ, 
	ASZ=`NS_ADDRESS_SIZE, 
	DSZ=`NS_DATA_SIZE, 
	RSZ=`NS_REDUN_SIZE,
)(
	input wire i_clk,
	
	`NS_DECLARE_IN_CHNL(rcv0)

	input wire has_err
);
	// inp0 regs
	reg [0:0] rgi0_ack = `NS_OFF;

	// fifos
	`NS_DECLARE_FIFO(bf0)
	
	`NS_DECLARE_REG_MSG(dbg_fif)
	`NS_DECLARE_REG_MSG(mg_aux1)
	`NS_DECLARE_REG_MSG(mg_aux2)
	`NS_DECLARE_REG_MSG(mg_aux3)
	
	reg [`NS_FULL_MSG_SZ-1:0] mg_data;
	
	localparam ST_INI = 8'h20;
	localparam ST_SET = 8'h21;
	localparam ST_GET = 8'h22;
	localparam ST_CHK = 8'h23;

	reg [7:0] all_err = 0;
	reg [7:0] curr_state = ST_INI;
		
	always @(posedge i_clk)
	begin
		if(rcv0_req && `NS_MSG_WITH_FIRST_VALS(rcv0)) begin
			case(curr_state)
				ST_INI :
				begin
					`NS_FIFO_INIT(bf0)
					curr_state <= ST_SET;
				end
				ST_SET :
				begin
					`NS_FIFO_SET_IDX(rcv0, bf0, 1)
					`NS_MOV_REG_MSG(mg_aux1, rcv0)
					`NS_SEQ_SET(mg_data, rcv0)
					curr_state <= ST_GET;
				end
				ST_GET :
				begin
					`NS_FIFO_GET_IDX(dbg_fif, bf0, 1)
					`NS_MOV_REG_MSG(mg_aux2, mg_aux1)
					`NS_SEQ_GET(mg_data, mg_aux3)
					curr_state <= ST_CHK;
				end
				ST_CHK:
				begin
					if(! `NS_MSG_WITH_FIRST_VALS(rcv0)) begin
						all_err[0:0] <= `NS_ON;
					end
					else
					if(! `NS_MSG_WITH_FIRST_VALS(mg_aux1)) begin
						all_err[1:1] <= `NS_ON;
					end
					else
					if(! `NS_MSG_WITH_FIRST_VALS(mg_aux2)) begin
						all_err[2:2] <= `NS_ON;
					end
					else
					if(! `NS_MSG_WITH_FIRST_VALS(mg_aux3)) begin
						all_err[3:3] <= `NS_ON;
					end
					else
					//if(! `NS_REG_MSG_RED_EQ(dbg_fif, 3, 0, 5, 15)) begin
					if(! `NS_MSG_WITH_FIRST_VALS(dbg_fif)) begin
						if(`NS_SHOW_ERR) begin
							all_err[4:4] <= `NS_ON;
						end
					end
				end

			endcase
		end
	end
	
	//inp0
	assign rcv0_ack = rgi0_ack;

	assign has_err = (|  all_err);
	
endmodule

