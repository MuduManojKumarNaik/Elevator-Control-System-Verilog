module elevator_controller(
input clk,
input rst,
input [2:0] floor_req, // requests 0,1,2
input door_open_btn,
input door_close_btn,
input door_sensor,
output reg [1:0] current_floor,
output reg up,
output reg down,
output reg door
);
parameter IDLE = 3'd0;
parameter MOVE_UP = 3'd1;
parameter MOVE_DOWN = 3'd2;
parameter DOOR_OPEN = 3'd3;
parameter DOOR_CLOSE = 3'd4;
reg [2:0] state;
reg [2:0] pending;
always @(posedge clk or posedge rst)
begin
if(rst)
begin
state <= IDLE;
current_floor <= 2'd1; // start at 1st floor
pending <= 3'b000;
door <= 0;
up <= 0;
down <= 0;
end
else
begin
pending <= pending | floor_req;
case(state)
IDLE:
begin
up <= 0;
down <= 0;
if(pending[current_floor])
state <= DOOR_OPEN;
else if(pending > current_floor)
state <= MOVE_UP;
else if(pending < current_floor)
state <= MOVE_DOWN;
end
MOVE_UP:
begin
up <= 1;
down <= 0;
if(current_floor < 2)
current_floor <= current_floor + 1;
if(pending[current_floor])
state <= DOOR_OPEN;
end
MOVE_DOWN:
begin
up <= 0;
down <= 1;
if(current_floor > 0)
current_floor <= current_floor - 1;
if(pending[current_floor])
state <= DOOR_OPEN;
end
DOOR_OPEN:
begin
door <= 1;
if(door_sensor || door_open_btn)
state <= DOOR_OPEN;
else
state <= DOOR_CLOSE;
end
DOOR_CLOSE:
begin
if(door_close_btn)
door <= 0;
pending[current_floor] <= 0;
state <= IDLE;
end
endcase
end
end
endmodule
