module bcd_encoder #(
        parameter BINARY_LENGTH=32,
        parameter DECIMAL_LENGTH=64)
        (
        input wire CLK,
        input wire [BINARY_LENGTH-1:0] binary_data,
        output wire [(DECIMAL_LENGTH*4)-1:0] BCD_data,
        output wire BCD_ready
        );

parameter WORKING_REGISTER_TOP = (BINARY_LENGTH-1) + (DECIMAL_LENGTH*4);
parameter LOAD_DATA = 0, PROCESS_DATA = 1, OUTPUT_DATA = 2, UNDEFINED = 3;

reg [WORKING_REGISTER_TOP:0] working_register = 0;
reg [BINARY_LENGTH-1:0] shift_count = 0; // Can be smaller
reg [1:0] state = 0;
reg [(DECIMAL_LENGTH*4)-1:0] BCD_data_internal = 0;
reg BCD_ready_internal = 0;

assign BCD_ready = BCD_ready_internal;
assign BCD_data = BCD_data_internal;


integer i;

always @ (posedge CLK)
  begin
    case (state)
      LOAD_DATA:
        begin
          working_register[BINARY_LENGTH-1:0] = binary_data;
          working_register[WORKING_REGISTER_TOP:BINARY_LENGTH] = 0;
          BCD_ready_internal = 0;
          state <= PROCESS_DATA;
        end
      PROCESS_DATA:
        begin
          for (i = 0; i < DECIMAL_LENGTH; i = i + 1)
            begin
              if (working_register[WORKING_REGISTER_TOP - (i*4) -: 4] > 4)
                begin
                  working_register[WORKING_REGISTER_TOP - (i*4) -: 4] = working_register[WORKING_REGISTER_TOP - (i*4) -: 4] + 3;
                end
            end
          working_register = working_register << 1;
          shift_count = shift_count + 1;

          if (shift_count == BINARY_LENGTH)
          begin
            state <= OUTPUT_DATA;
          end
        end
      OUTPUT_DATA:
        begin
          BCD_ready_internal = 1;
          shift_count = 0;
          BCD_data_internal = working_register[WORKING_REGISTER_TOP:BINARY_LENGTH];
          state <= LOAD_DATA;
        end
      UNDEFINED:
        begin
          state <= LOAD_DATA;
        end
    endcase
  end
endmodule
