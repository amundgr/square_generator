// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
    input CLK,    // 16MHz clock
    output LED,   // User/boot LED next to power LED
    output USBPU  // USB pull-up resistor
);

parameter bit_size = 128;
parameter deci_size = 39;

reg [(deci_size*4)-1:0] BCD_data_register = 0;

wire [bit_size-1:0] binary_data = 54;
wire [(deci_size*4)-1:0] bcd_data;
wire bcd_ready;



bcd_encoder #(.BINARY_LENGTH(bit_size), .DECIMAL_LENGTH(deci_size)) bcd_enc (.CLK(CLK),
                  .binary_data(binary_data),
                  .BCD_data(bcd_data),
                  .BCD_ready(bcd_ready));

assign LED = bcd_ready;
endmodule
