module mean_filter(
    input clk,
    input rst_n,

    input en_i,
    input [7:0] data_i,
    output reg [7:0] data_o,
    output reg done_o
);

//-----------------------------------------------------------------
reg [7:0] max, min;
reg [11:0] sum;
reg [3:0] num;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum <= 8'd0;
    end else if (en_i) begin
        sum <= sum + data_i;       
    end else begin
        sum <= 8'd0;
    end       
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        min <= 8'hff;
    end else if (en_i) begin
        if (data_i < min) 
            min <= data_i;
    end else begin
        min <= 8'hff;
    end     
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        max <= 8'h00;
    end else if (en_i) begin
        if (max < data_i) 
            max <= data_i;
    end else begin
        max <= 8'h00;
    end     
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        num <= 8'h00;
    end else if (en_i) begin
        if (num == 4'd10)
            num <= 4'd0;
        else
            num <= num + 4'd1;
    end else begin
        num <= 4'd0;
    end
end 

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_o <= 8'd0;
        done_o <= 1'd0;
    end else if (en_i) begin
        if (num == 4'd10) begin
            data_o <= (sum - max - min) >> 3;
            done_o <= 1'd1;
        end else begin
            data_o <= 8'd0;
            done_o <= 1'd0;
        end
    end else begin
        data_o <= 8'd0;
        done_o <= 1'd0;
    end
end
endmodule