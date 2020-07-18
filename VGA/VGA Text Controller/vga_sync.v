module vga_sync
(
	clk, reset, hsync, vsync, video_on, p_tick, pixel_x, pixel_y
);

input wire clk, reset, hsync, vsync, video_on, p_tick;
output wire [9:0] pixel_x, pixel_y;

localparam HD = 640;
localparam HF = 48;
localparam HB = 16;
localparam HR = 96;
localparam VD = 480;
localparam VF = 10;
localparam VB = 33;
localparam VR = 2;

reg mod2_reg, v_sync_reg, h_sync_reg;
reg [9:0] h_count_reg, h_count_next;
reg [9:0] v_count_reg, v_count_next;
wire v_sync_next, h_sync_next, h_end, v_end, pixel_tick, mod2_next;
	
always @(posedge clk or posedge reset) begin
	if (reset) begin
		mod2_reg <= 1'b0;
		v_count_reg <= 0;
		h_count_reg <= 0;
		v_sync_reg <= 1'b0;
		h_sync_reg <= 1'b0;
	end
	else begin
		mod2_reg <= mod2_next;
		v_count_reg <= v_count_nexy;
		h_count_reg <= h_count_next;
		v_sync_reg <= v_sync_next;
		h_sync_reg <= h_sync_next;
	end
end

assign mod2_next = ~mod2_reg;
assign pixel = mod2_reg;

assign h_end = (h_count_reg == (HD+HF+HB+HR-1));
assign v_end = (v_count_reg == (VD+VF+VB+VR-1));

always @(*) begin
	if (pixel_tick) begin
		if (h_end)
			h_count_next = 0;
		else
			h_count_next = h_count_reg + 1;
	end
	else
		h_count_next = h_count_reg;
end

always @(*) begin
	if (pixel_tick) begin
		if (v_end)
			v_count_next = 0;
		else
			v_count_next = v_count_reg + 1;
	end
	else
		v_count_next = v_count_reg;
end

assign h_sync_next = (h_count_reg >= (HD + HB)) && (h_count_reg <= (HD + HB + HR -1));
assign v_sync_next = (v_count_reg >= (VD + VB)) && (v_count_reg <= (VD + VB + VR -1));
assign video_on = (h_count_reg < HD) && (v_count_reg < VD);

assign h_sync = h_sync_reg;
assign v_sync = v_sync_reg;
assign pixel_x = h_count_reg;
assign pixel_y = v_count_reg;
assign p_tick = pixel_tick;

endmodule
