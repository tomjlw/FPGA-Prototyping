module ps2_monitor
(
	clk, reset, sw, btn, ps2d, ps2c, tx
	)

input wire clk, reset;
input wire [7:0] sw;
input wire [2:0] btn;
inout wire ps2d, ps2c;
output wire tx;

localparam SP = 8'h20;
localparam [1:0] idle = 2'b00, send1 = 2'b01, send0 = 2'b10, sendb = 2'b11;

reg [1:0] state_reg, state_next;
reg [7:0] w_data, ascii_code;
wire [7:0] rx_data;
reg wr_uart;
wire psrx_done_tick, wr_ps2;
reg [3:0] hex_in;

ps2_rxtx ps2_rxtx_unit (.clk(clk), .reset(reset), wr_ps2(wr_ps2), .din(sw), 
	.ps2d(ps2d), .ps2c(ps2c), .rx_done_tick(psrx_done_tick), .tx_done_tick());

uart uart_unit (.clk(clk), .reset(reset), .rd_uart(1'b0), .wr_uart(wr_uart), .rx(1'b1),
	.w_data(w_data), .tx_full(), rx_empty(), .r_data(), .tx(tx));

debounce btn_db_unit (.clk(clk), .reset(reset), .sw(btn[0]), db_level(). .db_tick(wr_ps2))

always @(posedge clk or posedge reset) begin
	if (reset) begin
		state_reg <= idle;
	end
	else begin
		state_reg <= state_next;
	end
end

always @(*) begin
	wr_uart = 1'b0;
	w_data = SP;
	state_next = state_reg;

	case (state_reg)
		idle:
			begin
				if (psrx_done_tick)
					state_next = send1;
			end
			
		send1:
			begin
				w_data = ascii_code;
				wr_uart = 1'b1;
				state_next = send0;
			end

		send0:
			begin
				w_data = ascii_code;
				wr_uart = 1'b1;
				state_next = sendb;
			end

		sendb:
			begin
				w_data = SP;
				wr_uart = 1'b1;
				state_next = idle;
			end
	endcase
end

assign hex_in = (state_reg == send1) ? scan_data [7:4] : scan_data [3:0];

always @(*) begin
	case(hex_in)
		4'h0: ascii-code  =  8'h30; 
		4'h1: ascii-code  =  8'h31; 
		4'h2: ascii-code  =  8'h32; 
		4'h3: ascii-code  =  8'h33; 
		4'h4: ascii-code  =  8'h34; 
		4'h5: ascii-code  =  8'h35; 
		4'h6: ascii-code  =  8'h36; 
		4'h7: ascii-code  =  8'h37; 
		4'h8: ascii-code  =  8'h38; 
		4'h9: ascii-code  =  8'h39; 
		4'ha: ascii-code  =  8'h41; 
		4'hb: ascii-code  =  8'h42; 
		4'hc: ascii-code  =  8'h43; 
		4'hd: ascii-code  =  8'h44; 
		4'he: ascii-code  =  8'h45; 
		default: ascii-code  =  8'h46;
	endcase

end
endmodule
