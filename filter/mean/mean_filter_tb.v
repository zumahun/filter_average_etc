`timescale 1ps/1ps

`define clk_period 20

module mean_filter_tb();

reg clk, rst_n;

reg en_i;
reg [7:0] data_i;

wire [7:0] data_o;
wire done;

mean_filter MEAN_FILTER(
    .clk(clk),
    .rst_n(rst_n),
    
    .en_i(en_i),
    .data_i(data_i),
    .data_o(data_o),
    .done_o(done_o)
);

initial begin
    clk = 1'b1;
end

always #(`clk_period/2) clk = ~clk;

integer i = 0;

initial begin
    $dumpfile("mean_filter_wave.vcd");
    $dumpvars(0, mean_filter_tb);

    rst_n   = 1'b0;
    en_i    = 1'b0;
    data_i  = 8'd0;

    #(`clk_period);
    rst_n   = 1'b1;

    #(`clk_period);
    en_i    = 1'b1;

    for (i = 0; i < 10; i = i + 1) begin
        data_i = data_i + 8'd1;
        #(`clk_period);
    end

    data_i = 8'd0;
    #(`clk_period);

    en_i    = 1'b0;
    #(`clk_period * 10);

    $finish;
end

endmodule