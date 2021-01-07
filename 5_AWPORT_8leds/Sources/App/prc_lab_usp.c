#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "xparameters.h"
#include "xil_printf.h"
#include "xil_cache.h"
#include "ff.h"
#include "xcsudma.h"
#include "xil_io.h"
#include "xil_types.h"

#include "xilfpga_pcap.h"
#include "xfpga_config.h"

// Parameters for Partial Reconfiguration
#define XPAR_PRC_0_BASEADDR			0x0400000000 //0x44A00000
#define PARTIAL_LEFT_ADDR			0x05000000
#define PARTIAL_RIGHT_ADDR			0x06000000
#define PARTIAL_BLANK_SHIFT_ADDR	0x07000000

#define PARTIAL_LEFT_ADDR_47		    0x08000000
#define PARTIAL_RIGHT_ADDR_47			0x080A94FC
#define PARTIAL_BLANK_SHIFT_ADDR_47	    0x09000000


// Bin Size by checking properties is 693,472 bytes in words 173368
#define PARTIAL_LEFT_BITFILE_LEN 			173368 // in number of words
#define PARTIAL_RIGHT_BITFILE_LEN 			173368 // in number of words
#define PARTIAL_BLANK_SHIFT_BITFILE_LEN 	173368 // in number of words


#define XFPGA_PARTIAL_EN		(0x00000001U)
/*
=============================
| Virtual Socket Manager | Register     | Address |
+------------------------+--------------+---------+
| rp_shift_03            | STATUS       | 0X00000 |
| rp_shift_03            | CONTROL      | 0X00000 |
| rp_shift_03            | SW_TRIGGER   | 0X00004 |
| rp_shift_03            | TRIGGER0     | 0X00040 |
| rp_shift_03            | TRIGGER1     | 0X00044 |
| rp_shift_03            | TRIGGER2     | 0X00048 |
| rp_shift_03            | TRIGGER3     | 0X0004C |
| rp_shift_03            | RM_BS_INDEX0 | 0X00080 |
| rp_shift_03            | RM_CONTROL0  | 0X00084 |
| rp_shift_03            | RM_BS_INDEX1 | 0X00088 |
| rp_shift_03            | RM_CONTROL1  | 0X0008C |
| rp_shift_03            | RM_BS_INDEX2 | 0X00090 |
| rp_shift_03            | RM_CONTROL2  | 0X00094 |
| rp_shift_03            | RM_BS_INDEX3 | 0X00098 |
| rp_shift_03            | RM_CONTROL3  | 0X0009C |
| rp_shift_03            | BS_ID0       | 0X000C0 |
| rp_shift_03            | BS_ADDRESS0  | 0X000C4 |
| rp_shift_03            | BS_SIZE0     | 0X000C8 |
| rp_shift_03            | BS_ID1       | 0X000D0 |
| rp_shift_03            | BS_ADDRESS1  | 0X000D4 |
| rp_shift_03            | BS_SIZE1     | 0X000D8 |
| rp_shift_03            | BS_ID2       | 0X000E0 |
| rp_shift_03            | BS_ADDRESS2  | 0X000E4 |
| rp_shift_03            | BS_SIZE2     | 0X000E8 |
| rp_shift_03            | BS_ID3       | 0X000F0 |
| rp_shift_03            | BS_ADDRESS3  | 0X000F4 |
| rp_shift_03            | BS_SIZE3     | 0X000F8 |
| rp_shift_47            | STATUS       | 0X00100 |
| rp_shift_47            | CONTROL      | 0X00100 |
| rp_shift_47            | SW_TRIGGER   | 0X00104 |
| rp_shift_47            | TRIGGER0     | 0X00140 |
| rp_shift_47            | TRIGGER1     | 0X00144 |
| rp_shift_47            | TRIGGER2     | 0X00148 |
| rp_shift_47            | TRIGGER3     | 0X0014C |
| rp_shift_47            | RM_BS_INDEX0 | 0X00180 |
| rp_shift_47            | RM_CONTROL0  | 0X00184 |
| rp_shift_47            | RM_BS_INDEX1 | 0X00188 |
| rp_shift_47            | RM_CONTROL1  | 0X0018C |
| rp_shift_47            | RM_BS_INDEX2 | 0X00190 |
| rp_shift_47            | RM_CONTROL2  | 0X00194 |
| rp_shift_47            | RM_BS_INDEX3 | 0X00198 |
| rp_shift_47            | RM_CONTROL3  | 0X0019C |
| rp_shift_47            | BS_ID0       | 0X001C0 |
| rp_shift_47            | BS_ADDRESS0  | 0X001C4 |
| rp_shift_47            | BS_SIZE0     | 0X001C8 |
| rp_shift_47            | BS_ID1       | 0X001D0 |
| rp_shift_47            | BS_ADDRESS1  | 0X001D4 |
| rp_shift_47            | BS_SIZE1     | 0X001D8 |
| rp_shift_47            | BS_ID2       | 0X001E0 |
| rp_shift_47            | BS_ADDRESS2  | 0X001E4 |
| rp_shift_47            | BS_SIZE2     | 0X001E8 |
| rp_shift_47            | BS_ID3       | 0X001F0 |
| rp_shift_47            | BS_ADDRESS3  | 0X001F4 |
| rp_shift_47            | BS_SIZE3     | 0X001F8 |

*/


#define rp_shift_03_STATUS      XPAR_PRC_0_BASEADDR+0X00000
#define rp_shift_03_CONTROL     XPAR_PRC_0_BASEADDR+0X00000
#define rp_shift_03_SW_TRIGGER  XPAR_PRC_0_BASEADDR+0X00004
#define rp_shift_03_TRIGGER0    XPAR_PRC_0_BASEADDR+0X00040
#define rp_shift_03_TRIGGER1    XPAR_PRC_0_BASEADDR+0X00044
#define rp_shift_03_TRIGGER2    XPAR_PRC_0_BASEADDR+0X00048
#define rp_shift_03_TRIGGER3    XPAR_PRC_0_BASEADDR+0X0004C

#define rp_shift_03_RM_ADDRESS0 XPAR_PRC_0_BASEADDR+0X00080
#define rp_shift_03_RM_CONTROL0 XPAR_PRC_0_BASEADDR+0X00084
#define rp_shift_03_RM_ADDRESS1 XPAR_PRC_0_BASEADDR+0X00088
#define rp_shift_03_RM_CONTROL1 XPAR_PRC_0_BASEADDR+0X0008C
#define rp_shift_03_RM_ADDRESS2 XPAR_PRC_0_BASEADDR+0X00090
#define rp_shift_03_RM_CONTROL2 XPAR_PRC_0_BASEADDR+0X00094
#define rp_shift_03_RM_ADDRESS3 XPAR_PRC_0_BASEADDR+0X00098
#define rp_shift_03_RM_CONTROL3 XPAR_PRC_0_BASEADDR+0X0009C


#define rp_shift_03_BS_ID0		 XPAR_PRC_0_BASEADDR+0X000C0
#define rp_shift_03_BS_ID1		 XPAR_PRC_0_BASEADDR+0X000D0
#define rp_shift_03_BS_ID2		 XPAR_PRC_0_BASEADDR+0X000E0
#define rp_shift_03_BS_ID3		 XPAR_PRC_0_BASEADDR+0X000F0

#define rp_shift_03_BS_ADDRESS0 XPAR_PRC_0_BASEADDR+0X000C4
#define rp_shift_03_BS_SIZE0    XPAR_PRC_0_BASEADDR+0X000C8
#define rp_shift_03_BS_ADDRESS1 XPAR_PRC_0_BASEADDR+0X000D4
#define rp_shift_03_BS_SIZE1    XPAR_PRC_0_BASEADDR+0X000D8
#define rp_shift_03_BS_ADDRESS2 XPAR_PRC_0_BASEADDR+0X000E4
#define rp_shift_03_BS_SIZE2    XPAR_PRC_0_BASEADDR+0X000E8
#define rp_shift_03_BS_ADDRESS3 XPAR_PRC_0_BASEADDR+0X000F4
#define rp_shift_03_BS_SIZE3    XPAR_PRC_0_BASEADDR+0X000F8


//  Second Partition configuration

#define rp_shift_47_STATUS      XPAR_PRC_0_BASEADDR+0X00100
#define rp_shift_47_CONTROL     XPAR_PRC_0_BASEADDR+0X00100
#define rp_shift_47_SW_TRIGGER  XPAR_PRC_0_BASEADDR+0X00104
#define rp_shift_47_TRIGGER0    XPAR_PRC_0_BASEADDR+0X00140
#define rp_shift_47_TRIGGER1    XPAR_PRC_0_BASEADDR+0X00144
#define rp_shift_47_TRIGGER2    XPAR_PRC_0_BASEADDR+0X00148
#define rp_shift_47_TRIGGER3    XPAR_PRC_0_BASEADDR+0X0014C

#define rp_shift_47_RM_ADDRESS0 XPAR_PRC_0_BASEADDR+0X00180
#define rp_shift_47_RM_CONTROL0 XPAR_PRC_0_BASEADDR+0X00184
#define rp_shift_47_RM_ADDRESS1 XPAR_PRC_0_BASEADDR+0X00188
#define rp_shift_47_RM_CONTROL1 XPAR_PRC_0_BASEADDR+0X0018C
#define rp_shift_47_RM_ADDRESS2 XPAR_PRC_0_BASEADDR+0X00190
#define rp_shift_47_RM_CONTROL2 XPAR_PRC_0_BASEADDR+0X00194
#define rp_shift_47_RM_ADDRESS3 XPAR_PRC_0_BASEADDR+0X00198
#define rp_shift_47_RM_CONTROL3 XPAR_PRC_0_BASEADDR+0X0019C


#define rp_shift_47_BS_ID0		XPAR_PRC_0_BASEADDR+0X001C0
#define rp_shift_47_BS_ID1		XPAR_PRC_0_BASEADDR+0X001D0
#define rp_shift_47_BS_ID2		XPAR_PRC_0_BASEADDR+0X001E0
#define rp_shift_47_BS_ID3		XPAR_PRC_0_BASEADDR+0X001F0

#define rp_shift_47_BS_ADDRESS0 XPAR_PRC_0_BASEADDR+0X001C4
#define rp_shift_47_BS_SIZE0    XPAR_PRC_0_BASEADDR+0X001C8
#define rp_shift_47_BS_ADDRESS1 XPAR_PRC_0_BASEADDR+0X001D4
#define rp_shift_47_BS_SIZE1    XPAR_PRC_0_BASEADDR+0X001D8
#define rp_shift_47_BS_ADDRESS2 XPAR_PRC_0_BASEADDR+0X001E4
#define rp_shift_47_BS_SIZE2    XPAR_PRC_0_BASEADDR+0X001E8
#define rp_shift_47_BS_ADDRESS3 XPAR_PRC_0_BASEADDR+0X001F4
#define rp_shift_47_BS_SIZE3    XPAR_PRC_0_BASEADDR+0X001F8


// Read function for STDIN
extern char inbyte(void);

static FATFS fatfs;

// Driver Instantiations
//static XCsuDma_Config *CsuDmaConfig;
// Driver Instantiations
static XCsuDma_Config *XCsuDma_0;
XCsuDma DcfgInstance;
XCsuDma *DcfgInstPtr;

int SD_Init()
{
	FRESULT rc;

	rc = f_mount(&fatfs, "", 0);
	if (rc) {
		xil_printf(" ERROR : f_mount returned %d\r\n", rc);
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}


int DDR_BS_READ(u32 DestinationAddress, u32 ByteLength)
{
	u32 BS_address;
	u32 count = 0;
	u32 FAR_found =0;
	u32 tempVar;


	switch(DestinationAddress){

		case 0x05000000 : BS_address = 83886080; break;
		case 0x06000000 : BS_address = 100663296; break;
		case 0x07000000 : BS_address = 117440512; break;

		case 0x08000000 : BS_address = 134217728; break;
		case 0x080A94FC : BS_address = 134911228; break;
		case 0x09000000 : BS_address = 150994944; break;

		default: xil_printf("No BS_address\r\n"); break;

		}

		int *DDRstart = BS_address;

		for (u32 i=3380; i<(ByteLength>>2); i++)
		{
			if(*(DDRstart+i) == 0x30002001)
			{
				xil_printf("%x\r\n",*(DDRstart+i));
				count++;

				if( (*(DDRstart+i+1) == 0x47900) || (*(DDRstart+i+1) == 0xC7900))
				{
					tempVar = *(DDRstart+i+1);

					if ((((tempVar>>16) & 0xFF) == 0x04) || (((tempVar>>16) & 0xFF) == 0x0C))
					{
						xil_printf("Line=%d and FAR Hex = %x \r\n",(count/4), *(DDRstart+i+1));
						FAR_found = 1;
						break;
					}
				}

			}else{
				count++;
				FAR_found = 0;
				}
		}


	xil_printf("*******DDR BS READ DONE*********\r\n");

	if(FAR_found)
	{
		return XST_SUCCESS;
	}else{
		xil_printf("FAR not found....... \r\n");
		return XST_FAILURE;
	}

}

int SD_TransferPartial(char *FileName, u32 DestinationAddress, u32 ByteLength)
{
	FIL fil;
	FRESULT rc;
	UINT br;


	rc = f_open(&fil, FileName, FA_READ);
	if (rc) {
		xil_printf(" ERROR : f_open returned %d\r\n", rc);
		return XST_FAILURE;
	}

	rc = f_lseek(&fil, 0);
	if (rc) {
		xil_printf(" ERROR : f_lseek returned %d\r\n", rc);
		return XST_FAILURE;
	}

	rc = f_read(&fil, (void*) DestinationAddress, ByteLength, &br);
	if (rc) {
		xil_printf(" ERROR : f_read returned %d\r\n", rc);
		return XST_FAILURE;
	}

	rc = f_close(&fil);
	if (rc) {
		xil_printf(" ERROR : f_close returned %d\r\n", rc);
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}


void display_status(UINTPTR triggerReg, UINTPTR statusReg) {
	int 	status_rm 	= Xil_In32(triggerReg);
	int		status 		= Xil_In32(statusReg);

	switch(status & 0x07) {
		case 7 : print("RM loaded\r\n"); break;
		case 6 : print("RM is being reset\r\n"); break;
		case 5 : print("Software start-up step\r\n"); break;
		case 4 : print("Loading new RM\r\n"); break;
		case 2 : print("Software shutdown\r\n"); break;
		case 1 : print("Hardware shutdown\r\n"); break;
	}

	xil_printf("rp_sbox_STATUS = %x\r\n",  status);
	xil_printf("Status.rm_id = %x\r\n",    (status & 0x00FFFF00)>>8);
	xil_printf("Status.shutdown = %x\r\n", (status & 0x00000080)>>7);
	xil_printf("Status.error = %x\r\n",    (status & 0x00000078)>>3);
	xil_printf("Status.state = %x\r\n",    status & 0x00000007);

	xil_printf("\r\n rp_sbox_SW_TRIGGER = %x\r\n",          status_rm);
	xil_printf("\r\n Status & 0x8000 = %x\r\n",          status_rm&0x8000);
}

void display_fil(FIL fil) {
//	xil_printf("FFOBJID obj= %x\r\n",  fil.obj);          /* Object identifier */
	xil_printf("BYTE    flag= %x\r\n",  fil.flag);         /* File object status flags */
	xil_printf("BYTE    err= %x\r\n",  fil.err);          /* Abort flag (error code) */
	xil_printf("FSIZE_t fptr= %x\r\n",  fil.fptr);         /* File read/write pointer (Byte offset origin from top of the file) */
	xil_printf("DWORD   clust= %x\r\n",  fil.clust);        /* Current cluster of fptr (One cluster behind if fptr is on the cluster boundary. Invalid if fptr == 0.) */
//	xil_printf("DWORD   sect= %x\r\n",  fil.sect);

    }

void initRegisters(void) {
	// Display PRC status
	// Bank0 : STATUS anc Control Register
	print("Putting the PRC core's SHIFT RP in Shutdown mode\r\n");
	Xil_Out32(rp_shift_03_CONTROL,0); // VSM shutdown state
	print("Waiting for the shutdown to occur\r\n");
	while(!(Xil_In32(rp_shift_03_STATUS)&0x80));   // wait until VSM goes to shutdown state (bit 7 = VSM shutdown state)

	Xil_Out32(rp_shift_47_CONTROL,0); // VSM shutdown state
	print("Waiting for the shutdown to occur\r\n");
	while(!(Xil_In32(rp_shift_47_STATUS)&0x80));   // wait until VSM goes to shutdown state (bit 7 = VSM shutdown state)
	print("Shift RP is shutdown\r\n");


	print("Initializing RM bitstream address and size registers for Shift RMs\r\n");
	// Bank3: Bitstream information registers (3 registers in each row)
	Xil_Out32(rp_shift_03_BS_ADDRESS0,PARTIAL_LEFT_ADDR);
	print("PARTIAL_LEFT_ADDR done\r\n");
	Xil_Out32(rp_shift_03_BS_ADDRESS1,PARTIAL_RIGHT_ADDR);
	print("PARTIAL_RIGHT_ADDR done\r\n");
	Xil_Out32(rp_shift_03_BS_ADDRESS2,PARTIAL_BLANK_SHIFT_ADDR);
	print("PARTIAL_BIT_ADDR done\r\n");
	Xil_Out32(rp_shift_03_BS_ADDRESS3,PARTIAL_LEFT_ADDR);
	print("PARTIAL_LEFT_ADDR done\r\n");

	Xil_Out32(rp_shift_47_BS_ADDRESS0,PARTIAL_LEFT_ADDR_47);
	print("PARTIAL_LEFT_ADDR done\r\n");
	Xil_Out32(rp_shift_47_BS_ADDRESS1,PARTIAL_RIGHT_ADDR_47);
	print("PARTIAL_RIGHT_ADDR done\r\n");
	Xil_Out32(rp_shift_47_BS_ADDRESS2,PARTIAL_BLANK_SHIFT_ADDR_47);
	print("PARTIAL_BIT_ADDR done\r\n");
	Xil_Out32(rp_shift_47_BS_ADDRESS3,PARTIAL_LEFT_ADDR_47);
	print("PARTIAL_LEFT_ADDR done\r\n");


	Xil_Out32(rp_shift_03_BS_SIZE0,PARTIAL_LEFT_BITFILE_LEN<<2);
	print("LEFT_LENGTH done\r\n");
	Xil_Out32(rp_shift_03_BS_SIZE1,PARTIAL_RIGHT_BITFILE_LEN<<2);
	print("RIGHT_LENGTH done\r\n");
	Xil_Out32(rp_shift_03_BS_SIZE2,PARTIAL_BLANK_SHIFT_BITFILE_LEN<<2);
	print("CENTER_LENGTH done\r\n");
	Xil_Out32(rp_shift_03_BS_SIZE3,PARTIAL_LEFT_BITFILE_LEN<<2);
	print("LEFT_LENGTH done\r\n");

	Xil_Out32(rp_shift_47_BS_SIZE0,PARTIAL_LEFT_BITFILE_LEN<<2);
	print("LEFT_LENGTH done\r\n");
	Xil_Out32(rp_shift_47_BS_SIZE1,PARTIAL_RIGHT_BITFILE_LEN<<2);
	print("RIGHT_LENGTH done\r\n");
	Xil_Out32(rp_shift_47_BS_SIZE2,PARTIAL_BLANK_SHIFT_BITFILE_LEN<<2);
	print("CENTER_LENGTH done\r\n");
	Xil_Out32(rp_shift_47_BS_SIZE3,PARTIAL_LEFT_BITFILE_LEN<<2);
	print("LEFT_LENGTH done\r\n");


	// Bank1: Trigger to RM map registers
	print("Initializing RM trigger ID registers for Shift RMs\r\n");
	Xil_Out32(rp_shift_03_TRIGGER0,0);     // ID mapped with RM
	print("TRIGGER 0 done\r\n");
	Xil_Out32(rp_shift_03_TRIGGER1,1);
	print("TRIGGER 1 done\r\n");
	Xil_Out32(rp_shift_03_TRIGGER2,2);
	print("TRIGGER 2 done\r\n");

	Xil_Out32(rp_shift_47_TRIGGER0,0);
	print("TRIGGER 0 done\r\n");
	Xil_Out32(rp_shift_47_TRIGGER1,1);
	print("TRIGGER 1 done\r\n");
	Xil_Out32(rp_shift_47_TRIGGER2,2);
	print("TRIGGER 2 done\r\n");



	// Bank2 : RM information registers (2 registers in each row)
	print("Initializing RM address and control registers for Shift RMs\r\n");
	Xil_Out32(rp_shift_03_RM_ADDRESS0,0);         // contains the row number in the Bank3(BS information register) that holds the BS address for RM0
	print("rp_shift_03_RM_ADDRESS0 done\r\n");
	Xil_Out32(rp_shift_03_RM_ADDRESS1,1);         // Row 1 has BS Address for RM1
	print("rp_shift_03_RM_ADDRESS1 done\r\n");
	Xil_Out32(rp_shift_03_RM_ADDRESS2,2);	      // Row 2 has BS Address for RM2
	print("rp_shift_03_RM_ADDRESS2 done\r\n");

	Xil_Out32(rp_shift_47_RM_ADDRESS0,0);
	print("rp_shift_47_RM_ADDRESS0 done\r\n");
	Xil_Out32(rp_shift_47_RM_ADDRESS1,1);
	print("rp_shift_47_RM_ADDRESS1 done\r\n");
	Xil_Out32(rp_shift_47_RM_ADDRESS2,2);
	print("rp_shift_47_RM_ADDRESS2 done\r\n");

	Xil_Out32(rp_shift_03_RM_CONTROL0,0);             // no need for RM shutdown = 00, HW shutdown required = 01, HW shutdown first then SW = 10, SW shutown first then HW = 11 
	Xil_Out32(rp_shift_03_RM_CONTROL1,0);
	Xil_Out32(rp_shift_03_RM_CONTROL2,0);

	Xil_Out32(rp_shift_47_RM_CONTROL0,0);
	Xil_Out32(rp_shift_47_RM_CONTROL1,0);
	Xil_Out32(rp_shift_47_RM_CONTROL2,0);


	Xil_Out32(rp_shift_03_CONTROL,2);  // VSM restart with status
	Xil_Out32(rp_shift_47_CONTROL,2);  // VSM restart with status
	return;
}

int main()
{
	static int timer;
	int Status;

	// Flush and disable Data Cache
	Xil_DCacheDisable();

    // Initialize SD controller and transfer partials to DDR
	if (SD_Init() != XST_SUCCESS ) {
		print("Error: Unable to mount SD card.\r\n");
		return XST_FAILURE;
	}

	Status = SD_TransferPartial("left_03.bin", PARTIAL_LEFT_ADDR, (PARTIAL_LEFT_BITFILE_LEN << 2));
	if (Status != XST_SUCCESS ) {
		print("Error: Unable to open left.bin from SD card.\r\n");
		return XST_FAILURE;
	}

	Status = SD_TransferPartial("right_03.bin", PARTIAL_RIGHT_ADDR, (PARTIAL_RIGHT_BITFILE_LEN << 2));
	if (Status != XST_SUCCESS ) {
		print("Error: Unable to open right.bin from SD card.\r\n");
		return XST_FAILURE;
	}

	Status = SD_TransferPartial("bled_03.bin", PARTIAL_BLANK_SHIFT_ADDR, (PARTIAL_BLANK_SHIFT_BITFILE_LEN << 2));
	if (Status != XST_SUCCESS ) {
		print("Error: Unable to open bled.bin from SD card.\r\n");
		return XST_FAILURE;
	}


	Status = SD_TransferPartial("left_47.bin", PARTIAL_LEFT_ADDR_47, (PARTIAL_LEFT_BITFILE_LEN << 2));
	if (Status != XST_SUCCESS ) {
		print("Error: Unable to open left.bin from SD card.\r\n");
		return XST_FAILURE;
	}

	Status = SD_TransferPartial("right_47.bin", PARTIAL_RIGHT_ADDR_47, (PARTIAL_RIGHT_BITFILE_LEN << 2));
	if (Status != XST_SUCCESS ) {
		print("Error: Unable to open right.bin from SD card.\r\n");
		return XST_FAILURE;
	}

	Status = SD_TransferPartial("bled_47.bin", PARTIAL_BLANK_SHIFT_ADDR_47, (PARTIAL_BLANK_SHIFT_BITFILE_LEN << 2));
	if (Status != XST_SUCCESS ) {
		print("Error: Unable to open bled.bin from SD card.\r\n");
		return XST_FAILURE;
	}

	xil_printf("Partial Binaries transferred successfully!\r\n");


// **************** FAR Search in the lower P-block *******************

	Status = DDR_BS_READ(PARTIAL_LEFT_ADDR, PARTIAL_LEFT_BITFILE_LEN);
	if (Status != XST_SUCCESS ) {
		print("Error: No Matching FAR Address Found in left_03.bin \r\n");
		return XST_FAILURE;
	}

	Status = DDR_BS_READ(PARTIAL_RIGHT_ADDR, PARTIAL_RIGHT_BITFILE_LEN);
		if (Status != XST_SUCCESS ) {
			print("Error: No Matching FAR Address Found in right_03.bin \r\n");
			return XST_FAILURE;
		}

	Status = DDR_BS_READ(PARTIAL_BLANK_SHIFT_ADDR, PARTIAL_BLANK_SHIFT_BITFILE_LEN);
		if (Status != XST_SUCCESS ) {
			print("Error: No Matching FAR Address Found in bled_03.bin \r\n");
			return XST_FAILURE;
		}

// **************** FAR Search in the upper P-block *******************

		Status = DDR_BS_READ(PARTIAL_LEFT_ADDR_47, PARTIAL_LEFT_BITFILE_LEN);
		if (Status != XST_SUCCESS ) {
			print("Error: No Matching FAR Address Found in left_47.bin \r\n");
			return XST_FAILURE;
		}

		Status = DDR_BS_READ(PARTIAL_RIGHT_ADDR_47, PARTIAL_RIGHT_BITFILE_LEN);
			if (Status != XST_SUCCESS ) {
				print("Error: No Matching FAR Address Found in right_47.bin \r\n");
				return XST_FAILURE;
			}

		Status = DDR_BS_READ(PARTIAL_BLANK_SHIFT_ADDR_47, PARTIAL_BLANK_SHIFT_BITFILE_LEN);
			if (Status != XST_SUCCESS ) {
				print("Error: No Matching FAR Address Found in bled_47.bin \r\n");
				return XST_FAILURE;
			}


	// Invalidate and enable Data Cache
	Xil_DCacheEnable();

	// Init PRC register
	initRegisters();

	// Initialize Device Configuration Interface
	DcfgInstPtr = &DcfgInstance;
	XCsuDma_0 = XCsuDma_LookupConfig(XPAR_XCSUDMA_0_DEVICE_ID) ;
	Status =  XCsuDma_CfgInitialize(DcfgInstPtr, XCsuDma_0, XCsuDma_0->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	// Enable ICAP
	Xil_Out32(CSU_PCAP_RESET, (u32) 0x1);
	Xil_Out32(CSU_PCAP_CTRL , (u32) 0x0);


	// Display Menu
    int OptionNext = 1; // start-up default
	int prevStatus;
	int msgCount;
	char error;

	for (;;) {

		const int timeout = 100000; // Define number of iterations to quit if status does not change

		do {
			print("\t0: Exit\r\n");
			print("\t1: Left Shift\r\n");
			print("\t2: Right Shift\r\n");
			print("\t3: Blank LED\r\n");

			print("\t4: Left Shift  4 to 7\r\n");
			print("\t5: Right Shift 4 to 7\r\n");
			print("\t6: Blank LED   4 to 7\r\n");


			print("> ");

			OptionNext = inbyte();
			if (isalpha(OptionNext)) {
				OptionNext = toupper(OptionNext);
			}

			xil_printf("%c\r\n", OptionNext);
		} while (!isdigit(OptionNext));

		switch (OptionNext) {
			case '0':
				return 0;
				break;

			case '1':
				xil_printf("Generating software trigger for LED shift left reconfiguration\r\n");

				if(!(Xil_In32(rp_shift_03_SW_TRIGGER) & 0x8000)) {
					xil_printf("Starting LED shift left Reconfiguration\r\n");
					Xil_Out32(rp_shift_03_SW_TRIGGER,0);
				}

				prevStatus = -1;
				msgCount = 0;
				error = 1;
				for (int currentCount = 0; currentCount < timeout; currentCount++) {
					Status = Xil_In32(rp_shift_03_STATUS);

					if ((Status & 0x7) == 7) {
						error = 0;
						break;
					} else if (msgCount > 20) {
						break;
					}

					if (Status != prevStatus) {
						display_status(rp_shift_03_SW_TRIGGER, rp_shift_03_STATUS);
						currentCount = 0;
						msgCount++;
					}

					prevStatus = Status;
				}

				if (error) {
					print("Configuration failed\r\n.");
				} else {
					xil_printf("Shift left Reconfiguration Completed!\r\n");
				}
				break;

			case '2':
				xil_printf("Generating software trigger for LED shift right reconfiguration\r\n");

				if(!(Xil_In32(rp_shift_03_SW_TRIGGER) & 0x8000)) {
					xil_printf("Starting LED shift right Reconfiguration\r\n");
					Xil_Out32(rp_shift_03_SW_TRIGGER,1);
				}

				prevStatus = -1;
				msgCount = 0;
				error = 1;
				for (int currentCount = 0; currentCount < timeout; currentCount++) {
					Status = Xil_In32(rp_shift_03_STATUS);

					if ((Status & 0x7) == 7) {
						error = 0;
						break;
					} else if (msgCount > 20) {
						break;
					}

					if (Status != prevStatus) {
						display_status(rp_shift_03_SW_TRIGGER, rp_shift_03_STATUS);
						currentCount = 0;
						msgCount++;
					}

					prevStatus = Status;
				}

				if (error) {
					print("Configuration failed\r\n.");
				} else {
					xil_printf("Right shifting LED module Reconfiguration Completed!\r\n");
				}
				break;


			case '3':
				xil_printf("Generating software trigger for LED Blanking reconfiguration\r\n");

				if(!(Xil_In32(rp_shift_03_SW_TRIGGER) & 0x8000)) {
					xil_printf("Starting LED Blanking Reconfiguration\r\n");
					Xil_Out32(rp_shift_03_SW_TRIGGER,2);
				}

				prevStatus = -1;
				msgCount = 0;
				error = 1;
				for (int currentCount = 0; currentCount < timeout; currentCount++) {
					Status = Xil_In32(rp_shift_03_STATUS);

					if ((Status & 0x7) == 7) {
						error = 0;
						break;
					} else if (msgCount > 20) {
						break;
					}

					if (Status != prevStatus) {
						display_status(rp_shift_03_SW_TRIGGER, rp_shift_03_STATUS);
						currentCount = 0;
						msgCount++;
					}

					prevStatus = Status;
				}

				if (error) {
					print("Configuration failed\r\n.");
				} else {
					xil_printf("Blanking LED module Reconfiguration Completed!\r\n");
				}
				break;

			case '4':
				xil_printf("Generating software trigger for LED shift left 4 to 7 reconfiguration\r\n");

				if(!(Xil_In32(rp_shift_47_SW_TRIGGER) & 0x8000)) {
					xil_printf("Starting LED shift left 47 Reconfiguration\r\n");
					Xil_Out32(rp_shift_47_SW_TRIGGER,0);
				}

				prevStatus = -1;
				msgCount = 0;
				error = 1;
				for (int currentCount = 0; currentCount < timeout; currentCount++) {
					Status = Xil_In32(rp_shift_47_STATUS);

					if ((Status & 0x7) == 7) {
						error = 0;
						break;
					} else if (msgCount > 20) {
						break;
					}

					if (Status != prevStatus) {
						display_status(rp_shift_47_SW_TRIGGER, rp_shift_47_STATUS);
						currentCount = 0;
						msgCount++;
					}

					prevStatus = Status;
				}

				if (error) {
					print("Configuration failed\r\n.");
				} else {
					xil_printf("Shift left Reconfiguration Completed!\r\n");
				}
				break;

			case '5':
				xil_printf("Generating software trigger for LED shift right reconfiguration\r\n");

				if(!(Xil_In32(rp_shift_47_SW_TRIGGER) & 0x8000)) {
					xil_printf("Starting LED shift right 4 to 7 Reconfiguration\r\n");
					Xil_Out32(rp_shift_47_SW_TRIGGER,1);
				}

				prevStatus = -1;
				msgCount = 0;
				error = 1;
				for (int currentCount = 0; currentCount < timeout; currentCount++) {
					Status = Xil_In32(rp_shift_47_STATUS);

					if ((Status & 0x7) == 7) {
						error = 0;
						break;
					} else if (msgCount > 20) {
						break;
					}

					if (Status != prevStatus) {
						display_status(rp_shift_47_SW_TRIGGER, rp_shift_47_STATUS);
						currentCount = 0;
						msgCount++;
					}

					prevStatus = Status;
				}

				if (error) {
					print("Configuration failed\r\n.");
				} else {
					xil_printf("Right shifting LED module 4 to 7 Reconfiguration Completed!\r\n");
				}
				break;

			case '6':
				xil_printf("Generating software trigger for LED Blanking 4 to 7 reconfiguration\r\n");

				if(!(Xil_In32(rp_shift_47_SW_TRIGGER) & 0x8000)) {
					xil_printf("Starting LED Blanking 4 to 7 Reconfiguration\r\n");
					Xil_Out32(rp_shift_47_SW_TRIGGER,2);
				}

				prevStatus = -1;
				msgCount = 0;
				error = 1;
				for (int currentCount = 0; currentCount < timeout; currentCount++) {
					Status = Xil_In32(rp_shift_47_STATUS);

					if ((Status & 0x7) == 7) {
						error = 0;
						break;
					} else if (msgCount > 20) {
						break;
					}

					if (Status != prevStatus) {
						display_status(rp_shift_47_SW_TRIGGER, rp_shift_47_STATUS);
						currentCount = 0;
						msgCount++;
					}

					prevStatus = Status;
				}

				if (error) {
					print("Configuration failed\r\n.");
				} else {
					xil_printf("Blanking LED module 4 to 7 Reconfiguration Completed!\r\n");
				}
				break;



			default:
				break;
		}
	}

    return 0;
}

