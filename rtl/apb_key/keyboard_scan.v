//按键键盘扫描
module keyboard_scan(
    input               clk ,
    input               RSTn, 
    input       [3:0]   col ,          
    output reg  [3:0]   row ,           
    output reg  [15:0]  key
);
   
    reg [31:0] cnt ;
    reg scan_clk ;

    //0.05ms的周期进行扫描
    always@(posedge clk) begin
        if(!RSTn)begin
            cnt <= 'd0;
            scan_clk<=1'b0;
        end
        if(cnt == 2499) begin
            cnt <= 0;
            scan_clk <= ~scan_clk;
        end
        else
            cnt <= cnt + 1;
    end
   
    always@(posedge scan_clk)
    begin
    	if(!RSTn)
    		row <= 4'b1110; 
    	else
        	row <= {row[2:0],row[3]}; 
    end
    
    always@(negedge scan_clk) 
        case(row)
            4'b1110 : key[15:12] <= col;
            4'b1101 : key[11:8] <= col;
            4'b1011 : key[7:4] <= col;
            4'b0111 : key[3:0] <= col;
            default : key <= 0;
        endcase
        
endmodule
      

