library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

-- Writing files 
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_axi_burst_lite is       
generic(
C_S_AXI_DATA_WIDTH : integer := 32;
C_S_AXI_ADDR_WIDTH : integer := 32;

C_M_AXI_ADDR_WIDTH   : integer := 32;
C_M_AXI_DATA_WIDTH   : integer := 32;
C_M_AXI_BURST_LEN	 : integer	:= 32;   -- as we are dealing with debug dma (for generic approach have to come up with logic)
C_M_AXI_ID_WIDTH	 : integer	:= 1;
C_M_AXI_AWUSER_WIDTH : integer	:= 1;
C_M_AXI_ARUSER_WIDTH : integer	:= 1;
C_M_AXI_WUSER_WIDTH	 : integer	:= 1;
C_M_AXI_RUSER_WIDTH	 : integer	:= 1;
C_M_AXI_BUSER_WIDTH	 : integer	:=1
);
--  Port ( );
end tb_axi_burst_lite;

architecture Behavioral of tb_axi_burst_lite is

--  -------------------------------------------------------------
--      --------  Signal Declaration ---------
-- --------------------------------------------------------------
    signal S_AXI_ACLK                     :  std_logic :=   '1'; 
    signal S_AXI_ARESETN                  :  std_logic;
    signal S_AXI_AWADDR                   :  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal S_AXI_AWPROT 			  	  :	 std_logic_vector(2 downto 0) := "000";	
    signal S_AXI_AWVALID                  :  std_logic;
	signal S_AXI_AWREADY			      :  std_logic;
	signal S_AXI_WDATA					  :  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal S_AXI_WSTRB					  :  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
	signal S_AXI_WVALID					  :  std_logic;
	signal S_AXI_WREADY					  :  std_logic;
	signal S_AXI_BRESP					  :  std_logic_vector(1 downto 0);
	signal S_AXI_BVALID					  :  std_logic;
	signal S_AXI_BREADY					  :  std_logic;
	signal S_AXI_ARADDR					  :  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal S_AXI_ARPROT					  :  std_logic_vector(2 downto 0);
	signal S_AXI_ARVALID				  :  std_logic;
	signal S_AXI_ARREADY				  :  std_logic;
	signal S_AXI_RDATA					  :  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal S_AXI_RRESP					  :  std_logic_vector(1 downto 0);
	signal S_AXI_RVALID					  :  std_logic;
	signal S_AXI_RREADY					  :  std_logic;

	
	signal S_M00_axi_0_awprot	: std_logic_vector(2 downto 0);
	signal S_M00_axi_0_awaddr	:  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal S_M00_axi_0_awvalid	:  std_logic;
	signal S_M00_axi_0_awready	:  std_logic;
	signal S_M00_axi_0_wdata	:  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal S_M00_axi_0_wstrb	:  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
	signal S_M00_axi_0_wvalid	:  std_logic;
	signal S_M00_axi_0_wready	:  std_logic;
	signal S_M00_axi_0_bresp	:  std_logic_vector(1 downto 0);
	signal S_M00_axi_0_bvalid	:  std_logic;
	signal S_M00_axi_0_bready	:  std_logic;
	signal S_M00_axi_0_araddr	:  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal S_M00_axi_0_arprot	:  std_logic_vector(2 downto 0);
	signal S_M00_axi_0_arvalid	:  std_logic;
	signal S_M00_axi_0_arready	:  std_logic;
	signal S_M00_axi_0_rdata	:  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal S_M00_axi_0_rresp	:  std_logic_vector(1 downto 0);
	signal S_M00_axi_0_rvalid	:  std_logic;
	signal S_M00_axi_0_rready	:  std_logic;
	
	
	-- Signal for AXI_FULL
	signal S_M01_AXI_ARID	:  std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
	signal S_M01_AXI_ARADDR	:  std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
	signal S_M01_AXI_ARLEN	:  std_logic_vector(7 downto 0);
	signal S_M01_AXI_ARSIZE	:  std_logic_vector(2 downto 0);
	signal S_M01_AXI_ARBURST	:  std_logic_vector(1 downto 0);
	signal S_M01_AXI_ARLOCK	:  std_logic;
	signal S_M01_AXI_ARCACHE	:  std_logic_vector(3 downto 0);
	signal S_M01_AXI_ARPROT	:  std_logic_vector(2 downto 0);
	signal S_M01_AXI_ARQOS	:  std_logic_vector(3 downto 0);
	signal S_M01_AXI_ARUSER	:  std_logic_vector(C_M_AXI_ARUSER_WIDTH-1 downto 0);
	signal S_M01_AXI_ARVALID	:  std_logic;
	signal S_M01_AXI_ARREADY	:  std_logic;
	signal S_M01_AXI_RID	:  std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
	signal S_M01_AXI_RDATA	:  std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
	signal S_M01_AXI_RRESP	:  std_logic_vector(1 downto 0);
	signal S_M01_AXI_RLAST	:  std_logic;
	signal S_M01_AXI_RUSER	:  std_logic_vector(C_M_AXI_RUSER_WIDTH-1 downto 0);
	signal S_M01_AXI_RVALID	:  std_logic;
	signal S_M01_AXI_RREADY	:  std_logic;
	
	-- my signal s
	signal tb_readFile, tb_readAddressFile	:  std_logic;
		
-- Clock Decleration
constant ClockPeriod : Time := 10 ns;
shared variable ClockCount : integer range 0 to 50_000 := 10;
signal sendIt : std_logic := '0';
signal readIt : std_logic := '0';
signal clk	: std_logic := '1';

--declaration of clock signal ends here

shared variable var_string1, var_string2 : integer;
shared variable time_value : time;
signal sig_string1, sig_string2 : std_logic_vector(31 downto 0);

signal sig_data: integer;
signal sig_count_en, sig_dataRead : STD_LOGIC;
signal tb_sig_count,tb_sig_test : STD_LOGIC_VECTOR(7 downto 0) := (others=>'0'); 
signal sig_i : STD_LOGIC_VECTOR(7 downto 0) := (others=>'0'); 
signal tb_beatDone : std_logic;

signal data_in          : STD_LOGIC_VECTOR(31 downto 0);
signal adr              : STD_LOGIC_VECTOR(31 downto 0) := (others => '0'); 
signal radr             : STD_LOGIC_VECTOR(31 downto 0) := (others => '0'); 
signal wstrb            : STD_LOGIC_VECTOR(3 downto 0);

begin

AWPROT_module_inst : entity work.awprot 

generic map (   
        C_S_AXI_DATA_WIDTH => C_S_AXI_DATA_WIDTH,
        C_S_AXI_ADDR_WIDTH => C_S_AXI_ADDR_WIDTH,
		
		C_M_AXI_ADDR_WIDTH => C_M_AXI_ADDR_WIDTH,
		C_M_AXI_DATA_WIDTH => C_M_AXI_DATA_WIDTH,
		C_M_AXI_BURST_LEN  => C_M_AXI_BURST_LEN,	
		C_M_AXI_ID_WIDTH   => C_M_AXI_ID_WIDTH,	 
		C_M_AXI_AWUSER_WIDTH => C_M_AXI_AWUSER_WIDTH, 
		C_M_AXI_ARUSER_WIDTH => C_M_AXI_ARUSER_WIDTH,
		C_M_AXI_WUSER_WIDTH	 => C_M_AXI_WUSER_WIDTH,
		C_M_AXI_RUSER_WIDTH	 => C_M_AXI_RUSER_WIDTH,
		C_M_AXI_BUSER_WIDTH	 => C_M_AXI_BUSER_WIDTH
    )
    port map (
	
       aclk_0    		 	 => S_AXI_ACLK,
       aresetn_0 		 	 => S_AXI_ARESETN,
       S00_AXI_REG_0_AWPROT  => S_AXI_AWPROT,
       S00_AXI_REG_0_AWADDR  => S_AXI_AWADDR,
       --s00_AXI_REG_awprot  => S_AXI_AWPROT,
       S00_AXI_REG_0_AWVALID => S_AXI_AWVALID,
       S00_AXI_REG_0_AWREADY => S_AXI_AWREADY,
       S00_AXI_REG_0_WDATA   => S_AXI_WDATA,
       S00_AXI_REG_0_WSTRB   => S_AXI_WSTRB,
       S00_AXI_REG_0_WVALID  => S_AXI_WVALID,
       S00_AXI_REG_0_WREADY  => S_AXI_WREADY,
       S00_AXI_REG_0_BRESP   => S_AXI_BRESP,
       S00_AXI_REG_0_BVALID  => S_AXI_BVALID,
       S00_AXI_REG_0_BREADY  => S_AXI_BREADY,
       S00_AXI_REG_0_ARADDR  => S_AXI_ARADDR,
       S00_AXI_REG_0_ARPROT  => S_AXI_ARPROT,
       S00_AXI_REG_0_ARVALID => S_AXI_ARVALID,
       S00_AXI_REG_0_ARREADY => S_AXI_ARREADY,
       S00_AXI_REG_0_RDATA   => S_AXI_RDATA,
       S00_AXI_REG_0_RRESP   => S_AXI_RRESP,
       S00_AXI_REG_0_RVALID  => S_AXI_RVALID,
       S00_AXI_REG_0_RREADY  => S_AXI_RREADY, 
	   
	   
		M00_axi_0_awprot	=> S_M00_axi_0_awprot, 
                        
		M00_axi_0_awaddr => S_M00_axi_0_awaddr,	
		M00_axi_0_awvalid => S_M00_axi_0_awvalid,
		M00_axi_0_awready => S_M00_axi_0_awready,	
		M00_axi_0_wdata	=>	S_M00_axi_0_wdata,
		M00_axi_0_wstrb	=>	S_M00_axi_0_wstrb,
		M00_axi_0_wvalid =>	S_M00_axi_0_wvalid,
		M00_axi_0_wready => S_M00_axi_0_wready,
		M00_axi_0_bresp	=>	S_M00_axi_0_bresp,
		M00_axi_0_bvalid =>	S_M00_axi_0_bvalid,
		M00_axi_0_bready =>	S_M00_axi_0_bready,
		M00_axi_0_araddr =>	S_M00_axi_0_araddr,
		M00_axi_0_arprot =>	S_M00_axi_0_arprot,
		M00_axi_0_arvalid => S_M00_axi_0_arvalid,	
		M00_axi_0_arready => S_M00_axi_0_arready,	
		M00_axi_0_rdata	=>	S_M00_axi_0_rdata,
		M00_axi_0_rresp	=>	S_M00_axi_0_rresp,
		M00_axi_0_rvalid =>	S_M00_axi_0_rvalid,
		M00_axi_0_rready =>	S_M00_axi_0_rready,
		
		
		-- PortMap of AXI Full
		M01_AXI_ARID	=> S_M01_AXI_ARID, 
		M01_AXI_ARADDR	=> S_M01_AXI_ARADDR, 
		M01_AXI_ARLEN	=> S_M01_AXI_ARLEN,
		M01_AXI_ARSIZE	=> S_M01_AXI_ARSIZE,
		M01_AXI_ARBURST	=> S_M01_AXI_ARBURST,
		M01_AXI_ARLOCK	=> S_M01_AXI_ARLOCK,
		M01_AXI_ARCACHE => S_M01_AXI_ARCACHE,
		M01_AXI_ARPROT	=> S_M01_AXI_ARPROT,
		M01_AXI_ARQOS	=> S_M01_AXI_ARQOS,
		M01_AXI_ARUSER	=> S_M01_AXI_ARUSER,
		M01_AXI_ARVALID	=> S_M01_AXI_ARVALID,
		M01_AXI_ARREADY	=> S_M01_AXI_ARREADY,
		M01_AXI_RID		=> S_M01_AXI_RID,
		M01_AXI_RDATA	=> S_M01_AXI_RDATA,
		M01_AXI_RRESP	=> S_M01_AXI_RRESP,
		M01_AXI_RLAST	=> S_M01_AXI_RLAST,
		M01_AXI_RUSER	=> S_M01_AXI_RUSER,
		M01_AXI_RVALID	=> S_M01_AXI_RVALID,
		M01_AXI_RREADY	=> S_M01_AXI_RREADY,
		readFile        => tb_readFile,
		readAddressFile => tb_readAddressFile
		);

-- Burst read signls
S_M01_AXI_ARREADY <= '1';
S_M01_AXI_RREADY <= '1';
S_M01_AXI_RVALID <= '1';

-- Generate S_AXI_ACLK signal 
GENERATE_REF_CLOCK : process
begin
    wait for(ClockPeriod/2);
    ClockCount := ClockCount + 1;
    S_AXI_ACLK <= '1';
    wait for (ClockPeriod/2);
    S_AXI_ACLK <= '0';
end process;  

RESET_GENERATOR: process
begin 
    S_AXI_ARESETN <= '0';
    wait for 50 ns;
    S_AXI_ARESETN <= '1';
    wait;
end process;

-- This Process resembels the AXI-Lite protocol
AXI_LITE_PROCESS: process
begin 
if S_AXI_ARESETN = '0' then
    S_AXI_WVALID <= '0';
    S_AXI_WVALID <= '0';
    S_AXI_BREADY <= '0';
    S_AXI_AWPROT <= "000";
else
    loop
        S_AXI_AWVALID <= '1';
        S_AXI_WVALID <= '1';
        S_AXI_AWPROT <= "000";
        wait until (S_AXI_AWREADY and S_AXI_WREADY) = '1';
        S_AXI_BREADY<='1';
        wait until S_AXI_BVALID = '1' ;  -- Write result valid
            assert S_AXI_BRESP = "00" report "AXI data written" severity failure;
        S_AXI_BREADY<='0';
        --S_AXI_AWVALID <= '0';
        --S_AXI_WVALID <= '0';
     end loop;
end if;
end process;


-- Reads a text file located at the path mentioned below
-- Text files has address and data just like DDR memory
readback_textfile: process(S_AXI_ACLK)
file lf : text open read_mode is "C:/projects/prc_usp_axi_burst/prc_usp_axi_burst/log_counter.txt";
variable var_string3 : time;
variable row : line;
variable addr, data : STD_LOGIC_VECTOR(31 downto 0);
variable varCount : STD_LOGIC_VECTOR(7 downto 0) := (others=>'0'); 
variable i : STD_LOGIC_VECTOR(7 downto 0) := (others=>'0');
variable var_dataRead : std_logic;
variable var_addCount : integer := 0;
begin


-- Reading a file 
if rising_edge(S_AXI_ACLK) then 
	if tb_readFile = '1' then
		if not endfile(lf) then
			varCount := varCount + "00000001";
			if varCount = S_M01_AXI_ARLEN then
			  S_M01_AXI_RLAST <= '1';
			  varCount := "00000000";
			else
			   S_M01_AXI_RLAST <= '0';
			end if;
			
			readline(lf,row);
            read(row,var_string3);
            hread(row,addr);
            hread(row,data);
            adr <= addr;
            S_M01_AXI_RDATA <= data;		
		else
			S_M01_AXI_RLAST <= '1';
			tb_beatDone <= '1';
			varCount := "00000000";
			file_close(lf);
		end if;	
   end if;
end if;

 end process;


-- Stumuli just like the PRC configuration 
-- At last is the SW_Trigger
STIMULI_GEN_WRITE : process
begin

     S_AXI_AWADDR <= x"00000000";
     S_AXI_WDATA <= x"00000000";  --33
     S_AXI_WSTRB <= b"1111";
    
     wait until S_AXI_ARESETN = '1';
      
     S_AXI_AWADDR <= x"44A00000";   -- RP SHIFT CONTROL REGISTER 
     S_AXI_WDATA <= x"00000000";     -- SHUTDOWN PRC
     S_AXI_WSTRB <= b"1111";
     wait until S_AXI_BVALID = '1';
     
     S_AXI_AWADDR <= x"44A000C4";   -- RECONFIGURABLE PARTITION ADDRESS 0 
     S_AXI_WDATA <=  x"05000000";    -- PARTIAL BITSTREAAM LEFT LED ADDRESS
     S_AXI_WSTRB <= b"1111";
     wait until S_AXI_BVALID = '1'; 
     
     S_AXI_AWADDR <= x"44A000D4";   -- RECONFIGURABLE PARTITION ADDRESS 1 
     S_AXI_WDATA <= x"06000000";    -- PARTIAL BITSTREAAM RIGHT LED ADDRESS
     S_AXI_WSTRB <= b"1111";
     wait until S_AXI_BVALID = '1'; 
     
     S_AXI_AWADDR <= x"44A000E4";   -- RECONFIGURABLE PARTITION ADDRESS 2 
     S_AXI_WDATA <= x"06000000";    -- PARTIAL BITSTREAAM BLANK LED ADDRESS
     S_AXI_WSTRB <= b"1111";
     wait until S_AXI_BVALID = '1'; 
      
     S_AXI_AWADDR <= x"44A000C8";  -- RECONFIGURABLE PARTITION BITSTREAM SIZE0
     S_AXI_WDATA <= x"000ABCE0";   -- number of words in hexdecimal
     S_AXI_WSTRB <= b"1111";
     wait until S_AXI_BVALID = '1';
     
     S_AXI_AWADDR <= x"44A000D8";  -- RECONFIGURABLE PARTITION BITSTREAM SIZE1
     S_AXI_WDATA <= x"000ABCE0";   -- number of words in hexdecimal
     S_AXI_WSTRB <= b"1111";
     wait until S_AXI_BVALID = '1';
     
     S_AXI_AWADDR <= x"44A000E8";  -- RECONFIGURABLE PARTITION BITSTREAM SIZE2
     S_AXI_WDATA <= x"000ABCE0";   -- number of words in hexdecimal
     S_AXI_WSTRB <= b"1111";
     wait until S_AXI_BVALID = '1';
     
     S_AXI_AWADDR <= x"44A00040";  -- TRIGGER ID REGISTER FOR RECONFIGURABLE MODULE 
     S_AXI_WDATA <= x"00000000";   -- Trigger value 0 for RM0
     S_AXI_WSTRB <= b"1111";
     wait until S_AXI_BVALID = '1';
     
     S_AXI_AWADDR <= x"44A00044";  -- TRIGGER ID REGISTER FOR RECONFIGURABLE MODULE 
     S_AXI_WDATA <= x"00000001";   -- Trigger value 1 for RM1
     S_AXI_WSTRB <= b"1111";
     wait until S_AXI_BVALID = '1';
     
     S_AXI_AWADDR <= x"44A00048";  -- TRIGGER ID REGISTER FOR RECONFIGURABLE MODULE 
     S_AXI_WDATA <= x"00000002";   -- Trigger value 2 for RM2
     S_AXI_WSTRB <= b"1111";
     wait until S_AXI_BVALID = '1';
     
     S_AXI_AWADDR <= x"44A00080";  -- Initializing RM address registers for Shift RMs
     S_AXI_WDATA <= x"00000000";   -- RM address value 2 for RM2
     S_AXI_WSTRB <= b"1111";
     wait until S_AXI_BVALID = '1';
     
     S_AXI_AWADDR <= x"44A00088";  -- Initializing RM address registers for Shift RMs
     S_AXI_WDATA <= x"00000001";   -- RM address value 2 for RM2
     S_AXI_WSTRB <= b"1111";
     wait until S_AXI_BVALID = '1';
     
     S_AXI_AWADDR <= x"44A00090";  -- Initializing RM address registers for Shift RMs 
     S_AXI_WDATA <= x"00000002";   -- RM address value 2 for RM2
     S_AXI_WSTRB <= b"1111";
     wait until S_AXI_BVALID = '1';
     
     S_AXI_AWADDR <= x"44A00084";  -- Initializing RM control registers for Shift RMs
     S_AXI_WDATA <= x"00000000";   -- RM address value 2 for RM2
     S_AXI_WSTRB <= b"1111";
     wait until S_AXI_BVALID = '1';
     
     S_AXI_AWADDR <= x"44A0008C";  -- Initializing RM control registers for Shift RMs
     S_AXI_WDATA <= x"00000000";   -- RM address value 2 for RM2
     S_AXI_WSTRB <= b"1111";
     wait until S_AXI_BVALID = '1';
     
     S_AXI_AWADDR <= x"44A00094";  -- Initializing RM control registers for Shift RMs 
     S_AXI_WDATA <= x"00000000";   -- RM address value 2 for RM2
     S_AXI_WSTRB <= b"1111";
     wait until S_AXI_BVALID = '1';
     
     
     S_AXI_AWADDR <= x"44A00000";   -- RP SHIFT CONTROL REGISTER 
     S_AXI_WDATA <= x"00000002";     -- RESTART PRC
     S_AXI_WSTRB <= b"1111";
     wait until S_AXI_BVALID = '1';
     
   
     S_AXI_AWADDR <= x"44A00004";   -- RP SOFTWARE TRIGGER  
     S_AXI_WDATA <= x"00000000";     -- LEFT BITSTREAM READ 
     S_AXI_WSTRB <= b"1111";
     
     wait until S_AXI_BVALID = '1';
          
    
end process;
end Behavioral;





-- Ignore below code is for reference
-- old Testbench
     
--     S_AXI_AWADDR <= x"44A00000";
--     S_AXI_WDATA <= x"00080004";  --33
--     S_AXI_WSTRB <= b"1111";     
--     wait until S_AXI_BVALID = '1';
     
--     S_AXI_AWADDR <= x"44A000C4";
--     S_AXI_WDATA <= x"30000000";  --33
--     S_AXI_WSTRB <= b"1111";
--     wait until S_AXI_BVALID = '1'; 
     
--      S_AXI_AWADDR <= x"44A00004";
--     S_AXI_WDATA <= x"40000000";  --33
--     S_AXI_WSTRB <= b"1111";
--     wait until S_AXI_BVALID = '1';

--      S_AXI_AWADDR <= x"44A000D4";
--     S_AXI_WDATA <= x"50000000";  --33
--     S_AXI_WSTRB <= b"1111";
--     wait until S_AXI_BVALID = '1';

-- Reading a file 
--if rising_edge(S_AXI_ACLK) then 
--    if tb_readAddressFile = '1' then
--        if not endfile(lf) then
--            if var_addCount = 0 then
--                readline(lf,row);
--                read(row,var_string3);
--                hread(row,addr);
--                adr <= addr;
--                hread(row,data);           
--                var_sig_dataRead := '1';
--                if S_M01_AXI_ARADDR = addr then
--                    i := i+"00000001";
--                    sig_i <= i;
--                end if;
--                var_addCount := 1;
--            else
--                if S_M01_AXI_ARADDR = addr then
--                    i := i+"00000001";
--                    sig_i <= i;
--                end if; 
                
--                readline(lf,row);
--                read(row,var_string3);
--                hread(row,addr);
--                adr <= addr;
--                hread(row,data); 
--                var_sig_dataRead := '1';
--            end if;
                               
--        else
--            S_M01_AXI_RLAST <= '1';
--			file_close(lf);
--			var_addCount := 0;
--        end if;    
    
--    elsif tb_readFile = '1' then
--		if not endfile(lf) then
--			varCount := varCount + "00000001";
--			tb_sig_count <= varCount;
--			if sig_dataRead = '1' then
--			     S_M01_AXI_RDATA <= data;
--			     sig_dataRead <= '0';
--			else
--			    readline(lf,row);
--                read(row,var_string3);
--                hread(row,addr);
--                hread(row,data);
--                S_M01_AXI_RDATA <= data;
--			end if;
			
--			--tb_sig_test <= S_M01_AXI_ARLEN*i;			
--			if varCount = S_M01_AXI_ARLEN*i then
--			  S_M01_AXI_RLAST <= '1';
--			else
--			  S_M01_AXI_RLAST <= '0';
--			end if;
--	    else
--            S_M01_AXI_RLAST <= '1';
--			varCount := "00000000";
--			tb_sig_count <= varCount;
--			var_addCount := 0;
--			file_close(lf);
--        end if; 
			
--    end if;	
--   end if;

