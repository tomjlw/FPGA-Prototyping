module ps2_tx
(
	clk, reset, wr_ps2, din, ps2d, ps2c, rx_done_tick, tx_done_tick, dout
	)

input wire clk, reset, wr_ps2;
input wire [7:0] din;
inout wire ps2d, ps2c;
output wire rx_done_tick, tx_done_tick;
output wire [7:0] dout;

wire tx_idle;

ps2_rx ps2_rx_unit (.clk(clk), .reset(reset), .rx_en(tx_idle), .ps2d(ps2d), .ps2c(ps2c),
	.rx_done_tick(rx_done_tick), .dout(dout));

ps2_tx ps2_tx_unit (.clk(clk), .reset(reset), wr_ps2(wr_ps2), din(din), .ps2d(ps2d), 
	.ps2c(ps2c), .tx_idle(tx_idle), .tx_done_tick(rx_done_tick);

endmodule
