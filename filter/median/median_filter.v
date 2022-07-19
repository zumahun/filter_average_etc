module median_filter(
    input clk,
    input rst_n,

    input en_i,
    input [7:0] d1_i,
    input [7:0] d2_i,
    input [7:0] d3_i,

    output reg done_o,
    output [7:0] median_o
);

reg [7:0] d11, d12, d13;
reg [7:0] d21, d22, d23;
reg [7:0] d31, d32, d33;

wire [7:0] max1, med1, min1;
wire [7:0] max2, med2, min2;
wire [7:0] max3, med3, min3;

wire [7:0] min_of_max, med_of_med, max_of_min;

reg flow;
reg [3:0] count;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        d11     <= 8'd0;
        d12     <= 8'd0;
        d13     <= 8'd0;
    end else begin
        d11     <= d1_i;
        d12     <= d11;
        d13     <= d12;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        d21     <= 8'd0;
        d22     <= 8'd0;
        d23     <= 8'd0;
    end else begin
        d21     <= d2_i;
        d22     <= d21;
        d23     <= d22;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        d31     <= 8'd0;
        d32     <= 8'd0;
        d33     <= 8'd0;
    end else begin
        d31     <= d3_i;
        d32     <= d31;
        d33     <= d32;
    end
end

sort SORT_LINE1_DATA(
    .clk(clk),
    .rst_n(rst_n),
    
    .d1_i(d11),
    .d2_i(d12),
    .d3_i(d13),

    .max_o(max1),
    .med_o(med1),
    .min_o(min1)
);

sort SORT_LINE2_DATA(
    .clk(clk),
    .rst_n(rst_n),
    
    .d1_i(d21),
    .d2_i(d22),
    .d3_i(d23),

    .max_o(max2),
    .med_o(med2),
    .min_o(min2)
);

sort SORT_LINE3_DATA(
    .clk(clk),
    .rst_n(rst_n),
    
    .d1_i(d31),
    .d2_i(d32),
    .d3_i(d33),

    .max_o(max3),
    .med_o(med3),
    .min_o(min3)
);

sort SORT_MAX_DATA(
    .clk(clk),
    .rst_n(rst_n),

    .d1_i(max1),
    .d2_i(max2),
    .d3_i(max3),

    .max_o(),
    .med_o(),
    .min_o(min_of_max)
);

sort SORT_MED_DATA(
    .clk(clk),
    .rst_n(rst_n),

    .d1_i(med1),
    .d2_i(med2),
    .d3_i(med3),

    .max_o(),
    .med_o(med_of_med),
    .min_o()
);

sort SORT_MIN_DATA(
    .clk(clk),
    .rst_n(rst_n),

    .d1_i(min1),
    .d2_i(min2),
    .d3_i(min3),

    .max_o(max_of_min),
    .med_o(),
    .min_o()
);

sort SORT_FINAL_DATA(
    .clk(clk),
    .rst_n(rst_n),

    .d1_i(min_of_max),
    .d2_i(med_of_med),
    .d3_i(max_of_min),

    .max_o(),
    .med_o(median_o),
    .min_o()
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        flow    <= 1'd0;
        count   <= 4'd0;
        done_o  <= 1'd0;
    end else begin
        case (flow)
            1'd0:
                begin
                    done_o  <= 1'd0;
                    if (en_i) begin
                        flow <= 1'd1;
                        count <= count + 4'd1;
                    end
                end 

            1'd1:
                if (count == 4'd5) begin
                    flow <= 1'd0;
                    count <= 4'd0;
                    done_o <= 1'd1;
                end else begin
                    count <= count + 4'd1;
                end

            default:
                begin
                    flow <= 1'd0;
                    count <= 4'd0;
                    done_o <= 1'd0;
                end
        endcase
    end
end
endmodule