library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity data_path is
	port(
			--Input
			clk 		: in std_logic;
			rst 		: in std_logic;
			IR_Load 	: in std_logic;
			MAR_Load 	: in std_logic;
			PC_Load 	: in std_logic;
			PC_Inc 		: in std_logic;
			A_Load 		: in std_logic;
			B_Load 		: in std_logic;
			ALU_Sel 	: in std_logic_vector(2 downto 0);
			CCR_Load 	: in std_logic;
			BUS1_Sel 	: in std_logic_vector(1 downto 0);
			BUS2_Sel 	: in std_logic_vector(1 downto 0);
			from_memory : in std_logic_vector(7 downto 0);
			--Output
			IR 			: out std_logic_vector(7 downto 0);
			address 	: out std_logic_vector(7 downto 0);
			CCR_Result 	: out std_logic_vector(3 downto 0);
			to_memory 	: out std_logic_vector(7 downto 0)
	);
end data_path;


architecture arch of data_path is
component ALU is
		port(
				A 			: in std_logic_vector(7 downto 0);
				B 			: in std_logic_vector(7 downto 0);
				ALU_Sel 	: in std_logic_vector(2 downto 0);
				NZVC 		: out std_logic_vector(3 downto 0);
				ALU_result  : out std_logic_vector(7 downto 0)
	);
end component;


--Veri yolu sinyalleri

signal BUS1 		: std_logic_vector(7 downto 0);
signal BUS2 		: std_logic_vector(7 downto 0);
signal ALU_result 	: std_logic_vector(7 downto 0);
signal IR_reg	 	: std_logic_vector(7 downto 0);
signal MAR 			: std_logic_vector(7 downto 0);
signal PC 			: std_logic_vector(7 downto 0);
signal A_reg		: std_logic_vector(7 downto 0);
signal B_reg 		: std_logic_vector(7 downto 0);
signal CCR_in		: std_logic_vector(3 downto 0);
signal CCR 			: std_logic_vector(3 downto 0);

begin

--BUS1 MUX
	BUS1 <= PC when BUS1_Sel<= "00" else
			A_reg when BUS1_Sel <= "01" else
			B_reg when BUS1_Sel <= "10" else (others => '0');
--BUS2 MUX
	BUS2 <= ALU_result when BUS2_Sel<= "00" else
			BUS1 when BUS2_Sel <= "01" else
			from_memory when BUS2_Sel <= "10" else (others => '0');
			
			
--Komut register (IR)
	process(clk,rst)
	begin
		if(rst = '0') then  
			IR_reg <= (others => '0');
		elsif(rising_edge(clk)) then
			if(IR_Load = '1') then
				IR_reg <= BUS2;
			end if;
		end if;
	end process;
IR <= IR_reg;

--Memory Erisim register (MAR)
	process(clk,rst)
	begin
		if(rst = '0') then  
			MAR <= (others => '0');
		elsif(rising_edge(clk)) then
			if(MAR_Load = '1') then
				MAR <= BUS2;
			end if;
		end if;
	end process;
	address <= MAR;
	
	--Program Sayici (PC)
	process(clk,rst)
	begin
		if(rst = '0') then  
			PC <= (others => '0');
		elsif(rising_edge(clk)) then
			if(PC_Load = '1') then
				PC <= BUS2;
			elsif(PC_Load = '1') then
				PC <= PC + x"01";
			end if;
		end if;
	end process;
	
	--A ve B register 
	
	--Memory Erisim register (MAR)
	process(clk,rst)
	begin
		if(rst = '0') then  
			A_reg <= (others => '0');
		elsif(rising_edge(clk)) then
			if(A_Load = '1') then
				A_reg <= BUS2;
			end if;
		end if;
	end process;
	
	process(clk,rst)
	begin
		if(rst = '0') then  
			B_reg <= (others => '0');
		elsif(rising_edge(clk)) then
			if(B_Load = '1') then
				B_reg <= BUS2;
			end if;
		end if;
	end process;
	
	
	--ALU
ALU_U : ALU port map 
					(	
						A => B_reg,
						B => BUS1,
						ALU_Sel => ALU_Sel,
						ALU_result => ALU_result,
						NZVC => CCR_in	
					);
					
					
	--CCR 
	process(clk,rst)
	begin
		if(rst = '0') then  
			CCR <= (others => '0');
		elsif(rising_edge(clk)) then
			if(CCR_Load = '1') then
				CCR <= CCR_in;
			end if;
		end if;
	end process;
	CCR_Result <= CCR;
	
	--Veri yolundan belleğe gidecek sinyal ataması
	to_memory <= BUS1;
	
end architecture;



