LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY buttonss IS
    PORT (
        clk   : IN std_logic;
        reset : IN std_logic;
        button1, button2, button3 : IN std_logic;
        switch0, switch1, switch2, switch3 : IN std_logic;
        dig0, dig1, dig2, dig3, dig4, dig5: OUT std_logic_vector(6 DOWNTO 0);
        binaryValue: OUT std_logic_vector(15 DOWNTO 0)
    );
END buttonss;

ARCHITECTURE bhv OF buttonss IS
    constant countEnd : natural := 10;
    signal currentDisplay: integer range 0 to 5 := 0;
    signal count : integer range 0 to countEnd - 1 := 0;
    signal temp0, temp3, temp4 : std_logic_vector(3 DOWNTO 0) := "0000";
    signal temp1, temp2, temp5 : std_logic_vector(3 DOWNTO 0) := "0000";
    signal prev_button1, prev_button2, prev_button3: std_logic := '0';
    signal decimalValue: integer range -999999 to 999999 := 0;

    FUNCTION hex2display(n: std_logic_vector(3 DOWNTO 0)) RETURN std_logic_vector IS
    BEGIN
        CASE n IS
            WHEN "0000" => RETURN NOT "0111111";
            WHEN "0001" => RETURN NOT "0000110";
            WHEN "0010" => RETURN NOT "1011011";
            WHEN "0011" => RETURN NOT "1001111";
            WHEN "0100" => RETURN NOT "1100110";
            WHEN "0101" => RETURN NOT "1101101";
            WHEN "0110" => RETURN NOT "1111101";
            WHEN "0111" => RETURN NOT "0000111";
            WHEN "1000" => RETURN NOT "1111111";
            WHEN "1001" => RETURN NOT "1101111";
            WHEN OTHERS => RETURN NOT "1110001";
        END CASE;
    END hex2display;

BEGIN
    dig0 <= hex2display(temp0);
    dig1 <= hex2display(temp1);
    dig2 <= hex2display(temp2);
    dig3 <= hex2display(temp3);
    dig4 <= hex2display(temp4);
    dig5 <= hex2display(temp5);

    PROCESS(clk, reset)
    BEGIN
        IF reset = '0' THEN
            count <= 0;
            currentDisplay <= 0;
            temp0 <= "0000";
            temp1 <= "0000";
            temp2 <= "0000";
            temp3 <= "0000";
            temp4 <= "0000";
            temp5 <= "0000";
            decimalValue <= 0;
        ELSIF rising_edge(clk) THEN
            IF button1 = '0' AND prev_button1 = '1' THEN
                count <= (count + 1) mod countEnd;
                CASE currentDisplay IS
                    WHEN 0 => temp0 <= std_logic_vector(to_unsigned(count, 4));
                    WHEN 1 => temp1 <= std_logic_vector(to_unsigned(count, 4));
                    WHEN 2 => temp2 <= std_logic_vector(to_unsigned(count, 4));
                    WHEN 3 => temp3 <= std_logic_vector(to_unsigned(count, 4));
                    WHEN 4 => temp4 <= std_logic_vector(to_unsigned(count, 4));
                    WHEN 5 => temp5 <= std_logic_vector(to_unsigned(count, 4));
                    WHEN OTHERS => NULL;
                END CASE;
            END IF;
            prev_button1 <= button1;

            IF button2 = '0' AND prev_button2 = '1' THEN
                currentDisplay <= (currentDisplay + 1) mod 6;
                count <= 0;  -- Reset the counter for the new display
            END IF;
            prev_button2 <= button2;

            IF button3 = '0' AND prev_button3 = '1' THEN
                -- Store the decimal value
                decimalValue <= to_integer(unsigned(temp5)) * 100000
                             + to_integer(unsigned(temp4)) * 10000
                             + to_integer(unsigned(temp3)) * 1000
                             + to_integer(unsigned(temp2)) * 100
                             + to_integer(unsigned(temp1)) * 10
                             + to_integer(unsigned(temp0));

                -- Check if switch1 is ON for negative value
                IF switch1 = '1' THEN
                    decimalValue <= -decimalValue;
                END IF;

                -- Convert the decimal value to 16-bit binary with sign extension
                IF decimalValue < 0 THEN
                    binaryValue <= std_logic_vector(to_unsigned(decimalValue, 16));
                ELSE
                    binaryValue <= std_logic_vector(to_unsigned(decimalValue, 16));
                END IF;
						
                -- Reset the counter and hex displays to zero
               -- count <= 0;
                --temp0 <= "0000";
                --temp1 <= "0000";
                --temp2 <= "0000";
                --temp3 <= "0000";
                --temp4 <= "0000";
                --temp5 <= "0000";
            END IF;
            prev_button3 <= button3;
        END IF;
    END PROCESS;
END bhv;
