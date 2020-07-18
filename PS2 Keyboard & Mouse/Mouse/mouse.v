module mouse
(
	clk, reset, ps2d, ps2c, xm, ym, btnm, m_done_tick
	)

input wire clk, reset;
inout wire ps2d, ps2c;
output wire [8:0] xm, ym;
output wire [2:0] btnm;
output reg m_done_tick;

localparam STRM = 8'h20;
localparam [2:0] init1 = 3'b000, init2 = 3'b001, init3 = 3'b010, pack1 = 3'b011, 
pack2 = 3'b100, pack3 = 3'b101, done = 3'b110;

reg [2:0] state_reg, state_next;
wire [7:0] rx_data;
reg wr_ps2;
wire rx_done_tick, tx_done_tick;
reg [8:0] x_reg, y_reg, x_next, y_next;
reg [2:0] btn_reg, btn_next;

ps2_rxtx ps2_unit (.clk(clk), .reset(reset), .wr_ps2(wr_ps2), .din(STRM), .dout(rx_data), 
	.ps2d(ps2d), .ps2c(ps2c), rx_done_tick(rx_done_tick), .tx_done_tick(tx_done_tick));

always @(posedge clk or posedge reset) begin
  	if (reset) begin
  		state_reg <= init1;
  		x_reg <= 0;
  		y_reg <= 0;
  		btn_reg <= 0;
  	end
  	else begin
 		state_reg <= state_next;
  		x_reg <= x_next;
  		y_reg <= y_next;
  		btn_reg <= btn_next;  		
  	end
  end  

always @(*) begin
	state_next = state_reg;
	wr_ps2 = 1'b0;
	m_done_tick = 1'b0;
	x_next = x_reg;
	y_next = y_reg;
	btn_next = btn_reg;

	case (state_reg)
		init1:
			begin
				wr_ps2 = 1'b1;
				state_next init2;
			end

		init2:
			begin
				if (tx_done_tick)
					state_next = init3;
			end
		init2:
			begin
				if (rx_done_tick)
					state_next = pack1;
			end

		pack1:
			begin
				if (rx_done_tick) begin
					state_next = pack2;
					y_next = rx_data[5];
					x_next = rx_data[4];
					btn_next = rx_data[2:0];
				end	
			end

		pack2:
			begin
				if (rx_done_tick) begin
					state_next = pack3;
					x_next[7:0] = rx_data;
				end
			end
			
		pack3:
			begin
				if (rx_done_tick) begin
					state_next = done;
					y_next[7:0] = rx_data;
				end
			end

		done:
			begin
				m_done_tick = 1'b1;
				state_next = pack1;
			end
	endcase
end

assign xm = x_reg;
assign ym = y_reg;
assign btnm = btn_reg;

endmodule
