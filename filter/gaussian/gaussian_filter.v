module gaussian_filter(
    input clk,
    input rst_n,

    input en_i,
    input [7:0] d1_i,
    input [7:0] d2_i,
    input [7:0] d3_i,

    output reg done_o,
    output reg [7:0] gaussian_o
);

reg [7:0] d11, d12, d13;
reg [7:0] d21, d22, d23;
reg [7:0] d31, d32, d33;

reg [11:0] gs1, gs2, gs3, gs_sum;

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

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        gs1     <= 12'd0;
        gs2     <= 12'd0;
        gs3     <= 12'd0;
    end else begin
        gs1     <= d11   + d12*2 + d13;
        gs2     <= d21*2 + d22*4 + d23*2;
        gs3     <= d31   + d32*2 + d33;
    end 
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        gs_sum  <= 12'd0;
    end else begin
        gs_sum  <= gs1 + gs2 + gs3;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        gaussian_o  <= 8'd0;
    end else begin
        gaussian_o  <= gs_sum >> 4;
    end
end

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
                    flow    <= 1'd0;
                    count   <= 4'd0;
                    done_o  <= 1'd0;
                end
        endcase
    end
end
endmodule