`timescale 1ns/1ps

`define clk_period 20

module median_filter_tb();

reg clk, rst_n;

reg en_i;
reg [7:0] d1_i, d2_i, d3_i;

wire done_o;
wire [7:0] median_o;

median_filter MEDIAN_FILTER(
    .clk(clk),
    .rst_n(rst_n),

    .en_i(en_i),
    .d1_i(d1_i),
    .d2_i(d2_i),
    .d3_i(d3_i),

    .done_o(done_o),
    .median_o(median_o)
);

initial begin
    clk = 1'b1;
    $dumpfile("median_wave.vcd");
    $dumpvars(0, median_filter_tb);
end

always #(`clk_period/2) clk = ~clk;


initial begin
    rst_n   = 1'd0;
    en_i    = 1'b0;
    d1_i    = 8'd0;
    d2_i    = 8'd0;
    d3_i    = 8'd0;

    @(posedge clk);
    rst_n   = 1'b1;

    @(posedge clk);
    #2 en_i    = 1'b1;
     d1_i    = 8'd1;
     d2_i    = 8'd2;
     d3_i    = 8'd3;
    
    @(posedge clk);
    #2 en_i    = 1'b0;
     d1_i    = 8'd4;
     d2_i    = 8'd5;
     d3_i    = 8'd6;

    @(posedge clk);
    #2 d1_i    = 8'd7;
     d2_i    = 8'd8;
     d3_i    = 8'd9;

    repeat(20) @(posedge clk);

    $finish; 
end
















endmodule