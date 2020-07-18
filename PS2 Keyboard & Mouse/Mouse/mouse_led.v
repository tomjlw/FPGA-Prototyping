module mouse_led
(
	clk, reset, ps2d, ps2c, led
	)

input wire clk, reset;
inout wire ps2d, ps2c;
output reg [7:0] led;

reg [9:0] p_reg;
wire [9:0] p_next;
wire [8:0] xm;
wire [2:0] btn,;
wire m_done_tick;

mosue mouse_unit(.clk(clk), .reset(reset), .ps2d(ps2d), .ps2c(ps2c), .xm(xm), .ym(), 
	.btnm(btnm), .m_done_tick(m_done_tick));

always @(posedge clk or posedge reset) begin
	if (reset) begin
		p_reg <= 0;
	end
	else begin
		p_reg <= p_next;
	end
end

assign p_next = (~m_done_tick) ? p_reg : (btnm[0]) ? 10'b0 : (btnm[1]) ? 10'h3ff : p_reg + {xm[8], xm};

always @(*) begin
	case (p_reg[9:7])
		3'b000: led =  8'b10000000; 
		3'b001: led =  8'b01000000; 
		3'b010: led =  8'b00100000; 
		3'b011: led =  8'b00010000; 
		3'b100: led =  8'b00001000; 
		3'b101: led =  8'b00000100; 
		3'b110: led =  8'b00000010; 
		default: led =  8'b00000001;		
	endcase
end

endmodule
