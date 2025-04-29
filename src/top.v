`timescale 1 ns/ 100 ps
`default_nettype none // Strictly enforce all nets to be declared

module top 
(
  input  wire       clk,   
  output wire [3:0] led
);// module top


  wire clk_100m_loc;
  wire clk_100m_tree;
  wire u0_q;
  wire u1_q;
  wire u2_q;
  // wire u3_q;
  wire pulse_1hz; //new


  //counter and pulse registers
  reg [26:0] counter = 0; //27-bit counter to count up to 50M
  reg pulse_reg = 0; //register to hold the pulse state


  // Clock divider to generate 1 Hz pulse from 100 MHz clock
  always @(posedge clk_100m_tree) begin
    // Check if counter reached target value (50M cycles = 0.5 seconds)
    if (counter >= 27'd50000000 - 1) begin
        counter <= 0;              // Reset counter
        pulse_reg <= ~pulse_reg;   // Toggle pulse output
    end else begin
        counter <= counter + 1;    // Increment counter
    end
  end

// Connect register to wire
assign pulse_1hz = pulse_reg;

  IBUF i0 ( .I( clk          ), .O( clk_100m_loc  ) );
  BUFG i1 ( .I( clk_100m_loc ), .O( clk_100m_tree ) );

  FDSE u0 ( .S(0), .CE(1), .C( clk_100m_tree ), .D( u2_q ), .Q( u0_q ) );
  FDRE u1 ( .R(0), .CE(1), .C( clk_100m_tree ), .D( u0_q ), .Q( u1_q ) );
  FDRE u2 ( .R(0), .CE(1), .C( clk_100m_tree ), .D( u1_q ), .Q( u2_q ) );
  // FDRE u3 ( .R(0), .CE(1), .C( clk_100m_tree ), .D( u2_q ), .Q( u3_q ) );

  OBUF j0 ( .I( u0_q ), .O( led[0] ) );
  OBUF j1 ( .I( u1_q ), .O( led[1] ) );
  OBUF j2 ( .I( u2_q ), .O( led[2] ) );
  // OBUF j3 ( .I( u3_q ), .O( led[3] ) );


endmodule // top.v
`default_nettype wire // enable Verilog default for any 3rd party IP needing it
// 