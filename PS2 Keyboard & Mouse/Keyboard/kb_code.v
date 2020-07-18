module kb_code
# (parameter W_SIZE = 2)
(
	clk, reset, ps2d, ps2c, rd_key_code, key_code, kb_buf_empty;
	)

input wire clk, reset, ps2d, ps2c, rd_key_code;
output wire [7:0] key_code, kb_buf_empty;

localparam BRK = 8'hf0;
localparam wait_brk = 1'b0, get_code = 1'b1

reg [1:0] state_reg, state_next;
wire [7:0] scan_data;
reg got_code_tick;
wire scan_done_tick;

ps2_rx ps2_rx_unit (.clk(clk), .reset(reset), rx_en(1'b1), .ps2d(ps2d), .ps2c(ps2c),
	.rx_done_tick(scan_done_tick), .dout(scan_data));

fifo #(.B(8), .W(W-SIZE)) fifo_key_unit 
(.clk(clk),  .reset(reset),  .rd(rd_key_ode), .wr(got_code_tick), .w_data(scan_out), 
.empty (kb_buf_empty), .full(), .r_data(key_code)); 

always @(posedge clk or posedge reset) begin
	if (reset) begin
		state_reg <= wait_brk;
	end
	else begin
		state_reg <= state_next;
	end
end

always @(*) begin
	get_code_tick = 1'b0;
	state_next = state_reg;

	case (state_reg)
		wait_brk:
			begin
				if (scan_done_tick == 1'b1 && scan_out == BRK)
					state_next = get_code;
			end
			
		get_code:
			if (scan_done_tick) 
				begin
					got_code_tick = 1'b1;
					state_next = wait_brk;
				end
	endcase
end
endmodule
