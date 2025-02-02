-- In this version scancode is read on the negative edge of kbclock.
-- It counts the number of negative edges. IF 11 edges are detected the byte is read and byte_read is '1'.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY showkey IS
  PORT (
    reset     : in std_logic;
    kbclock   : IN STD_LOGIC; -- low freq. clk (~ 20 kHz) from keyboard
    kbdata    : IN STD_LOGIC; -- serial data from the keyboard
    dig0, dig1: OUT std_logic_vector(6 DOWNTO 0); -- show key pressed on display in Hex dig1 (upper 4 bits) dig0 (lower 4 bits)
    scancode  : OUT std_logic_vector(7 DOWNTO 0);
    byte_read : OUT std_logic
    );
END showkey;

ARcHITECTURE behaviour OF showkey IS
	SIGNAL keycode : std_logic_vector(7 downto 0) := (OTHERS => '0');
	SIGNAL bitcnt  : std_logic_vector(3 downto 0) := (OTHERS => '0');
BEGIN

	PROCESS(reset,kbclock)
	BEGIN
		IF reset='0' THEN    -- for the DE1-SoC board it must be ‘0’!
			keycode <= (OTHERS => '0');
			bitcnt  <= (OTHERS => '0');
		ELSIF falling_edge(kbclock) THEN
			byte_read <= '0';
			keycode(0)  <= kbdata;
			keycode <= std_logic_vector( shift_right(unsigned(keycode),1));
			
			IF bitcnt = "1000" THEN
				scancode <= keycode;
				byte_read <= '1';
				bitcnt <= "0000";
			ELSE
				bitcnt <= std_logic_vector(unsigned(bitcnt) + 1);
			END IF;
		END IF;
	END PROCESS;

	
END;