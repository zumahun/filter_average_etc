`timescale 1ps/1ps

`define clk_period 20

module sort_tb();

    reg clk;
    reg rst_n;

    reg [7:0] d1_i;
    reg [7:0] d2_i;
    reg [7:0] d3_i;

    wire [7:0] max_o;
    wire [7:0] med_o;
    wire [7:0] min_o;

sort SORT(
    .clk(clk),
    .rst_n(rst_n),
    
    .d1_i(d1_i),
    .d2_i(d2_i),
    .d3_i(d3_i),

    .max_o(max_o),
    .med_o(med_o),
    .min_o(min_o)
    
);

initial begin
    clk = 1'b1;
    $dumpfile("sort_wave.vcd");
    $dumpvars(0, sort_tb);
end

always #(`clk_period/2) clk = ~clk;

initial begin
    rst_n   = 1'b0;
    d1_i    =   8'd0;
    d2_i    =   8'd0;
    d3_i    =   8'd0;

    @(posedge clk);
    rst_n   = 1'b1;

    @(posedge clk);
    d1_i    =   8'd1;
    d2_i    =   8'd2;
    d3_i    =   8'd3;


    @(posedge clk);
    d1_i    =   8'd4;
    d2_i    =   8'd6;
    d3_i    =   8'd8;

    @(posedge clk);
    d1_i    =   8'd11;
    d2_i    =   8'd13;
    d3_i    =   8'd15;

    repeat(20) @(posedge clk);

    $finish;
end
endmodule