module sort(
    input clk,
    input rst_n,

    input [7:0] d1_i,
    input [7:0] d2_i,
    input [7:0] d3_i,

    output reg [7:0] max_o,
    output reg [7:0] med_o,
    output reg [7:0] min_o
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        max_o   <= 8'd0;
    else if (d1_i >= d2_i && d1_i >= d3_i) 
        max_o   <= d1_i;
    else if (d2_i >= d1_i && d2_i >= d3_i)
        max_o   <= d2_i;
    else if (d3_i >= d1_i && d3_i >= d1_i)
        max_o   <= d3_i;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        med_o   <= 8'd0;
    else if ((d1_i >= d2_i && d1_i <= d3_i) || (d1_i >= d3_i && d1_i <= d2_i)) 
        med_o   <= d1_i;
    else if ((d2_i >= d1_i && d2_i <= d3_i) || (d2_i >= d3_i && d2_i <= d1_i))
        med_o   <= d2_i;
    else if ((d3_i >= d1_i && d3_i <= d2_i) || (d3_i >= d2_i && d3_i <= d1_i))       
        med_o   <= d3_i;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        min_o   <= 8'd0;
    else if (d1_i <= d2_i && d1_i <= d3_i) 
        min_o   <= d1_i;
    else if (d2_i <= d1_i && d2_i <= d3_i)
        min_o   <= d2_i;
    else if (d3_i <= d1_i && d3_i <= d2_i)
        min_o   <= d3_i;
end
endmodule