library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity awprot is
generic (
		-- Users to add parameters here
        C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 32;
		
		C_M_AXI_ADDR_WIDTH   : integer := 32;
		C_M_AXI_DATA_WIDTH   : integer := 32;
		C_M_AXI_BURST_LEN	 : integer	:= 32; -- as we are dealing with debug dma (for generic approach have to come up with logic)
        C_M_AXI_ID_WIDTH	 : integer	:= 1;
        C_M_AXI_AWUSER_WIDTH : integer	:= 1;
        C_M_AXI_ARUSER_WIDTH : integer	:= 1;
        C_M_AXI_WUSER_WIDTH	 : integer	:= 1;
        C_M_AXI_RUSER_WIDTH	 : integer	:= 1;
        C_M_AXI_BUSER_WIDTH	 : integer	:=1
       
		-- User parameters ends
		-- Do not modify the parameters beyond this line.
);

    Port (  aclk_0	: in std_logic;
            aresetn_0	: in std_logic;
            M00_axi_0_awprot	: out std_logic_vector(2 downto 0);
            
            -- Ports of Axi Slave Bus Interface S00_AXI, LHS ports towards Interconnect
            
            M00_axi_0_awaddr	: out std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
            M00_axi_0_awvalid	: out std_logic;
            M00_axi_0_awready	: in std_logic;
            M00_axi_0_wdata	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) ;
            M00_axi_0_wstrb	: out std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
            M00_axi_0_wvalid	: out std_logic;
            M00_axi_0_wready	: in std_logic;
            M00_axi_0_bresp	: in std_logic_vector(1 downto 0);
            M00_axi_0_bvalid	: in std_logic;
            M00_axi_0_bready	: out std_logic;
            M00_axi_0_araddr	: out std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
            M00_axi_0_arprot	: out std_logic_vector(2 downto 0);
            M00_axi_0_arvalid	: out std_logic;
            M00_axi_0_arready	: in std_logic;
            M00_axi_0_rdata	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            M00_axi_0_rresp	: in std_logic_vector(1 downto 0);
            M00_axi_0_rvalid	: in std_logic;
            M00_axi_0_rready	: out std_logic;
            
         -- RHS port to PRC
			S00_AXI_REG_0_AWPROT	: in std_logic_vector(2 downto 0);
			
            S00_AXI_REG_0_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
			S00_AXI_REG_0_AWVALID	: in std_logic;         
            S00_AXI_REG_0_AWREADY	: out std_logic ;
            S00_AXI_REG_0_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            S00_AXI_REG_0_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
            S00_AXI_REG_0_WVALID	: in std_logic;
            S00_AXI_REG_0_WREADY	: out std_logic;
            S00_AXI_REG_0_BRESP	: out std_logic_vector(1 downto 0);
            S00_AXI_REG_0_BVALID	: out std_logic;
            S00_AXI_REG_0_BREADY	: in std_logic;
            S00_AXI_REG_0_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
            S00_AXI_REG_0_ARPROT	: in std_logic_vector(2 downto 0);
            S00_AXI_REG_0_ARVALID	: in std_logic;
            S00_AXI_REG_0_ARREADY	: out std_logic;
            S00_AXI_REG_0_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            S00_AXI_REG_0_RRESP	: out std_logic_vector(1 downto 0);
            S00_AXI_REG_0_RVALID	: out std_logic;
            S00_AXI_REG_0_RREADY	: in std_logic;
            
            M01_AXI_ARID	: out std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
            M01_AXI_ARADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
            M01_AXI_ARLEN	: out std_logic_vector(7 downto 0);
            M01_AXI_ARSIZE	: out std_logic_vector(2 downto 0);
            M01_AXI_ARBURST	: out std_logic_vector(1 downto 0);
            M01_AXI_ARLOCK	: out std_logic;
            M01_AXI_ARCACHE	: out std_logic_vector(3 downto 0);
            M01_AXI_ARPROT	: out std_logic_vector(2 downto 0);
            M01_AXI_ARQOS	: out std_logic_vector(3 downto 0);
            M01_AXI_ARUSER	: out std_logic_vector(C_M_AXI_ARUSER_WIDTH-1 downto 0);
            M01_AXI_ARVALID	: out std_logic;
            M01_AXI_ARREADY	: in std_logic;
            M01_AXI_RID	: in std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
            M01_AXI_RDATA	: in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
            M01_AXI_RRESP	: in std_logic_vector(1 downto 0);
            M01_AXI_RLAST	: in std_logic;
            M01_AXI_RUSER	: in std_logic_vector(C_M_AXI_RUSER_WIDTH-1 downto 0);
            M01_AXI_RVALID	: in std_logic;
            M01_AXI_RREADY	: out std_logic;
			
			readFile : out std_logic;
			readAddressFile : out std_logic
            );               
end awprot;

architecture Behavioral of awprot is

constant IP_BASE_ADDR   : std_logic_vector(31 downto 0):= x"44A00000";

signal error_signal :  std_logic;
signal axi_awready, axi_bvalid, axi_wready, aw_en : std_logic;
signal axi_bresp : std_logic_vector(1 downto 0);
signal axi_awaddr : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
signal FAR_Check_module_enb : std_logic;
signal sig_BS_length : STD_LOGIC_VECTOR(31 downto 0) := x"0002A538";
signal sig_valid_BS : STD_LOGIC := '0';

signal sig_axi_lite_awaddr :  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
signal sig_S00_AXI_REG_0_BREADY	: std_logic;

type state_type is (AXI_LITE_IDLE,AXI_LITE_INVALID,AXI_LITE_READY,AXI_LITE_TRIGGER_CHECK,AXI_LITE_WRITE_TRANSACTION,AXI_LITE_EXEC,AXI_LITE_WAIT,PRC_TRANS_VALID,PRC_TRANS_ERROR);
signal state : state_type;

type AXI_BURST is (AXI_BURST_IDLE, AXI_BURST_TRIG_ADDR_MAP, AXI_READ_PROCESS,AXI_READ_TRANSACTION,AXI_BURST_BS_READ, AXI_FAR_CHECK, AXI_RTR_CHECK, AXI_BURST_TEMP, AXI_BURST_ERROR_RESP, AXI_BUFFER_STATE);
signal AXI_BURST_STATE : AXI_BURST; 

signal sig_S01_AXI_ARVALID  : std_logic := '0'; 
signal sig_S01_AXI_ARADDR   : std_logic_vector(31 downto 0);
signal sig_S01_AXI_RDATA    : std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
signal sig_S01_AXI_RREADY   : std_logic; 
signal sig_S01_AXI_ARBURST  : std_logic_vector(1 downto 0);
signal sig_S01_AXI_ARLEN    : std_logic_vector(7 downto 0);
signal sig_S01_AXI_ARSIZE   : std_logic_vector(2 downto 0);  -- 000 -> 1bytes, 001->2bytes, 010->4bytes, 011->8bytes, 100->16bytes, 101->32bytes, 011->64bytes, 111->128bytes  


signal sig_BS_valid, sig_BS_check_process        : std_logic := '0';
signal sig_SW_TRIGGER_VALUE       				 : std_logic_vector(1 downto 0);
signal sig_PRC_trigger 							 : std_logic_vector(1 downto 0) := "00";
signal sig_SW_TRIGGER_ADDR_MATCH 				 : std_logic; 
signal sig_BS_SEARCH_DONE, sig_FAR_FOUND         : std_logic;
signal sig_BS_SEARCH_START,  sig_FAR_SEARCH_ENB   : std_logic := '0'; 
signal sig_LEFT_BS_ADDR, sig_RIGHT_BS_ADDR, sig_BLANK_BS_ADDR :  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
signal sig_LEFT_BS_SIZE, sig_RIGHT_BS_SIZE, sig_BLANK_BS_SIZE :  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
signal sig_word_count,sig_BEAT_COUNT : integer := 0;
signal sig_BS_END, sig_BEAT_DONE : std_logic := '0';
signal sig_BS_FINISHED, sig_PRC_BLOCK: std_logic;
signal sig_PRC_ALLOW : std_logic_vector(1 downto 0);
signal sig_PRC_CONFIG_PASS_TO_PRC, sig_PRC_TRIGGER_PASS_TO_PRC, sig_PRC_TRIGGER_BLOCK_TO_PRC: std_logic;
signal sig_BURST_STAY : std_logic;

signal sig_M00_axi_0_awready, sig_M00_axi_0_wready: std_logic;
signal sig_M00_axi_0_bvalid : std_logic := '0';
signal sig_M00_axi_0_bresp : std_logic_vector(1 downto 0);
signal sig_READ_TEMP_RESP : std_logic_vector(2 downto 0); 
 
signal sig_STOP_TRANS : std_logic := '0';
signal sig_rvalid_error : std_logic := '0';
            
signal sig_M00_axi_0_awaddr    : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
signal sig_M00_axi_0_awvalid   : std_logic; 
signal sig_S00_AXI_REG_0_AWREADY	: std_logic;
signal sig_M00_axi_0_wdata	    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0):= (others => '0');
signal sig_M00_axi_0_wstrb	    : std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
signal sig_M00_axi_0_wvalid	: std_logic;
signal sig_M00_axi_0_bready	: std_logic;
signal sig_LITE_DATA_done, sig_LITE_ADDR_done  : std_logic;

signal sig_S00_AXI_REG_0_BVALID : std_logic;
signal sig_S00_AXI_REG_0_WREADY : std_logic;
signal sig_S00_AXI_REG_0_BRESP	: std_logic_vector(1 downto 0);

signal sig_M01_AXI_ARADDR : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
signal sig_AXI_RDATA      : std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
signal sig_readFile,sig_readAddressFile : std_logic;
signal sig_M01_AXI_ARLEN	: std_logic_vector(7 downto 0);
begin

--  -------------------------------------------------------------
--      -------- AXI_LITE UNUSED SIGNALS_MAPPING ---------
-- --------------------------------------------------------------
M00_axi_0_araddr <= S00_AXI_REG_0_ARADDR;	
M00_axi_0_arprot <= S00_AXI_REG_0_ARPROT ;
M00_axi_0_arvalid <= S00_AXI_REG_0_ARVALID; 
S00_AXI_REG_0_ARREADY <= M00_axi_0_arready; 
S00_AXI_REG_0_RDATA <= M00_axi_0_rdata ; 
S00_AXI_REG_0_RRESP <= M00_axi_0_rresp;
S00_AXI_REG_0_RVALID <= M00_axi_0_rvalid;
M00_axi_0_rready <= S00_AXI_REG_0_RREADY;   

-- Error check condition 
error_signal <= '1' when (S00_AXI_REG_0_AWPROT(1) = '1' and S00_AXI_REG_0_AWVALID = '1') else '0';

--  -------------------------------------------------------------
--      -------- AWPROT_TOWARDS_PRC ---------
-- --------------------------------------------------------------
M00_axi_0_awaddr <= sig_M00_axi_0_awaddr;  
M00_axi_0_awvalid <= sig_M00_axi_0_awvalid;
M00_axi_0_wdata <= sig_M00_axi_0_wdata;  
M00_axi_0_wstrb <= sig_M00_axi_0_wstrb;
M00_axi_0_wvalid <= sig_M00_axi_0_wvalid ; 
M00_axi_0_bready <= sig_M00_axi_0_bready;

-- AXI BURST ASSIGN
M01_AXI_RREADY <= sig_S01_AXI_RREADY;
M01_AXI_ARADDR <= sig_M01_AXI_ARADDR;
M01_AXI_ARLEN <= sig_M01_AXI_ARLEN;
readFile <= sig_readFile;
readAddressFile <= sig_readAddressFile;

--  -------------------------------------------------------------
--      -------- AWPROT_TOWARDS_PS ---------
-- --------------------------------------------------------------
S00_AXI_REG_0_AWREADY <= sig_S00_AXI_REG_0_AWREADY;
S00_AXI_REG_0_WREADY <= sig_S00_AXI_REG_0_WREADY;
S00_AXI_REG_0_BVALID <= sig_S00_AXI_REG_0_BVALID;
S00_AXI_REG_0_BRESP <= sig_S00_AXI_REG_0_BRESP;

--  -------------------------------------------------------------
--      -------- REGISTERs for BS_ADDRESS, BS_SIZE ---------
-- --------------------------------------------------------------
ADDR_REG_PROCESS: process(aclk_0, aresetn_0)
begin
if aresetn_0 = '0' then
        sig_LEFT_BS_ADDR  <= (others =>'0');
        sig_LEFT_BS_SIZE  <= (others =>'0');
        sig_RIGHT_BS_SIZE <= (others =>'0');
        sig_RIGHT_BS_ADDR <= (others =>'0');
        sig_BLANK_BS_ADDR <= (others =>'0');
        sig_BLANK_BS_SIZE <= (others =>'0');

else
    if rising_edge(aclk_0) then
        if(S00_AXI_REG_0_AWADDR = x"44A000c4" and S00_AXI_REG_0_AWVALID = '1' ) then
                sig_LEFT_BS_ADDR <= S00_AXI_REG_0_WDATA; 
        end if;
        if(S00_AXI_REG_0_AWADDR = x"44A000c8" and S00_AXI_REG_0_AWVALID = '1' ) then
                sig_LEFT_BS_SIZE <= S00_AXI_REG_0_WDATA; 
        end if;
        if(S00_AXI_REG_0_AWADDR = x"44A000d4" and S00_AXI_REG_0_AWVALID = '1' ) then
                sig_RIGHT_BS_ADDR <= S00_AXI_REG_0_WDATA; 
        end if;
        if(S00_AXI_REG_0_AWADDR = x"44A000d8" and S00_AXI_REG_0_AWVALID = '1' ) then
                     sig_RIGHT_BS_SIZE <= S00_AXI_REG_0_WDATA;
        end if;
        if(S00_AXI_REG_0_AWADDR = x"44A000e4" and S00_AXI_REG_0_AWVALID = '1' ) then
                sig_BLANK_BS_ADDR <= S00_AXI_REG_0_WDATA; 
        end if;
        if(S00_AXI_REG_0_AWADDR =x"44A000e8" and S00_AXI_REG_0_AWVALID = '1' ) then
                sig_BLANK_BS_SIZE <= S00_AXI_REG_0_WDATA; 
        end if; 
     end if;
end if;    
end process;

--  -------------------------------------------------------------
--     AXI-LITE WRITE FOR PRC CONFIGURATION
-- --------------------------------------------------------------
AXI_LITE_DECISION_PROCESS : process(aclk_0,aresetn_0,state)
begin
if rising_edge(aclk_0) then
    if aresetn_0 = '0' then
        sig_SW_TRIGGER_VALUE <= "00"; 
        sig_S00_AXI_REG_0_BVALID <= '0';
        sig_S00_AXI_REG_0_AWREADY <= '0';
        sig_S00_AXI_REG_0_WREADY <= '0';
        sig_STOP_TRANS <= '0';
        sig_SW_TRIGGER_ADDR_MATCH <= '0';
        sig_FAR_SEARCH_ENB <= '0'; 
        
        state <= AXI_LITE_IDLE;
    else
        
        case (state) is
            when AXI_LITE_IDLE => 
                sig_S00_AXI_REG_0_BVALID <= '0';
			    sig_S00_AXI_REG_0_AWREADY <= '0';
	            sig_S00_AXI_REG_0_WREADY <= '0';
                if error_signal='1' then
                    state <= AXI_LITE_INVALID;
                else
                    state <= AXI_LITE_TRIGGER_CHECK;             
                end if; 
                                
            when AXI_LITE_INVALID =>
                sig_M00_axi_0_awaddr <= (others => '0');
                sig_M00_axi_0_awvalid <= '0';
                sig_M00_axi_0_wdata <=  (others => '0');  
                sig_M00_axi_0_wstrb <= "0000";
                sig_M00_axi_0_wvalid <= '0'; 
                sig_M00_axi_0_bready <= '0';
                 
                sig_S00_AXI_REG_0_BRESP <= "11";
                sig_S00_AXI_REG_0_BVALID <= '1';
                sig_S00_AXI_REG_0_AWREADY <= '1';
                sig_S00_AXI_REG_0_WREADY <= '1';
                state <= AXI_LITE_READY;
                
            when AXI_LITE_READY =>
                --S00_AXI_REG_0_BVALID <= '1';
                if S00_AXI_REG_0_BREADY = '1' then
                   sig_STOP_TRANS <= '1';
                else 
                   sig_STOP_TRANS <= '0';
                end if;
                state <= AXI_LITE_IDLE;
           
            when AXI_LITE_TRIGGER_CHECK => 
                sig_S00_AXI_REG_0_AWREADY <= '1';
				sig_S00_AXI_REG_0_WREADY <= '1';	
				state <= AXI_LITE_WRITE_TRANSACTION;
			    
			when AXI_LITE_WRITE_TRANSACTION	=>
			     	
				 if (sig_S00_AXI_REG_0_AWREADY = '1' and S00_AXI_REG_0_AWVALID = '1') then    			-- SW trigger register
                    sig_LITE_ADDR_done <= '1';
                    else
                    sig_LITE_ADDR_done <= '0';
                 end if;
                    
                 if (sig_S00_AXI_REG_0_WREADY = '1' and S00_AXI_REG_0_WVALID = '1') then    			-- SW trigger register
                    sig_LITE_DATA_done <= '1';
                 else
                    sig_LITE_DATA_done <= '0';
                 end if;  
					
                if (S00_AXI_REG_0_AWADDR = x"44A00004") then                                        
                    sig_SW_TRIGGER_ADDR_MATCH <= '1';
                         case S00_AXI_REG_0_WDATA is                         -- SW Trigger Value 
                            when x"00000000" =>
                                sig_SW_TRIGGER_VALUE <= "00";                       
                            when x"00000001" =>
                                sig_SW_TRIGGER_VALUE <= "01";
                            when x"00000002" =>
                                sig_SW_TRIGGER_VALUE <= "10";
                            when others =>       
                         end case;      
                else
                    sig_SW_TRIGGER_ADDR_MATCH <= '0';
                end if;
                
                state <= AXI_LITE_EXEC;
                
            when AXI_LITE_EXEC =>
                    sig_S00_AXI_REG_0_AWREADY <= '0';   --sig_LITE_ADDR_done <= '0';
				    sig_S00_AXI_REG_0_WREADY <= '0';    -- sig_LITE_DATA_done <= '0';
				  
                  if sig_SW_TRIGGER_ADDR_MATCH = '1' then
                       state <= AXI_LITE_WAIT;
                    else	
                       state <= PRC_TRANS_VALID;
                    end if;

             when AXI_LITE_WAIT =>
                sig_FAR_SEARCH_ENB <= '1';               
                
                if (sig_PRC_ALLOW = "11") then
                    state <= PRC_TRANS_VALID; 
					sig_FAR_SEARCH_ENB <= '0';
                elsif (sig_PRC_ALLOW = "00") then
                    state <= PRC_TRANS_ERROR; 
					sig_FAR_SEARCH_ENB <= '0';	
                else 
                    state <= AXI_LITE_WAIT;
                end if; 
                
            when PRC_TRANS_VALID =>
                sig_FAR_SEARCH_ENB <= '0';            --check if its not working     
					
                sig_M00_axi_0_awaddr <= S00_AXI_REG_0_AWADDR;  
                sig_M00_axi_0_awvalid <= S00_AXI_REG_0_AWVALID;
                sig_M00_axi_0_wdata <= S00_AXI_REG_0_WDATA;  
                sig_M00_axi_0_wstrb <= S00_AXI_REG_0_WSTRB;
                sig_M00_axi_0_wvalid <= S00_AXI_REG_0_WVALID ; 
                sig_M00_axi_0_bready <= S00_AXI_REG_0_BREADY;
            
                sig_S00_AXI_REG_0_BRESP   <=  "00";  --M00_axi_0_bresp;
                sig_S00_AXI_REG_0_BVALID  <=  '1';   --M00_axi_0_bvalid; 
--                sig_S00_AXI_REG_0_AWREADY <=  '1';   --M00_axi_0_awready;
--                sig_S00_AXI_REG_0_WREADY  <=  '1';   --M00_axi_0_wready;  
                
                state <= AXI_LITE_IDLE;
                
            when PRC_TRANS_ERROR =>
                sig_FAR_SEARCH_ENB <= '0';          --check if its not working
			
                sig_M00_axi_0_awaddr <= (others => '0');  
                sig_M00_axi_0_awvalid <= '0'; 
                sig_M00_axi_0_wdata <= (others => '0');  
                sig_M00_axi_0_wstrb <= "0000";
                sig_M00_axi_0_wvalid <= '0'; 
                sig_M00_axi_0_bready <= '0';
            
                sig_S00_AXI_REG_0_BRESP <= "11";
                sig_S00_AXI_REG_0_BVALID <= '1';
                sig_S00_AXI_REG_0_AWREADY <= '1';
                sig_S00_AXI_REG_0_WREADY <= '1';

                state <= AXI_LITE_IDLE;

	        when others =>  
	               state <= AXI_LITE_IDLE;
        end case;
    end if;
end if;
end process;

--  -------------------------------------------------------------
--       AXI-BURST READ Bitstreams from PS-SLAVE PORT 
-- --------------------------------------------------------------       

AXI_BURST_DECISION : process(aclk_0,aresetn_0,AXI_BURST_STATE)
variable var_axi_rdata : std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
--variable var_AXI_RDATA : std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
variable var_AXI_ARADDR : std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0) := (others => '0');
variable var_FAR_FOUND  : std_logic;
begin
if rising_edge(aclk_0) then
    if aresetn_0 = '0' then
       
        sig_word_count <= 0;
        sig_M01_AXI_ARLEN	<= x"80";  -- x"08";   x"FF" -  total 256 transfers
        M01_AXI_ARSIZE	 <= "010";  -- 4 bytes per transfer
        M01_AXI_ARBURST <= "01";   -- Incremental burst transfer
        sig_BURST_STAY <= '0';
        sig_S01_AXI_ARVALID <= '0';
        sig_S01_AXI_RREADY <= '0';
        sig_readFile <= '0';
		sig_readAddressFile <= '0';
        
        sig_FAR_FOUND <= '0';
        sig_BEAT_DONE <= '0';
        sig_BS_valid <= '0';
        sig_PRC_ALLOW <= "01";
        --sig_M01_AXI_ARADDR <= x"00000000"; 
        
        AXI_BURST_STATE <= AXI_BURST_IDLE;   
         
    else 
        case AXI_BURST_STATE is
            when AXI_BURST_IDLE =>
                --sig_word_count <= 0;
				 sig_BURST_STAY <= '0';
                 sig_S01_AXI_ARVALID <= '0';
                 sig_S01_AXI_RREADY <= '0';
                 sig_PRC_ALLOW <= "01";
                  case sig_SW_TRIGGER_VALUE is
                    when "00" => 
                            sig_M01_AXI_ARADDR <= sig_LEFT_BS_ADDR;   --x"50000000";      
                    when "01" => 
                            sig_M01_AXI_ARADDR <= sig_RIGHT_BS_ADDR;  --x"60000000";             
                    when "10" => 
                            sig_M01_AXI_ARADDR <= sig_BLANK_BS_ADDR;  -- x"70000000";             
                    when others =>
                 end case;
                  
                if sig_FAR_SEARCH_ENB = '1' then
                    AXI_BURST_STATE <= AXI_BURST_TRIG_ADDR_MAP;
                else
                    AXI_BURST_STATE <= AXI_BURST_IDLE;    
                end if;
           -- when AXI_BURST_SETUP =>
           --     AXI_BURST_STATE <= AXI_BURST_TRIG_ADDR_MAP;
                          
			when AXI_BURST_TRIG_ADDR_MAP =>
			    sig_S01_AXI_ARVALID <= '1';
				if (sig_s01_axi_arvalid = '1' and M01_AXI_ARREADY = '1') then   
					sig_readAddressFile <= '1';
					AXI_BURST_STATE <= AXI_READ_PROCESS;                      -- got updated  ARADDR and RADDR hence now goto READ PROCESS
				else
					AXI_BURST_STATE <= AXI_BURST_TRIG_ADDR_MAP;
				end if;   
				
			when AXI_READ_PROCESS =>
			        sig_S01_AXI_RREADY <= '1';
				    sig_readAddressFile <= '0';
                    sig_readFile <= '1';
					--sig_rvalid_error <= '0';                   -- if rvalid is not received on time then it give back error response 
					AXI_BURST_STATE <= AXI_READ_TRANSACTION;
		   
		   when AXI_READ_TRANSACTION =>
		            sig_readFile <= '0';
		          	--sig_AXI_RDATA <= M01_AXI_RDATA;
					if M01_AXI_RVALID = '1' and sig_S01_AXI_RREADY = '1' then --and sig_readFile = '1' then
						sig_AXI_RDATA <= M01_AXI_RDATA;
						sig_word_count <= sig_word_count + 1;
						AXI_BURST_STATE <= AXI_FAR_CHECK; --AXI_BURST_BS_READ;
					else
						AXI_BURST_STATE <= AXI_READ_PROCESS;
					end if;
           
           when AXI_FAR_CHECK => 
                    sig_S01_AXI_RREADY <= '0';
                    --sig_readFile <= '0';
                    case (M01_AXI_RLAST) is
                    when '0' =>               
                        if M01_AXI_RDATA = x"047900" then
                            sig_FAR_FOUND <= '1';
							sig_BEAT_DONE <= '0';
							sig_BS_valid <= '1';							
                        else
							sig_FAR_FOUND <= '0';
							sig_BEAT_DONE <= '0';
							sig_BS_valid <= '0';
						end if;
 
                    when '1' =>
                        if M01_AXI_RDATA = x"047900" then
                            sig_FAR_FOUND <= '1';
							sig_BEAT_DONE <= '1';
							sig_BS_valid <= '1';
                        else
							sig_FAR_FOUND <= '0';
							sig_BEAT_DONE <= '1';
							sig_BS_valid <= '0';
                            if (sig_word_count < 255) then --to_integer(unsigned(sig_LEFT_BS_SIZE))*4) then -- should be BS size
								sig_BURST_STAY <= '1';
                            else 
								sig_BURST_STAY <= '0';
							end if;		   
                           
                        end if;
                    when others =>
                   end case;	
        
                    AXI_BURST_STATE <= AXI_BURST_BS_READ;
           
			when AXI_BURST_BS_READ =>
--                     sig_S01_AXI_RREADY <= '0';
--                     sig_readFile <= '0'
			 
					if sig_FAR_FOUND = '1' and sig_BEAT_DONE = '1' then
						AXI_BURST_STATE <= AXI_BURST_ERROR_RESP;
					elsif sig_FAR_FOUND = '1' and sig_BEAT_DONE = '0' then
						AXI_BURST_STATE <= AXI_BURST_ERROR_RESP;
					elsif sig_FAR_FOUND = '0' and sig_BEAT_DONE = '0' then
						AXI_BURST_STATE <= AXI_READ_PROCESS;
					else 
						if sig_BURST_STAY = '1' then
							AXI_BURST_STATE <= AXI_BURST_TEMP;
						else 
							AXI_BURST_STATE <= AXI_BURST_ERROR_RESP;
						end if;
					end if;
						
			when AXI_BURST_TEMP =>
			        sig_BURST_STAY <= '0';
			        sig_s01_axi_arvalid <= '0';
                    sig_M01_AXI_ARADDR <= sig_M01_AXI_ARADDR + sig_M01_AXI_ARLEN;   -- (sig_M01_AXI_ARLEN * x"04"); --  next address;	
                    AXI_BURST_STATE <= AXI_BURST_TRIG_ADDR_MAP;
						
			when AXI_BURST_ERROR_RESP =>
			     sig_readFile <= '0';                    
                 sig_S01_AXI_RREADY <= '0';
                 sig_s01_axi_arvalid <= '0';
                 sig_FAR_FOUND <= '0';
                                                                        
                 if sig_BS_valid = '1' then 
                        sig_PRC_ALLOW <= "11";
                 else 
                    if sig_BURST_STAY = '1' then 
                        sig_PRC_ALLOW <= "01";
                    else 
                        sig_PRC_ALLOW <= "00";
                    end if;
                    
                 end if;
                 AXI_BURST_STATE <= AXI_BUFFER_STATE;
                 
			when AXI_BUFFER_STATE =>
			        sig_BS_valid <= '0';
					AXI_BURST_STATE <= AXI_BURST_IDLE;
			when others =>
			end case;					
     end if;    
 end if;                                
 end process;
 
end Behavioral;

