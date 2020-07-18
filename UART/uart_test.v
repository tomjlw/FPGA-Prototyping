module uart_test(
	clk, reset, rx, btn, tx, an, sseg, led
	)

input wire clk, reset, rx;
input wire [2:0] btn;
output wire tx;
output wire [3:0] an;
output wire [7:0] sseg, led;
wire tx_full, rx_empty, btn_tick;
wire [7:0] rec_data, rec_data1;

uart  uart-unit 
( .clk(clk), .reset(reset), .rd_uart(btn_tick), .wr_uart(btn_tick), .rx(rx), 
  .w-data(rec_data1), .tx_full(tx_full), .rx_empty(rx_empty), .r_data(rec_data), .tx(tx)); 

debounce btn_db_unit 
( .clk(clk), .reset(reset), .sw(btn[O]), .db_level(), . db_tick(btn_tick));

assign rec_data1 = rec_data + 1;
assign led = rec_data;
assign an = 4'b1110;
assign sseg = {1'b1, ~tx_full, 2'b11, 2'b11, ~rx_empty, 3'b111};

endmodule
