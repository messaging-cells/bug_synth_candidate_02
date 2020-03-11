
`ifndef HGLOBAL_V_FILE
`define HGLOBAL_V_FILE 1
//--------------------------------------------

`define NS_ON 1
`define NS_OFF 0

`define NS_TRUE 1
`define NS_FALSE 0

`define ns_bit_toggle(bb) bb <= ~bb

`define NS_ADDRESS_SIZE 6
`define NS_DATA_SIZE 4
`define NS_REDUN_SIZE 4 // MUST BE LESS THAN the full message size ((NS_ADDRESS_SIZE * 2) + NS_DATA_SIZE) 

`define NS_PACKET_SIZE 3 // MUST BE LESS THAN the full message size ((NS_ADDRESS_SIZE * 2) + NS_DATA_SIZE) 

`define NS_1to2_FSZ 1  // 1, 2 or 4 ***ONLY***
`define NS_2to1_FSZ 2  // 1, 2 or 4 ***ONLY***
`define NS_PACKOUT_FSZ 4  // 1, 2 or 4 ***ONLY***
`define NS_PACKIN_FSZ 4  // 1, 2 or 4 ***ONLY***


`define NS_MSG_FIFO_IDX_SZ ((FSZ == 4)?(2):(1))


// needed
`define NS_FULL_MSG_SZ  (ASZ + ASZ + DSZ + RSZ)


// needed
`define NS_DECLARE_REG_MSG(mg) \
	reg [ASZ-1:0] mg``_src = 0; \
	reg [ASZ-1:0] mg``_dst = 0; \
	reg [DSZ-1:0] mg``_dat = 0; \
	reg [RSZ-1:0] mg``_red = 0; \


`define NS_DECLARE_IN_MSG(mg) \
	input wire [ASZ-1:0] mg``_src, \
	input wire [ASZ-1:0] mg``_dst, \
	input wire [DSZ-1:0] mg``_dat, \
	input wire [RSZ-1:0] mg``_red, \


`define NS_DECLARE_OUT_MSG(mg) \
	output wire [ASZ-1:0] mg``_src, \
	output wire [ASZ-1:0] mg``_dst, \
	output wire [DSZ-1:0] mg``_dat, \
	output wire [RSZ-1:0] mg``_red, \


// needed
`define NS_ASSIGN_OUT_MSG(ou, mg) \
	assign ou``_src = mg``_src; \
	assign ou``_dst = mg``_dst; \
	assign ou``_dat = mg``_dat; \
	assign ou``_red = mg``_red; \


// needed
`define NS_MOV_REG_MSG(mg_dst, mg_src) \
	mg_dst``_src <= mg_src``_src; \
	mg_dst``_dst <= mg_src``_dst; \
	mg_dst``_dat <= mg_src``_dat; \
	mg_dst``_red <= mg_src``_red; 


`define NS_REG_MSG_EQ(mg, eq_src, eq_dst, eq_dat) ((mg``_src == eq_src) && (mg``_dst == eq_dst) && (mg``_dat == eq_dat))


// needed
`define NS_REG_MSG_RED_EQ(mg, eq_src, eq_dst, eq_dat, eq_red) ((mg``_src == eq_src) && \
	(mg``_dst == eq_dst) && (mg``_dat == eq_dat) && (mg``_red == eq_red))


// needed
`define NS_DECLARE_OUT_CHNL(nam) \
	`NS_DECLARE_OUT_MSG(nam) \
	output wire nam``_req, \
	input wire nam``_ack, 


// needed	
`define NS_DECLARE_IN_CHNL(nam) \
	`NS_DECLARE_IN_MSG(nam) \
	input wire nam``_req, \
	output wire nam``_ack, 


// needed	
`define NS_DECLARE_LINK(lnk) \
	wire [ASZ-1:0] lnk``_src; \
	wire [ASZ-1:0] lnk``_dst; \
	wire [DSZ-1:0] lnk``_dat; \
	wire [RSZ-1:0] lnk``_red; \
	wire lnk``_req; \
	wire lnk``_ack; 

	
// needed	
`define NS_INSTA_CHNL(chn, lnk) \
	.chn``_src(lnk``_src), \
	.chn``_dst(lnk``_dst), \
	.chn``_dat(lnk``_dat), \
	.chn``_red(lnk``_red), \
	.chn``_req(lnk``_req), \
	.chn``_ack(lnk``_ack), 

	
`define NS_REG_MSG_INIT(mg) \
	mg``_src <= 0; \
	mg``_dst <= 0; \
	mg``_dat <= 0; \
	mg``_red <= 0; \


// needed
`define NS_DECLARE_FIFO(fif) \
	integer fif``ii=0; \
	reg [0:0] fif``_busy [FSZ-1:0]; \
	reg [`NS_FULL_MSG_SZ-1:0] fif``_data[FSZ-1:0]; \
	reg [`NS_MSG_FIFO_IDX_SZ-1:0] fif``_hd_idx = 0; \
	reg [`NS_MSG_FIFO_IDX_SZ-1:0] fif``_tl_idx = 0;


// needed
`define NS_FIFO_INIT(fif) \
	for(fif``ii = 0; fif``ii < FSZ; fif``ii = fif``ii+1) begin \
		fif``_busy[fif``ii] <= `NS_OFF; \
	end \
	for(fif``ii = 0; fif``ii < FSZ; fif``ii = fif``ii+1) begin \
		fif``_data[fif``ii] <= 0; \
	end \
	fif``_hd_idx <= 0; \
	fif``_tl_idx <= 0;



`define NS_GET_SEQ_MSG(chn) {chn``_src, chn``_dst, chn``_dat, chn``_red}


// needed
`define NS_FIFO_SET_IDX(chn, fif, idx) fif``_data[idx] <= `NS_GET_SEQ_MSG(chn);

// ASZ + ASZ + DSZ + RSZ
`define NS_MG_SRC_SECTION  ((ASZ + ASZ + DSZ + RSZ)-1):(ASZ + DSZ + RSZ)
`define NS_MG_DST_SECTION  ((ASZ + DSZ + RSZ)-1):(DSZ + RSZ)
`define NS_MG_DAT_SECTION  ((DSZ + RSZ)-1):RSZ
`define NS_MG_RED_SECTION  (RSZ-1):0


`define NS_SEQ_SET(seq, chn) \
	seq``[`NS_MG_SRC_SECTION] <= chn``_src; \
	seq``[`NS_MG_DST_SECTION] <= chn``_dst; \
	seq``[`NS_MG_DAT_SECTION] <= chn``_dat; \
	seq``[`NS_MG_RED_SECTION] <= chn``_red;


`define NS_SEQ_GET(seq, chn) \
	chn``_src <= seq``[`NS_MG_SRC_SECTION]; \
	chn``_dst <= seq``[`NS_MG_DST_SECTION]; \
	chn``_dat <= seq``[`NS_MG_DAT_SECTION]; \
	chn``_red <= seq``[`NS_MG_RED_SECTION]; 


//`define NS_FIFO_SET_IDX(chn, fif, idx) `NS_SEQ_SET(fif``_data[idx], chn)

//`define NS_FIFO_GET_IDX(chn, fif, idx) `NS_SEQ_GET(fif``_data[idx], chn)

/*
`define NS_FIFO_SET_IDX(chn, fif, idx) \
	fif``_data[idx][`NS_MG_SRC_SECTION] <= chn``_src; \
	fif``_data[idx][`NS_MG_DST_SECTION] <= chn``_dst; \
	fif``_data[idx][`NS_MG_DAT_SECTION] <= chn``_dat; \
	fif``_data[idx][`NS_MG_RED_SECTION] <= chn``_red; 
*/


`define NS_FIFO_GET_IDX(chn, fif, idx) \
	chn``_src <= fif``_data[idx][`NS_MG_SRC_SECTION]; \
	chn``_dst <= fif``_data[idx][`NS_MG_DST_SECTION]; \
	chn``_dat <= fif``_data[idx][`NS_MG_DAT_SECTION]; \
	chn``_red <= fif``_data[idx][`NS_MG_RED_SECTION];
	


//--------------------------------------------
`endif // HGLOBAL_V_FILE
