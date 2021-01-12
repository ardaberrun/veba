--  vebaCPU-testbench

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use std.textio.all;
use ieee.std_logic_textio.all; 

entity cpu_tb is
end;

architecture veba of cpu_tb is

  component cpu
     port
     (
        clock          : in   std_logic;
        data           : in   std_logic_vector (7 downto 0); 
        alu_select     : in   std_logic_vector(4 downto 0);
        write_address  : in   integer range 0 to 31;
        read_address   : in   integer range 0 to 31;
        q              : out  std_logic_vector (7 downto 0) 
     );
  end component;
  

  file test_results : text;

  signal clock: std_logic;
  signal data: std_logic_vector (7 downto 0);
  signal alu_select: std_logic_vector(4 downto 0);
  signal write_address: integer range 0 to 31;
  signal read_address: integer range 0 to 31;

  signal q : std_logic_vector (7 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: cpu port map ( 	     clock         => clock,
                             data          => data,
                             alu_select    => alu_select,
                             write_address => write_address,
                             read_address  => read_address,
                             q             => q );

  process
  
  variable o_line : line;
  
  begin
  
		--file_open(test_results,"C:\Users\xxdqw\out.txt",write_mode);
		
		-- file_open(test_results, YOUR_PATH , write_mode);

  
    		-- reg1 = data
		data <= "00111010";
		alu_select <= "00001";
			
		wait for clock_period;
	
		-- reg2 = data
		data <= "01001100";
		alu_select <= "00010";
			
		wait for clock_period;
		
		-- the value of reg1 is written to address 0		
		write_address <= 0;
   		alu_select <= "00011";
		
		wait for clock_period;
		
		-- the value of reg1 is written to address 1		
		write_address <= 1;
   		alu_select <= "00100";
		
		wait for clock_period;
		-- the value of reg2 has been written to reg1	
   		alu_select <= "00101";
		
		wait for clock_period;
		-- the value of reg1 is written to address 2			
		write_address <= 2;
   		alu_select <= "00011";
		
		wait for clock_period;	
  		-- the value of reg1 is updated
		data <= "00111010";
		alu_select <= "00001";
		
		wait for clock_period;
		-- the value of reg1 has been written to reg2	 	

   		alu_select <= "00110";
		
		wait for clock_period;
		-- -- the value of reg2 is written to address 3			
		write_address <= 3;
   		alu_select <= "00100";
		
		wait for clock_period;
	
		-- the value of reg2 is updated
		data <= "01001100";
		alu_select <= "00010";
					
		wait for clock_period;		

		read_address <= 1; -- the value in address one is written to reg1
		alu_select <= "00111";	
			
		wait for clock_period;		
		-- the value in address zero is written to reg2
		read_address <= 0; -- 00111010
		alu_select <= "01000";	
		
		wait for clock_period;

		-- update the data for the next steps
		data <= "00000010";


		-- arithmetic and logic operations are performed. and it is written to address i+1 in the ram
		for i in 5 to 22 loop
	
			write_address <= i+1;
			alu_select <= alu_select + "00001";
		
		wait for clock_period;
		
		end loop;
	
		wait for clock_period;
		--  the value of reg1 is written to address 29	
		write_address <= 29;
   		alu_select <= "00011";
		
		
		wait for clock_period;
		--  the value of reg2 is written to address 30	
		write_address <= 30;
		alu_select <= "00100";
		

		wait for clock_period;

		alu_select <= "11011";
	
		-- the value at the i.nth address is transferred to the q ...
		for i in 0 to 32 loop	
	
			wait for clock_period;	
	
			read_address <= i;
			
			wait for clock_period;
		
			write(o_line, read_address,right);
			write(o_line,string'("   "));
			write(o_line, q);
			writeline(test_results, o_line);
		end loop;
	
	 	file_close(test_results);

    		stop_the_clock <= true;
   	 wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clock <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;
  
