module ping_graph_st
(
	video_on, p_tick, pix_x, pix_y, graph_rgb
);

input wire video_on;
input wire [9:0] pix_x, pix_y;
output reg graph_rgb;

localparam MAX_X = 640;
localparam MAX_Y = 480;
localparam WALL_X_L = 32;
localparam WALL_X_R = 35;

localparam BAR_X_L = 600;
localparam BAR_X_R = 603;
localparam BAR_Y_SIZE = 72;
localparam BAR_Y_T = MAX_Y/2 - BAR_Y_SIZE/2;
localparam BAR_Y_B = MAX_Y_T + BAR_Y_SIZE - 1;

localparam BALL_X_L = 580;
localparam BALL_X_R = BALL_X_L + BALL_SIZE - 1;
localparam BALL_SIZE = 8;
localparam BALL_Y_T = 238;
localparam BALL_Y_B = BALL_Y_T + BAR_Y_SIZE - 1;

wire wall_on, bar_on, sq_ball_on;
wire [2:0] wall_rgb, bar_rgb, ball_rgb;

assign wall_on = (WALL_X_L <= pix_x) && (pix_x <= WALL_X_R);
assign wall_rgb = 3'b001;

assign bar_on = (BAR_X_L <= pix_x) && (pix_x <= BAR_X_R) && (BAR_Y_T <= pix_y) && (pix_y <= BAR_Y_B);
assign bar_rgb = 3'b010;

assign sq_ball_on = (BALL_X_L <= pix_x) && (pix_x <= BALL_X_R) && (BALL_Y_T <= pix_y) && (pix_y <= BALL_Y_B);
assign ball_rgb = 3'b100;

always @(*) begin
	if (~video_on) begin
		graph_rgb = 3'b000;
	end
	else if (wall_on) begin
		graph_rgb = wall_rgb;
	end
	else if (bar_on) begin
		graph_rgb = bar_rgb;
	end
	else if (sq_ball_on) begin
		graph_rgb = ball_rgb;
	end
	else begin
		graph_rgb = 3'b110;
	end
end

endmodule
