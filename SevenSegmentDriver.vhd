----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Hakeem Wilson
-- Project: Lab03
-- Descriotion: Uses 16 onboard switches and the 7 segemt display to count to 16.
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SevenSegmentDriver is
    port(
        reset: in std_logic;
        clock: in std_logic;

      --  digit3: in std_logic_vector(3 downto 0);    --leftmost digit
       -- digit2: in std_logic_vector(3 downto 0);    --2nd from left digit
        digit1: in std_logic_vector(3 downto 0);    --3rd from left digit
        digit0: in std_logic_vector(3 downto 0);    --rightmost digit

        blank3: in std_logic;    --leftmost digit
        blank2: in std_logic;    --2nd from left digit
        blank1: in std_logic;    --3rd from left digit
        blank0: in std_logic;    --rightmost digit

        sevenSegs: out std_logic_vector(6 downto 0);    --MSB=g, LSB=a
        anodes:    out std_logic_vector(3 downto 0)    --MSB=leftmost digit
    );
end SevenSegmentDriver;



architecture SevenSegmentDriver_ARCH of SevenSegmentDriver is

    ----general definitions----------------------------------------------CONSTANTS
    constant ACTIVE: std_logic := '1';
    constant COUNT_1KHZ: integer := 100000000/1000;

    ----anode settings for digit selection-------------------------------CONSTANTS
    constant SELECT_DIGIT_0: std_logic_vector(3 downto 0)   := "1110";
    constant SELECT_DIGIT_1: std_logic_vector(3 downto 0)   := "1101";
    constant SELECT_NO_DIGITS: std_logic_vector(3 downto 0) := "1111";

    ----normal seven segment display-------------------------------------CONSTANTS
    constant ZERO_7SEG: std_logic_vector(6 downto 0)  := "1000000";
    constant ONE_7SEG: std_logic_vector(6 downto 0)   := "1111001";
    constant TWO_7SEG: std_logic_vector(6 downto 0)   := "0100100";
    constant THREE_7SEG: std_logic_vector(6 downto 0) := "0110000";
    constant FOUR_7SEG: std_logic_vector(6 downto 0)  := "0011001";
    constant FIVE_7SEG: std_logic_vector(6 downto 0)  := "0010010";
    constant SIX_7SEG: std_logic_vector(6 downto 0)   := "0000010";
    constant SEVEN_7SEG: std_logic_vector(6 downto 0) := "1111000";
    constant EIGHT_7SEG: std_logic_vector(6 downto 0) := "0000000";
    constant NINE_7SEG: std_logic_vector(6 downto 0)  := "0011000";

    ----internal connections-----------------------------------------------SIGNALS
    signal enableCount: std_logic;
    signal selectedBlank: std_logic;
    signal selectedDigit: std_logic_vector(3 downto 0);
    signal digitSelect: unsigned(1 downto 0);

begin
    --============================================================================
    --  Convert 4-bit binary value into its equivalent 7-segment pattern
    --============================================================================
    BINARY_TO_7SEG: with selectedDigit select
        sevenSegs <= ZERO_7SEG  when "0000",
                     ONE_7SEG   when "0001",
                     TWO_7SEG   when "0010",
                     THREE_7SEG when "0011",
                     FOUR_7SEG  when "0100",
                     FIVE_7SEG  when "0101",
                     SIX_7SEG   when "0110",
                     SEVEN_7SEG when "0111",
                     EIGHT_7SEG when "1000",
                     NINE_7SEG  when others;

    --============================================================================
    --  Select the current digit to display
    --============================================================================
    DIGIT_SELECT: with digitSelect select
        selectedDigit <= digit0 when "00",
                         digit1 when others;


    --============================================================================
    --  Select the current digit to display
    --============================================================================
    BLANK_SELECT: with digitSelect select
        selectedBlank <= blank0 when "00",
                         blank1 when "01",
                         blank2 when "10",
                         blank3 when others;


    --============================================================================
    --  Select the current digit in the seven-segment display unless the
    --  selectedBlank input is active.
    --============================================================================
    ANODE_SELECT: process(selectedBlank, digitSelect)
    begin
        if (selectedBlank = ACTIVE) then
            anodes <= SELECT_NO_DIGITS;
        else
            case digitSelect is
                when "00" =>    anodes <= SELECT_DIGIT_0;
                when others =>    anodes <= SELECT_DIGIT_1;
            end case;
        end if;
    end process ANODE_SELECT;


    --============================================================================
    --  Set the scan rate for the multiplexed seven-segment displays to 1 kHz.
    --  The enableCount output pulses for one clock cycle at a rate of 1 kHz.
    --============================================================================
    SCAN_RATE: process(reset, clock)
        variable count: integer range 0 to COUNT_1KHZ;
    begin
        enableCount <= not ACTIVE;  --default value unless count reaches terminal
        if (reset = ACTIVE) then
            count := 0;
        elsif (rising_edge(clock)) then
            if (count = COUNT_1KHZ) then
                count := 0;
                enableCount <= ACTIVE;
            else
                count := count + 1;
            end if;
        end if;
    end process SCAN_RATE;


    --============================================================================
    --  Generates the digit selection value
    --============================================================================
    DIGIT_COUNT: process(reset, clock)
    begin
        if (reset = ACTIVE) then
            digitSelect <= "00";
        elsif (rising_edge(clock)) then
            if (enableCount = ACTIVE) then
                digitSelect <= digitSelect + 1;
            end if;
        end if;
    end process DIGIT_COUNT;
    
    


end SevenSegmentDriver_ARCH;