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


entity ADV_SwitchCount is
port(
        clk: in std_logic;        
        seg: out std_logic_vector(6 downto 0);      --MSB=g, LSB=a
        an:    out std_logic_vector(3 downto 0);        --MSB=leftmost digit
        led: out std_logic_vector(15 downto 0);          --LED Array
        sw: in std_logic_vector(15 downto 0)             --Switch Array
    );
end ADV_SwitchCount;

architecture ADV_SwitchCount_ARCH of ADV_SwitchCount is

  ----general definitions----------------------------------------------CONSTANTS
    constant ACTIVE: std_logic := '1';
    constant SWITCH_ON: std_logic := '1';
    constant LED_ON: std_logic := '1';
    constant RIGHT_SEG: std_logic_vector(3 downto 0) := "0001";
    constant ENABLE_DIGIT: std_logic := '0';
    constant DISABLE_DIGIT: std_logic := '1';
    constant DISABLE_RESET: std_logic := '0';
    
    ----LEDs------------------------------------------------------------CONSTANTS
    constant LED_0: std_logic_vector(15 downto 0) := "0000000000000000";
    constant LED_1: std_logic_vector(15 downto 0) := "0000000000000001";
    constant LED_2: std_logic_vector(15 downto 0) := "0000000000000011";
    constant LED_3: std_logic_vector(15 downto 0) := "0000000000000111";
    constant LED_4: std_logic_vector(15 downto 0) := "0000000000001111";
    constant LED_5: std_logic_vector(15 downto 0) := "0000000000011111";
    constant LED_6: std_logic_vector(15 downto 0) := "0000000000111111";
    constant LED_7: std_logic_vector(15 downto 0) := "0000000001111111";
    constant LED_8: std_logic_vector(15 downto 0) := "0000000011111111";
    constant LED_9: std_logic_vector(15 downto 0) := "0000000111111111";
    constant LED_10: std_logic_vector(15 downto 0) := "0000001111111111";
    constant LED_11: std_logic_vector(15 downto 0) := "0000011111111111";
    constant LED_12: std_logic_vector(15 downto 0) := "0000111111111111";
    constant LED_13: std_logic_vector(15 downto 0) := "0001111111111111";
    constant LED_14: std_logic_vector(15 downto 0) := "0011111111111111";
    constant LED_15: std_logic_vector(15 downto 0) := "0111111111111111";
    constant LED_16: std_logic_vector(15 downto 0) := "1111111111111111";
    
    
    
    ----normal-seven-segment-display----------------------------------CONSTANTS
    constant ZERO_7SEG:  std_logic_vector(3 downto 0) := "0000";
    constant ONE_7SEG:   std_logic_vector(3 downto 0) := "0001";
    constant TWO_7SEG:   std_logic_vector(3 downto 0) := "0010";
    constant THREE_7SEG: std_logic_vector(3 downto 0) := "0011";
    constant FOUR_7SEG:  std_logic_vector(3 downto 0) := "0100";
    constant FIVE_7SEG:  std_logic_vector(3 downto 0) := "0101";
    constant SIX_7SEG:   std_logic_vector(3 downto 0) := "0110";
    constant SEVEN_7SEG: std_logic_vector(3 downto 0) := "0111";
    constant EIGHT_7SEG: std_logic_vector(3 downto 0) := "1000";
    constant NINE_7SEG:  std_logic_vector(3 downto 0)  := "1001";
    
    --Signals
    signal digitalBlank1: std_logic;
    signal digitValue0: std_logic_vector(3 downto 0);
        
    component SevenSegmentDriver
        port(
                reset: in std_logic;
                clock: in std_logic;
                
                blank3: in std_logic;    --leftmost digit
                blank2: in std_logic;    --2nd from left digit
                
                
                digit1: in std_logic_vector(3 downto 0);
                digit0: in std_logic_vector(3 downto 0); 
                
                blank1: in std_logic;
                blank0: in std_logic;
                
                sevenSegs: out std_logic_vector(6 downto 0);
                anodes: out std_logic_vector(3 downto 0)
            );
    end component;

begin

    my_SEG: SevenSegmentDriver port map(
                reset => DISABLE_RESET,
                clock => clk,
                
                digit1 => RIGHT_SEG,
                digit0 => digitValue0,
                
                blank3 => DISABLE_DIGIT,
                blank2 => DISABLE_DIGIT,
                blank1 => digitalBlank1,
                blank0 => ENABLE_DIGIT,
                
                sevenSegs => seg,
                anodes => an
    );                   
 
    --Update bar display based on switches pressed---------------------PROCESS----
        SWITCH_COUNT: process(sw)
            variable count: integer range 0 to 16;
            variable value: integer range 0 to 9;    
        begin
            
            --Count the number of switches pressed--------------------------------
            count := 0;
            if (sw(0) = SWITCH_ON) then 
                count := count + 1;
            end if;
            if (sw(1) = SWITCH_ON) then 
                count := count + 1;
            end if;
            if (sw(2) = SWITCH_ON) then 
                count := count + 1;
            end if;
            if (sw(3) = SWITCH_ON) then 
                count := count + 1;
            end if;
            if (sw(4) = SWITCH_ON) then 
                count := count + 1;
            end if;
            if (sw(5) = SWITCH_ON) then 
                count := count + 1;
            end if;
            if (sw(6) = SWITCH_ON) then 
                count := count + 1;
            end if;
            if (sw(7) = SWITCH_ON) then 
                count := count + 1;
            end if;
            if (sw(8) = SWITCH_ON) then 
                count := count + 1;
            end if;
            if (sw(9) = SWITCH_ON) then 
                count := count + 1;
            end if;
            if (sw(10) = SWITCH_ON) then 
                count := count + 1;
            end if;
            if (sw(11) = SWITCH_ON) then 
                count := count + 1;
            end if;
            if (sw(12) = SWITCH_ON) then 
                count := count + 1;
            end if;
            if (sw(13) = SWITCH_ON) then 
                count := count + 1;
            end if;
            if (sw(14) = SWITCH_ON) then 
                count := count + 1;
            end if;
            if (sw(15) = SWITCH_ON) then 
                count := count + 1;
            end if;
            if (count > 9) then
                digitalBlank1 <= ENABLE_DIGIT;
                value := count - 10;
            else 
                digitalBlank1 <= DISABLE_DIGIT;
                value := count;
            end if;
            
            -- case statement: deciding which value to display
    case count is
        when 0 => 
            led <= LED_0;
        when 1 => 
            led <= LED_1;
        when 2 => 
            led <= LED_2;
        when 3 => 
            led <= LED_3;
        when 4 => 
            led <= LED_4;
        when 5 => 
            led <= LED_5;
        when 6 => 
            led <= LED_6;
        when 7 => 
            led <= LED_7;
        when 8 => 
            led <= LED_8;
        when 9 => 
            led <= LED_9;
        when 10 => 
            led <= LED_10;
        when 11 => 
            led <= LED_11; 
        when 12 => 
            led <= LED_12;
        when 13 => 
            led <= LED_13;
        when 14 => 
            led <= LED_14;
        when 15 => 
            led <= LED_15;
        when others => 
            led <= LED_16;   
    end case;
            
            case value is 
            when 0 => 
                digitValue0 <= ZERO_7SEG; -- "0"
            when 1 => 
                digitValue0 <= ONE_7SEG; -- "1" 
            when 2 => 
                digitValue0 <= TWO_7SEG; -- "2"
            when 3 => 
                digitValue0 <= THREE_7SEG; -- "3" 
            when 4 => 
                digitValue0 <= FOUR_7SEG; -- "4"
            when 5 => 
                digitValue0 <= FIVE_7SEG; -- "5"
            when 6 => 
                digitValue0 <= SIX_7SEG; -- "6"
            when 7 => 
                digitValue0 <= SEVEN_7SEG; -- "7"
            when 8 => 
                digitValue0 <= EIGHT_7SEG; -- "8"
            when others => 
                digitValue0 <= NINE_7SEG; -- "9"     
            end case;
        end process SWITCH_COUNT;
end ADV_SwitchCount_ARCH;
