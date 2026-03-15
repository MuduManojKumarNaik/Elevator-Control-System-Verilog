module elevator_tb;
reg clk;
reg rst;
reg [2:0] floor_req;
reg door_open_btn;
reg door_close_btn;
reg door_sensor;
wire [1:0] current_floor;
wire up;
wire down;
wire door;
elevator_controller DUT(
clk,
rst,
floor_req,
door_open_btn,
door_close_btn,
door_sensor,
current_floor,
up,
down,
door
);
initial
begin
clk=0;
forever #5 clk=~clk;
end
initial
begin
rst=1;
floor_req=0;
door_open_btn=0;
door_close_btn=0;
door_sensor=0;
#20 rst=0;
// request at 1st floor
#20 floor_req=3'b010;
#20 floor_req=0;
// obstruction
#30 door_sensor=1;
#20 door_sensor=0;
// requests 2 and 0
#40 floor_req=3'b101;
#20 floor_req=0;
// new request from 1
#80 floor_req=3'b010;
#20 floor_req=0;
// force door close
#60 door_close_btn=1;
#10 door_close_btn=0;
// new request
#80 floor_req=3'b100;
#200 $finish;
end
initial
begin
$monitor("time=%0t floor=%d up=%b down=%b door=%b req=%b",
$time,current_floor,up,down,door,floor_req);
end
endmodule
