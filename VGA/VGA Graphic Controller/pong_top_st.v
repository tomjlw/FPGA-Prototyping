module pong_top_st
(
	clk, reset, hsync, vsync, rgb
);

input wire clk, reset;
output wire hsync, vsync;
output wire [2:0] rgb;

wire [9:0] pixel_x, pixel_y;
wire video_on, pixel_tick;
reg [2:0] rgb_reg;
wire [2:0] rgb_next;

vga_sync vsync_unit (.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync), .video_on(video_on), .p_tick(pixe1_tick), .pixel_x(pixe1_x),  .pixel_y(pixe1_y)); 
pong_graph_st pong_grf_unit (.video_on(video_on), .pix_x(pixe1_x), .pix_Y(pixel_y), .graph_rgb (rgb_next)); 

always @(posedge clk) begin
	if (pixe1_tick)
		rgb_reg <= rgb_next;

assign rgb = rgb_reg;

endmodule
