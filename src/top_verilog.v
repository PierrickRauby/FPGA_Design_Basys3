`timescale 1ns/ 100ps
`default_nettype none // Strictly enforce all nets to be declared

module top
(
    input wire clk,
    output wire [3:0] led
);//module top

wire clk_100m_loc;
wire clk_100m_tree;
reg [3:0] d_flop_sr = 4'd1;
reg pulse_1hz = 0;
wire sim_mode;
reg [26:0] ck_div_cnt=27'd0;

assign clk_100m_loc = clk; //infer IBUF
assign clk_100m_tree=clk_100m_loc; //infer BUFG

always @ ( posedge clk_100m_tree ) begin
    if ( pulse_1hz == 1 ) begin
        d_flop_sr[3:0] <= { d_flop_sr[2:0],d_flop_sr[3]};
    end
end
    assign led = d_flop_sr[3:0];


assign sim_mode = 0;

//------------------------------------------------------------
// Create a single pulse a 1 Hz rate by counting to 100,000,000 at 100MHz
//------------------------------------------------------------

always @ ( posedge clk_100m_tree) begin : proc_ck_div
    if ( ( sim_mode ==1 && ck_div_cnt == 27'd10) || 
        (sim_mode == 0 && ck_div_cnt == 27'd00000000)) begin
        ck_div_cnt <=27'd1;
        pulse_1hz<=1;
    end else begin
        ck_div_cnt <= ck_div_cnt[26:0] + 1;
        pulse_1hz <=0;
    end
end //proc_ck_div

    endmodule //top.v
    `default_nettype wire //enable Verilog defautl for any 3rd party IP needing it

