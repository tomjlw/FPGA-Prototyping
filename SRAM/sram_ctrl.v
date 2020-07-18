module sram_ctrl(
	clk, reset, mem, rq, addr, data_f2s, ready, data_s2f_r, 
	data_s2f_ur, ad, we_n, oe_n, dio_a, ce_a_n, ub_a_n, lb_a_n
	);

input wire clk, reset, mem, rw;
input wire [17:0] addr;
input wire [15:0] dataf_2s;
output reg ready;
output wire [15:0] data_s2f_r, data_s2f_ur;
output wire [17:0] ad;
output wire we_n, oe_n;
inout wire [15:0] dio_a;
output wire ce_a_n, ub_a_n, lb_a_n;

localparam [2:0] idle = 3'b000, rd1 = 3'b001, rd2 = 3'b010, wr1 = 3'b011, wr2 = 3'b100;

reg [2:0] state_reg, state_next;
reg [15:0] data_f2s_reg, data_f2s_next, data_s2f_reg, data_s2f_next;
reg [17:0] addr_reg, addr_next;
reg we_buf, oe_buf, tri_buf, we_reg, oe_reg, tri_reg;

always @(posedge clk or posedge reset) begin
	if (reset) begin
		state_reg <= idle;
		addr_reg <= 0;
		data_f2s_reg <= 0;
		data_s2f_reg <= 0;
		tri_reg <= 1'b1;
		we_reg <= 1'b1;
		oe_reg <= 1'b1;
	end
	else begin
		state_reg <= state_next
		addr_reg <= addr_next;
		data_f2s_reg <= data_f2s_next;
		data_s2f_reg <= data_s2f_next;
		tri_reg <= tri_buf;
		we_reg <= we_buf;
		oe_reg <= oe_buf;
	end
end

always @(*) begin
	addr_next = addr_reg;
	data_f2s_next = data_f2s_reg;
	data_s2f_next = data_s2f_reg;
	ready = 1'b0;

	case (state_reg)
		idle:
			begin
				if (~mem)
					state_next = idle;
				else begin
					addr_next = addr;
					if (~rw) begin
						state_next = wr1;
						data_f2s_next = data_f2s;
					end
					else begin
						state_next = rd1;
					end
					ready = 1'b1;
			end

		wr1:
			state_next = wr2;

		wr2:
			state_next = idle;

		rd1:
			state_next = rd2;

		rd2:
			begin
				data_s2f_next = dio_a;
				state_next = idle;
			end
	
		default:
			state_next = idle;

	endcase

always @(*) begin
	tri_buf = 1'b1;
	we_buf = 1'b1;
	oe_buf = 1'b1;

	case (state_next)
		idle:
			oe_buf = 1'b1;

		wr1:
			begin
				tri_buf = 1'b0;
				we_buf = 1'b0;
			end

		wr2:
			begin
				tri_buf = 0;
			end

		rd1:
			oe_buf = 1'b0;

		rd2:
			oe_buf = 1'b0;
	endcase
end

assign data_s2f_r = data_s2f_reg;
assign data_s2f_ur = dio_a;

assign we_n = we_reg;
assign oe_n = oe_reg;
assign ad = addr_reg;
assign ce_a_n = 1'b0;
assign ub_a_n = 1'b0;
assign lb_a_n = 1'b0;
assign dio_a = (~tri_reg) ? data_f2s_reg : 16'bz;

endmodule
