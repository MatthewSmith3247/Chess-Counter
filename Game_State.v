module Game_State(input wire Clock,// Input
						input wire Reset,// Input
						input wire Pause,// Input
						input wire Start, //Input
						input wire Sw1,// Input
						input wire Sw2,// Input
						output wire p1,// Output
						output wire p2,//Output
						output wire Load,//Output
						output wire ff); //Output
				
//States: Reset, Load, Pause, P1, P2		
localparam State_Reset = 3'd0,
			  State_Load = 3'd1,
			  State_Pause = 3'd2,
			  State_P1 = 3'd3,
			  State_P2 = 3'd4;

reg[2:0] currentState;
initial currentState = 3'd0;
reg[2:0] nextState;
initial nextState = 3'd1;

// Output logic
assign p1 = (currentState == State_P1);
assign p2 = (currentState == State_P2);
assign Load = (currentState == State_Load);
assign ff = (currentState == State_Reset);


always@(posedge Clock)

 begin
    if (!Reset) currentState <= State_Reset;
    else
        currentState <= nextState;
end

// Combinational logic for determining the next state
always@(*) begin
    nextState = currentState; // Default to holding the current state
	 
    case (currentState)
        State_Reset:
            begin
                nextState = State_Load;
                //assign ff = (currentState == State_Reset);			 
            end
				
        State_Load:
            begin
                
	            if(!Start) nextState = State_Pause;
					else if(!Reset) nextState = State_Reset;
					else nextState = State_Load;
            end
        State_Pause:
            begin
                if (Sw1) nextState = State_P1;
                else if (Sw2) nextState = State_P2;
                else if (Pause) nextState = State_Pause;
	             else if (!Start) nextState = State_Pause;
                else if (!Reset) nextState = State_Reset;				 
                else  nextState = State_Pause;	
            end
		  State_P1:
            begin
                if (Sw2) nextState = State_P2;
                else if (Sw1) nextState = State_P1;
                else if (Pause) nextState = State_Pause;
	             else if (!Start) nextState = State_P1;
                else if (!Reset) nextState = State_Reset;				 
                else nextState = State_P1;	
            end
		  State_P2:
            begin
                if (Sw1) nextState = State_P1;
                else if (Sw2) nextState = State_P2;
                else if (Pause) nextState = State_Pause;
	             else if (!Start) nextState = State_P2;
                else if (!Reset) nextState = State_Reset;				 
                else nextState = State_P2;	
            end				
    endcase
end

endmodule

						