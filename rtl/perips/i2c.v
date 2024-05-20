// i2c

`define     SCL_POS     (cnt==3'd0)      
`define     SCL_HIG     (cnt==3'd1)
`define     SCL_NEG     (cnt==3'd2)     
`define     SCL_LOW     (cnt==3'd3) 

module i2c(
    input wire clk,
    input wire rst_n,

    // rib interface
    input wire we_i,
    input wire[31:0] addr_i,
    input wire[31:0] data_i,
    output reg[31:0] data_o,
    output reg read_data_ready_o,
    input wire req_i,

    // device interface
    output wire scl,
    inout wire sda
);

    // regs
    reg [31:0] iic_device_addr;  // the address of iic device   , 0x7001_0000
    localparam IIC_DEVICE_ADDR = 4'h1;
    reg [31:0] iic_write_data;  // iic write data regs          , 0x7002_0000
    localparam IIC_WRITE_DATA = 4'h2;
    reg [31:0] iic_read_data;   // iic read data regs           , 0x7003_0000
    localparam IIC_READ_DATA = 4'h3;
    reg [31:0] iic_en;          // iic enable                   , 0x7004_0000
    localparam IIC_EN = 4'h4;

    // get scl
    reg [2:0] cnt;
    reg [8:0] cnt_delay;
    reg scl_r;
    always @ (posedge clk) begin
        if (!rst_n) begin
            cnt_delay <= 9'd0;
        end
        else if (cnt_delay == 9'd499) begin
            cnt_delay <= 9'd0;
        end
        else begin
            cnt_delay <= cnt_delay + 1'b1;
        end
    end

    always @ (posedge clk) begin
        if (!rst_n) begin
            cnt <= 3'd5;
        end
        else begin
            case (cnt_delay)
                9'd124: cnt <= 3'd1;
                9'd249: cnt <= 3'd2;    // scl's negedge
                9'd374: cnt <= 3'd3;  
                9'd499: cnt <= 3'd0;    // scl's posedge
                default: cnt <= 3'd5;
            endcase
        end
    end

    always @ (posedge clk) begin
        if (!rst_n) begin
            scl_r <= 1'b1;
        end
        else if (cnt == 3'd0) begin
            scl_r <= 1'b1;
        end 
        else if (cnt == 3'd2) begin
            scl_r <= 1'b0;
        end
    end

    assign scl = (cstate == IDLE || cstate == STOP) ? 1'b1 : scl_r;

    reg [7:0] db_r;     
    parameter   IDLE      = 4'd0;
    parameter   START     = 4'd1;
    parameter   ADDR      = 4'd2;
    parameter   ACK1      = 4'd3;
    parameter   DATA1     = 4'd4;
    parameter   ACK2      = 4'd5;
    parameter   DATA2     = 4'd6;
    parameter   NACK      = 4'd7;
    parameter   STOP      = 4'd8;

    reg [3:0] cstate;    
    reg sda_r;
    reg sda_link;         
    reg [3:0] num;
    assign sda = sda_link ? sda_r:1'bz;

    always @ (posedge clk) begin
        if (!rst_n) begin
            cstate <= IDLE;
            sda_r <= 1'b1;
            sda_link <= 1'b0;
            num <= 4'd0;
            iic_read_data <= 16'd0;
            read_data_ready_o <= 1'b0;
        end
        else begin
            case (cstate)
                IDLE: begin
                    sda_link <= 1'b1;    
                    sda_r <= 1'b1;
                    read_data_ready_o <= 1'b0;
                    if (req_i || iic_en[0]) begin 
                        db_r <= iic_device_addr[7:0]; 
                        cstate <= START;
                    end
                    else begin
                        cstate <= IDLE;
                    end
                end
                START: begin  
                    if (`SCL_HIG) begin
                        sda_link <= 1'b1;  
                        sda_r <= 1'b0;        
                        cstate <= ADDR;
                        num <= 4'd0;
                    end
                    else begin
                        cstate <= START;
                    end
                end
                ADDR: begin
                    if(`SCL_LOW) begin
                        if (num == 4'd8) begin    
                            num <= 4'd0; 
                            sda_r <= 1'b1;
                            sda_link <= 1'b0;  
                            cstate <= ACK1;
                        end
                        else begin
                            cstate <= ADDR;
                            num <= num + 1'b1;
                            case (num)
                                4'd0: sda_r <= db_r[7];
                                4'd1: sda_r <= db_r[6];
                                4'd2: sda_r <= db_r[5];
                                4'd3: sda_r <= db_r[4];
                                4'd4: sda_r <= db_r[3];
                                4'd5: sda_r <= db_r[2];
                                4'd6: sda_r <= db_r[1];
                                4'd7: sda_r <= db_r[0];
                                default: ;
                            endcase
                        end
                    end
                    else begin 
                        cstate <= ADDR;
                    end
                end
                ACK1: begin 
                    if (!sda_r && (`SCL_HIG)) begin
                        cstate <= DATA1;
                    end
                    else if (`SCL_NEG) begin
                        cstate <= DATA1;
                    end
                    else begin 
                        cstate <= ACK1;
                    end
                end
                DATA1: begin
                    if (`SCL_HIG) begin
                        num <= num + 1'b1;    
                        case (num)
                            4'd0: iic_read_data[15] <= sda;
                            4'd1: iic_read_data[14] <= sda;  
                            4'd2: iic_read_data[13] <= sda; 
                            4'd3: iic_read_data[12] <= sda; 
                            4'd4: iic_read_data[11] <= sda; 
                            4'd5: iic_read_data[10] <= sda; 
                            4'd6: iic_read_data[9]  <= sda; 
                            4'd7: iic_read_data[8]  <= sda; 
                            default: ;
                        endcase                                                          
                    end
                    else if ((`SCL_NEG) && (num == 4'd8)) begin
                            num <= 4'd0;
                            sda_link <= 1'b1;    
                            sda_r <= 1'b1;
                            cstate <= ACK2;
                    end
                    else begin
                        cstate <= DATA1;
                    end
                end    
                ACK2: begin
                    if (`SCL_LOW) begin
                        sda_r <= 1'b0; 
                    end
                    else if (`SCL_NEG) begin 
                        cstate <= DATA2;
                        sda_link <= 1'b0; 
                        sda_r <= 1'b1;    
                    end    
                    else begin
                        cstate <= ACK2;
                    end
                end
                DATA2: begin                
                    if (`SCL_HIG) begin    
                        num <= num + 1'b1;    
                        case (num)
                            4'd0: iic_read_data[7] <= sda;
                            4'd1: iic_read_data[6] <= sda;  
                            4'd2: iic_read_data[5] <= sda; 
                            4'd3: iic_read_data[4] <= sda; 
                            4'd4: iic_read_data[3] <= sda; 
                            4'd5: iic_read_data[2] <= sda; 
                            4'd6: iic_read_data[1] <= sda; 
                            4'd7: iic_read_data[0] <= sda; 
                            default: ;
                        endcase                                                                     
                    end
                    else if ((`SCL_LOW) && (num == 4'd8)) begin
                        num <= 4'd0; 
                        sda_link <= 1'b1;       
                        sda_r <= 1'b1;        
                        cstate <= NACK;
                    end
                    else begin
                        cstate <= DATA2;
                    end
                end    
                NACK: begin
                    if (`SCL_LOW) begin
                        sda_r <= 1'b0; 
                        cstate <= STOP;
                        read_data_ready_o <= 1'b1;                    
                    end
                    else begin
                        cstate <= NACK;
                    end
                end                
                STOP: begin 
                    if (`SCL_HIG) begin
                        sda_r <= 1'b1;
                        cstate <= IDLE;
                    end
                    else begin
                        cstate <= STOP;
                    end
                end
                default: cstate <= IDLE;
            endcase
        end
    end

    // write register
    always @ (posedge clk) begin
        if (~rst_n) begin
            iic_device_addr <= 32'h00000091;
            iic_write_data <= 32'h0;
            iic_read_data <= 32'h0;
            iic_en <= 32'h0;
        end
        else begin
            if (we_i == 1'b1) begin
                case (addr_i[19:16])
                    IIC_DEVICE_ADDR: begin
                        iic_device_addr <= data_i;
                    end
                    IIC_WRITE_DATA: begin
                        iic_write_data <= data_i;
                    end
                    IIC_READ_DATA: begin
                        iic_read_data <= data_i;
                    end
                    IIC_EN: begin
                        iic_en <= data_i;
                    end
                    default: begin
                    end
                endcase
            end
        end
    end

    // read register
    always @ (*) begin
        if (~rst_n) begin
            data_o = 32'h0;
        end
        else begin
            case (addr_i[19:16])
                IIC_DEVICE_ADDR: begin
                    data_o = iic_device_addr;
                end
                IIC_WRITE_DATA: begin
                    data_o = iic_write_data;
                end
                IIC_READ_DATA: begin
                    data_o = iic_read_data;
                end
                IIC_EN: begin
                    data_o = iic_en;
                end
                default: begin
                    data_o = 32'h0;
                end
            endcase
        end
    end

endmodule