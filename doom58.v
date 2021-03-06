module doom58(CLOCK_50,
              KEY, SW,
              LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
              VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_R, VGA_G, VGA_B,
              PS2_KBCLK, PS2_KBDAT);
    // Clock signal
    input CLOCK_50;
    wire clock;
    assign clock = CLOCK_50;

    // Board inputs
    input [17:0] SW;
    input [3:0] KEY;

    // Board outputs
    output [17:0] LEDR;
    output [6:0] HEX0;
    output [6:0] HEX1;
    output [6:0] HEX2;
    output [6:0] HEX3;
    output [6:0] HEX4;
    output [6:0] HEX5;
    output [6:0] HEX6;
    output [6:0] HEX7;

    // VGA outputs
    output VGA_CLK;
    output VGA_HS;
    output VGA_VS;
    output VGA_BLANK_N;
    output VGA_SYNC_N;
    output [9:0] VGA_R;
    output [9:0] VGA_G;
    output [9:0] VGA_B;

    // Keyboard inputs
    input PS2_KBCLK;
    input PS2_KBDAT;

    // Global reset
    wire reset;
    assign reset = SW[0];

    // VGA adapter controls
    wire [17:0] vga_colour;
    wire [7:0] vga_x;
    wire [6:0] vga_y;
    wire vga_write;

    // VGA adapter set up
    vga_adapter VGA(.resetn(~reset),
                    .clock(CLOCK_50),
                    .colour(vga_colour),
                    .x(vga_x),
                    .y(vga_y),
                    .plot(vga_write),
                    .VGA_R(VGA_R),
                    .VGA_G(VGA_G),
                    .VGA_B(VGA_B),
                    .VGA_HS(VGA_HS),
                    .VGA_VS(VGA_VS),
                    .VGA_BLANK(VGA_BLANK_N),
                    .VGA_SYNC(VGA_SYNC_N),
                    .VGA_CLK(VGA_CLK));
    defparam VGA.RESOLUTION = "160x120";
    defparam VGA.MONOCHROME = "FALSE";
    defparam VGA.BITS_PER_COLOUR_CHANNEL = 6;
    defparam VGA.BACKGROUND_IMAGE = "black.mif";

    // Keyboard set up
    wire [7:0] key_press;
    keyboard kb0 (.mapped_key(key_press),
                  .kb_clock(PS2_KBCLK),
                  .kb_data(PS2_KBDAT),
                  .LEDR(LEDR[8:0]));

    // Main controller
    main m0 (.clock(clock),
             .reset(reset),
             .SW(SW),
             .HEX7(HEX7),
             .HEX6(HEX6),
             .HEX5(HEX5),
             .HEX4(HEX4),
             .HEX1(HEX1),
             .HEX0(HEX0),
             .key_press(key_press),
             .vga_x(vga_x),
             .vga_y(vga_y),
             .vga_colour(vga_colour),
             .vga_write(vga_write));
endmodule
