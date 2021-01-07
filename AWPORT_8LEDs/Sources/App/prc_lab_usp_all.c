/**************************************************************************
*
*     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
*     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR
*     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION
*     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION
*     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS
*     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
*     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
*     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
*     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
*     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
*     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
*     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
*     FOR A PARTICULAR PURPOSE.
*
*     (c) Copyright 2010 Xilinx, Inc.
*     All rights reserved.
*
**************************************************************************/

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

#include "xprc.h"
#include "xilfpga.h"
#include "xfpga_config.h"
#include "xgpiops.h"


// Parameters for Partial Reconfiguration
#define ADDLEFT_SIZE  6627695 // 26,510,780
#define XFPGA_PARTIAL_EN		(0x00000001U)

#define PARTIAL_ADDER_ADDR   0x200000
#define PARTIAL_MULT_ADDR   0x300000
#define PARTIAL_LEFT_ADDR   0x400000
#define PARTIAL_RIGHT_ADDR   0x500000
#define PARTIAL_BLANK_MATH_ADDR   0x600000
#define PARTIAL_BLANK_SHIFT_ADDR   0x700000
#define PARTIAL_MULT_BITFILE_LEN  150874 // in number of words 603,496 bytes, properties -> size. not size on disk.
#define PARTIAL_ADDER_BITFILE_LEN  150874 // in number of words 603,496 bytes
#define PARTIAL_BLANK_MATH_BITFILE_LEN  150874 // in number of words 603,496 bytes
#define PARTIAL_LEFT_BITFILE_LEN 173368 // in number of words
#define PARTIAL_RIGHT_BITFILE_LEN 173368 // in number of words
#define PARTIAL_BLANK_SHIFT_BITFILE_LEN 173368 // in number of words

#define PARTIAL_MULT_BITFILE_LENp  153434 // in number of words 613,736
#define PARTIAL_ADDER_BITFILE_LENp  153434 // in number of words 613,736
#define PARTIAL_BLANK_MATH_BITFILE_LENp  153434 // in number of words 613,736
#define PARTIAL_LEFT_BITFILE_LENp 175928 // in number of words 703,712
#define PARTIAL_RIGHT_BITFILE_LENp 175928 // in number of words 703,712
#define PARTIAL_BLANK_SHIFT_BITFILE_LENp 175928 // in number of words 703,712

#define FRAMES		         71261
#define WORDS_PER_FRAME      93
#define PAD_FRAMES	         25





// address space for the prc_0 instance
//| Virtual Socket Manager | Register     | Address |
//+------------------------+--------------+---------+
//| rp_math                | STATUS       | 0X00000 |
//| rp_math                | CONTROL      | 0X00000 |
//| rp_math                | SW_TRIGGER   | 0X00004 |
//| rp_math                | TRIGGER0     | 0X00040 |
//| rp_math                | TRIGGER1     | 0X00044 |
//| rp_math                | TRIGGER2     | 0X00048 |
//| rp_math                | TRIGGER3     | 0X0004C |
//| rp_math                | RM_BS_INDEX0 | 0X00080 |
//| rp_math                | RM_CONTROL0  | 0X00084 |
//| rp_math                | RM_BS_INDEX1 | 0X00088 |
//| rp_math                | RM_CONTROL1  | 0X0008C |
//| rp_math                | RM_BS_INDEX2 | 0X00090 |
//| rp_math                | RM_CONTROL2  | 0X00094 |
//| rp_math                | RM_BS_INDEX3 | 0X00098 |
//| rp_math                | RM_CONTROL3  | 0X0009C |
//| rp_math                | BS_ID0       | 0X000C0 |
//| rp_math                | BS_ADDRESS0  | 0X000C4 |
//| rp_math                | BS_SIZE0     | 0X000C8 |
//| rp_math                | BS_ID1       | 0X000D0 |
//| rp_math                | BS_ADDRESS1  | 0X000D4 |
//| rp_math                | BS_SIZE1     | 0X000D8 |
//| rp_math                | BS_ID2       | 0X000E0 |
//| rp_math                | BS_ADDRESS2  | 0X000E4 |
//| rp_math                | BS_SIZE2     | 0X000E8 |
//| rp_math                | BS_ID3       | 0X000F0 |
//| rp_math                | BS_ADDRESS3  | 0X000F4 |
//| rp_math                | BS_SIZE3     | 0X000F8 |
//| rp_shift               | STATUS       | 0X00100 |
//| rp_shift               | CONTROL      | 0X00100 |
//| rp_shift               | SW_TRIGGER   | 0X00104 |
//| rp_shift               | TRIGGER0     | 0X00140 |
//| rp_shift               | TRIGGER1     | 0X00144 |
//| rp_shift               | TRIGGER2     | 0X00148 |
//| rp_shift               | TRIGGER3     | 0X0014C |
//| rp_shift               | RM_BS_INDEX0 | 0X00180 |
//| rp_shift               | RM_CONTROL0  | 0X00184 |
//| rp_shift               | RM_BS_INDEX1 | 0X00188 |
//| rp_shift               | RM_CONTROL1  | 0X0018C |
//| rp_shift               | RM_BS_INDEX2 | 0X00190 |
//| rp_shift               | RM_CONTROL2  | 0X00194 |
//| rp_shift               | RM_BS_INDEX3 | 0X00198 |
//| rp_shift               | RM_CONTROL3  | 0X0019C |
//| rp_shift               | BS_ID0       | 0X001C0 |
//| rp_shift               | BS_ADDRESS0  | 0X001C4 |
//| rp_shift               | BS_SIZE0     | 0X001C8 |
//| rp_shift               | BS_ID1       | 0X001D0 |
//| rp_shift               | BS_ADDRESS1  | 0X001D4 |
//| rp_shift               | BS_SIZE1     | 0X001D8 |
//| rp_shift               | BS_ID2       | 0X001E0 |
//| rp_shift               | BS_ADDRESS2  | 0X001E4 |
//| rp_shift               | BS_SIZE2     | 0X001E8 |
//| rp_shift               | BS_ID3       | 0X001F0 |
//| rp_shift               | BS_ADDRESS3  | 0X001F4 |
//| rp_shift               | BS_SIZE3     | 0X001F8 |

#define rp_math_STATUS      XPAR_PRC_0_BASEADDR+0X00000
#define rp_math_CONTROL     XPAR_PRC_0_BASEADDR+0X00000
#define rp_math_SW_TRIGGER  XPAR_PRC_0_BASEADDR+0X00004
#define rp_math_TRIGGER0    XPAR_PRC_0_BASEADDR+0X00040
#define rp_math_TRIGGER1    XPAR_PRC_0_BASEADDR+0X00044
#define rp_math_TRIGGER2    XPAR_PRC_0_BASEADDR+0X00048
#define rp_math_TRIGGER3    XPAR_PRC_0_BASEADDR+0X0004C

//| rp_math                | BS_ID0       | 0X000C0 |
//| rp_math                | BS_ID1       | 0X000D0 |
//| rp_math                | BS_ID2       | 0X000E0 |
//| rp_math                | BS_ID3       | 0X000F0 |

#define rp_math_RM_ADDRESS0 XPAR_PRC_0_BASEADDR+0X00080
#define rp_math_RM_CONTROL0 XPAR_PRC_0_BASEADDR+0X00084
#define rp_math_RM_ADDRESS1 XPAR_PRC_0_BASEADDR+0X00088
#define rp_math_RM_CONTROL1 XPAR_PRC_0_BASEADDR+0X0008C
#define rp_math_RM_ADDRESS2 XPAR_PRC_0_BASEADDR+0X00090
#define rp_math_RM_CONTROL2 XPAR_PRC_0_BASEADDR+0X00094
#define rp_math_RM_ADDRESS3 XPAR_PRC_0_BASEADDR+0X00098
#define rp_math_RM_CONTROL3 XPAR_PRC_0_BASEADDR+0X0009C
#define rp_math_BS_ADDRESS0 XPAR_PRC_0_BASEADDR+0X000C4
#define rp_math_BS_SIZE0    XPAR_PRC_0_BASEADDR+0X000C8
#define rp_math_BS_ADDRESS1 XPAR_PRC_0_BASEADDR+0X000D4
#define rp_math_BS_SIZE1    XPAR_PRC_0_BASEADDR+0X000D8
#define rp_math_BS_ADDRESS2 XPAR_PRC_0_BASEADDR+0X000E4
#define rp_math_BS_SIZE2    XPAR_PRC_0_BASEADDR+0X000E8
#define rp_math_BS_ADDRESS3 XPAR_PRC_0_BASEADDR+0X000F4
#define rp_math_BS_SIZE3    XPAR_PRC_0_BASEADDR+0X000F8

#define rp_shift_STATUS      XPAR_PRC_0_BASEADDR+0X00100
#define rp_shift_CONTROL     XPAR_PRC_0_BASEADDR+0X00100
#define rp_shift_SW_TRIGGER  XPAR_PRC_0_BASEADDR+0X00104
#define rp_shift_TRIGGER0    XPAR_PRC_0_BASEADDR+0X00140
#define rp_shift_TRIGGER1    XPAR_PRC_0_BASEADDR+0X00144
#define rp_shift_TRIGGER2    XPAR_PRC_0_BASEADDR+0X00148
#define rp_shift_TRIGGER3    XPAR_PRC_0_BASEADDR+0X0014C

#define rp_shift_RM_ADDRESS0 XPAR_PRC_0_BASEADDR+0X00180
#define rp_shift_RM_CONTROL0 XPAR_PRC_0_BASEADDR+0X00184
#define rp_shift_RM_ADDRESS1 XPAR_PRC_0_BASEADDR+0X00188
#define rp_shift_RM_CONTROL1 XPAR_PRC_0_BASEADDR+0X0018C
#define rp_shift_RM_ADDRESS2 XPAR_PRC_0_BASEADDR+0X00190
#define rp_shift_RM_CONTROL2 XPAR_PRC_0_BASEADDR+0X00194
#define rp_shift_RM_ADDRESS3 XPAR_PRC_0_BASEADDR+0X00198
#define rp_shift_RM_CONTROL3 XPAR_PRC_0_BASEADDR+0X0019C

//| rp_shift               | BS_ID1       | 0X001D0 |
//| rp_shift               | BS_ID2       | 0X001E0 |
//| rp_shift               | BS_ID2       | 0X001E0 |
//| rp_shift               | BS_ID3       | 0X001F0 |

#define rp_shift_BS_ADDRESS0 XPAR_PRC_0_BASEADDR+0X001C4
#define rp_shift_BS_SIZE0    XPAR_PRC_0_BASEADDR+0X001C8
#define rp_shift_BS_ADDRESS1 XPAR_PRC_0_BASEADDR+0X001D4
#define rp_shift_BS_SIZE1    XPAR_PRC_0_BASEADDR+0X001D8
#define rp_shift_BS_ADDRESS2 XPAR_PRC_0_BASEADDR+0X001E4
#define rp_shift_BS_SIZE2    XPAR_PRC_0_BASEADDR+0X001E8
#define rp_shift_BS_ADDRESS3 XPAR_PRC_0_BASEADDR+0X001F4
#define rp_shift_BS_SIZE3    XPAR_PRC_0_BASEADDR+0X001F8
// Read function for STDIN
extern char inbyte(void);


static FATFS fatfs;

// Driver Instantiations
static XCsuDma_Config *XCsuDma_0;
XCsuDma DcfgInstance;
XCsuDma *DcfgInstPtr;

int SD_Init()
{
	FRESULT rc;

	rc = f_mount(&fatfs, "", 0);
	if (rc > 0) {
		xil_printf(" ERROR : f_mount returned %d\r\n", rc);
		return XST_FAILURE;
	}

	return XST_SUCCESS;
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

// Function to write a specific file to SD Card - File will be overwritten
int writeToSD(char *fileName, u32 data[], UINT bytesToWrite, UINT* bytesWritten, u32 NumFrames) {

	FIL fp; /* File pointer */
	FATFS fatfs;
	TCHAR *Path = "0:/";
	FRESULT res;

	// Mount file system
	res = f_mount(&fatfs, Path, 0);
	if (res) {
			xil_printf("ERROR: f_mount returned %d\r\n", res);
			return XST_FAILURE;
	}

	// Overwrite file, and open with rw permissions
	res = f_open(&fp, fileName, FA_OPEN_ALWAYS | FA_WRITE | FA_READ);
	if (res) {
		xil_printf("ERROR: f_open returned %d\r\n", res);
		return XST_FAILURE;
	}

	// Set file Pointer to begin of file.
	res = f_lseek(&fp, f_size(&fp));
	if (res) {
		xil_printf("ERROR: f_lseek returned %d\r\n", res);
		return XST_FAILURE;
	}

	// Write data to file and check if we ran out of space
	for (int i = CFGDATA_DSTDMA_OFFSET/4; i < NumFrames; i+=1) {

		res = f_write(&fp, &data[i], bytesToWrite, bytesWritten);
		if (res) {
			xil_printf("ERROR: f_write returned %d\r\n", res);
			return XST_FAILURE;
		}

		if (*bytesWritten < bytesToWrite) {
			xil_printf("ERROR: Disk space was insufficient.");
			return XST_FAILURE;
		}
	}


	// Close file
	res = f_close(&fp);
	if (res) {
		xil_printf("ERROR: f_close returned %d\r\n", res);
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

int SD_TransferPartial_rev(char *FileName, u32 DestinationAddress, u32 ByteLength)
{
	FIL fil; /* File pointer */
	FATFS fatfs;
	TCHAR *Path = "0:/";
	FRESULT rc;
	UINT br;



	//init_platform();
	rc = f_mount(&fatfs, Path, 0);
	if (rc) {
			xil_printf(" ERROR : f_mount returned %d\r\n", rc);
			return XST_FAILURE;
		}

	rc = f_open(&fil, FileName, FA_CREATE_ALWAYS | FA_WRITE);
	if (rc) {
		xil_printf(" ERROR : f_open returned %d\r\n", rc);
		return XST_FAILURE;
	}

	display_fil(&fil);

	rc = f_lseek(&fil, 0);
	if (rc) {
		xil_printf(" ERROR : f_lseek returned %d\r\n", rc);
		return XST_FAILURE;
	}

	rc = f_write(&fil, (void*) DestinationAddress, ByteLength, &br);
	if (rc) {
		xil_printf(" ERROR : f_write returned %d\r\n", rc);
		return XST_FAILURE;
	}

	rc = f_close(&fil);
	if (rc) {
		xil_printf(" ERROR : f_close returned %d\r\n", rc);
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

void display_fil(FIL fil) {
//	xil_printf("FFOBJID obj= %x\r\n",  fil.obj);          /* Object identifier */
	xil_printf("BYTE    flag= %x\r\n",  fil.flag);         /* File object status flags */
	xil_printf("BYTE    err= %x\r\n",  fil.err);          /* Abort flag (error code) */
	xil_printf("FSIZE_t fptr= %x\r\n",  fil.fptr);         /* File read/write pointer (Byte offset origin from top of the file) */
	xil_printf("DWORD   clust= %x\r\n",  fil.clust);        /* Current cluster of fptr (One cluster behind if fptr is on the cluster boundary. Invalid if fptr == 0.) */
//	xil_printf("DWORD   sect= %x\r\n",  fil.sect);

    }

int getNumber (){

	unsigned char byte;
	unsigned char uartBuffer[16];
	unsigned char validNumber;
	int digitIndex;
	int digit, number, sign;
	int c;

	while(1){
		byte = 0x00;
		digit = 0;
		digitIndex = 0;
		number = 0;
		validNumber = TRUE;

		//get bytes from uart until RETURN is entered

		while(byte != 0x0d){
			byte = inbyte();
			uartBuffer[digitIndex] = byte;
			xil_printf("%c", byte);
			digitIndex++;
		}

		//calculate number from string of digits

		for(c = 0; c < (digitIndex - 1); c++){
			if(c == 0){
				//check if first byte is a "-"
				if(uartBuffer[c] == 0x2D){
					sign = -1;
					digit = 0;
				}
				//check if first byte is a digit
				else if((uartBuffer[c] >> 4) == 0x03){
					sign = 1;
					digit = (uartBuffer[c] & 0x0F);
				}
				else
					validNumber = FALSE;
			}
			else{
				//check byte is a digit
				if((uartBuffer[c] >> 4) == 0x03){
					digit = (uartBuffer[c] & 0x0F);
				}
				else
					validNumber = FALSE;
			}
			number = (number * 10) + digit;
		}
		number *= sign;
		if(validNumber == TRUE){
			return number;
		}
		print("This is not a valid number.\n\r");
	}
}

void get_operands(void)
{
	int first, second;

	print("First operand: ");
	first = getNumber();
	print("\r\n");
	print("Second operand: ");
	second = getNumber();
	print("\r\n");
	Xil_Out32(XPAR_MATH_0_S00_AXI_BASEADDR,first);
	Xil_Out32(XPAR_MATH_0_S00_AXI_BASEADDR+4,second);
	xil_printf("Result: %d\n\r",Xil_In32(XPAR_MATH_0_S00_AXI_BASEADDR+8));
}


void setPRC_Registers(){
	Xil_Out32(rp_math_CONTROL,0);
	//Waiting for the shutdown to occur
	while(!(Xil_In32(rp_math_STATUS)&0x80));
	//Math RP is shutdown
	//Putting the PRC core's SHIFT RP in Shutdown mode
	Xil_Out32(rp_shift_CONTROL,0);
	//Waiting for the shutdown to occur
	while(!(Xil_In32(rp_shift_STATUS)&0x80));
	//Shift RP is shutdown
	//Initializing RM bitstream address and size registers for Math and Shift RMs
	Xil_Out32(rp_math_BS_ADDRESS0,PARTIAL_ADDER_ADDR);
	Xil_Out32(rp_math_BS_ADDRESS1,PARTIAL_MULT_ADDR);
	Xil_Out32(rp_math_BS_ADDRESS2,PARTIAL_BLANK_MATH_ADDR);
	Xil_Out32(rp_math_BS_SIZE0,PARTIAL_ADDER_BITFILE_LEN<<2);
	Xil_Out32(rp_math_BS_SIZE1,PARTIAL_MULT_BITFILE_LEN<<2);
	Xil_Out32(rp_math_BS_SIZE2,PARTIAL_BLANK_MATH_BITFILE_LEN<<2);

	Xil_Out32(rp_shift_BS_ADDRESS0,PARTIAL_LEFT_ADDR);
	Xil_Out32(rp_shift_BS_ADDRESS1,PARTIAL_RIGHT_ADDR);
	Xil_Out32(rp_shift_BS_ADDRESS2,PARTIAL_BLANK_SHIFT_ADDR);
	Xil_Out32(rp_shift_BS_SIZE0,PARTIAL_LEFT_BITFILE_LEN<<2);
	Xil_Out32(rp_shift_BS_SIZE1,PARTIAL_RIGHT_BITFILE_LEN<<2);
	Xil_Out32(rp_shift_BS_SIZE2,PARTIAL_BLANK_SHIFT_BITFILE_LEN<<2);

	//Initializing RM trigger ID registers for Math and Shift RMs
	Xil_Out32(rp_math_TRIGGER0,0);
	Xil_Out32(rp_math_TRIGGER1,1);
	Xil_Out32(rp_math_TRIGGER2,2);
	Xil_Out32(rp_shift_TRIGGER0,0);
	Xil_Out32(rp_shift_TRIGGER1,1);
	Xil_Out32(rp_shift_TRIGGER2,2);

	//Initializing RM address and control registers for Math and Shift RMs
	Xil_Out32(rp_math_RM_ADDRESS0,0);
	Xil_Out32(rp_math_RM_ADDRESS1,1);
	Xil_Out32(rp_math_RM_ADDRESS2,2);
	Xil_Out32(rp_math_RM_CONTROL0,0);
	Xil_Out32(rp_math_RM_CONTROL1,0);
	Xil_Out32(rp_math_RM_CONTROL2,0);

	Xil_Out32(rp_shift_RM_ADDRESS0,0);
	Xil_Out32(rp_shift_RM_ADDRESS1,1);
	Xil_Out32(rp_shift_RM_ADDRESS2,2);
	Xil_Out32(rp_shift_RM_CONTROL0,0);
	Xil_Out32(rp_shift_RM_CONTROL1,0);
	Xil_Out32(rp_shift_RM_CONTROL2,0);
	//Putting the PRC core's Math RP in Restart with Status mode
	Xil_Out32(rp_math_CONTROL,2);
	//Putting the PRC core's SHIFT RP in Restart with Status mode
	Xil_Out32(rp_shift_CONTROL,2);
	xil_printf("Reading the Math RP status=%x\n\r",Xil_In32(rp_math_STATUS));
	xil_printf("Reading the SHIFT RP status=%x\n\r",Xil_In32(rp_shift_STATUS));
}

/*
 * TODO: FFix this really dirty declaration!
 */
u32 readback_buffer[WORDS_PER_FRAME*FRAMES + PAD_FRAMES];

void PrintBitStream(u32 NumFrames)
{
	xil_printf("Bitstream contents are beeing written to file...\r\n");

	writeToSD("Readback.bin", readback_buffer, sizeof(readback_buffer[0]), malloc(sizeof(readback_buffer[0])), NumFrames);

	xil_printf("Stream written to file.\r\n");

}

/*void PrintBitStream_debug(u32 NumFrames)
{
	int i;

	xil_printf("Bitstream contents are\r\n");

/*	use -raw_bitfile in write_bitstream code in synt,
	it will have bitstream in text file,
	then look at the bitstream format for us+
	then from the rawbitstream file, check what is the starting frame address of partial bitstream,
	then use this function to print those frames,
	use size as bitstream size as end of loop


	for (i = CFGDATA_DSTDMA_OFFSET/4; i < NumFrames; i+=4) {

		            (readback_buffer[i] >> 16), (readback_buffer[i] & 0xFFFF),
					(readback_buffer[i+1] >> 16), (readback_buffer[i+1] & 0xFFFF),
		            (readback_buffer[i+2] >> 16), (readback_buffer[i+2] & 0xFFFF),
					(readback_buffer[i+3] >> 16), (readback_buffer[i+3] & 0xFFFF));
	}
}


*/

/*
 * This function initiates either ICAP or PCAP interface.
 *
 * @param iface: 0x00 for PCAP, 0x01 for ICAP
 *
 * @return XST_SUCCESS on success, XST_FAILURE on failure
 */
int initInterface(unsigned char iface) {

	switch (iface) {
		case 0x00:
			// Begin initialisation of PCAP as of p. 297 of UG1085 V.1.9 without reset
			Xil_Out32(CSU_PCAP_RESET, (u32) 0x1);
			Xil_Out32(CSU_PCAP_CTRL , (u32) 0x1);
			Xil_Out32(CSU_PCAP_RDWR, (u32) 0x0);
			break;
		case 0x01:
			// Begin initialisation of ICAP
			Xil_Out32(CSU_PCAP_RESET, (u32) 0x1);
			Xil_Out32(CSU_PCAP_CTRL , (u32) 0x0);
			break;
		default:
			return XST_FAILURE;
	}

	return XST_SUCCESS;
}

void resetPL(void) {
	initInterface((unsigned char) 0x00);
	Xil_Out32(CSU_PCAP_PROG, (u32) 0x0);
	sleep(1);
	Xil_Out32(CSU_PCAP_PROG, (u32) 0x1);


}


static int XFpga_ReadExample(void)
{
	u32 Status = XST_SUCCESS;
	XFpga_Info PLInfo = {0};

	PLInfo.NumFrames = WORDS_PER_FRAME * FRAMES + PAD_FRAMES;
	PLInfo.ReadbackAddr = (UINTPTR)readback_buffer;
	Status = XFpga_GetPlConfigData(&PLInfo);
	if (Status != XST_SUCCESS) {
		xil_printf("FPGA Configuration Read back Failed\n");
		return Status;
	}

	PrintBitStream(PLInfo.NumFrames);
	return Status;
}



int main()
{
	int Status;
	char configPCAP = 0x00;

	// Initialize Device Configuration Interface
	DcfgInstPtr = &DcfgInstance;
	XCsuDma_0 = XCsuDma_LookupConfig(XPAR_XCSUDMA_0_DEVICE_ID) ;
	Status =  XCsuDma_CfgInitialize(DcfgInstPtr, XCsuDma_0, XCsuDma_0->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	// Display Menu
    int OptionNext = 1; // start-up default
	for (;;) {
		do {
			print("\t1: Adder and Left using PCAP\n\r");
			print("\t2: Mult and Right using ICAP (XPrc)\n\r");
			print("\t3: Adder and Left ICAP\n\r");
			print("\t4: Blank using ICAP\n\r");
			print("\t5: Enter operands\n\r");
			print("\t6: Readback Configuration\n\r");
			print("\t7: ReadBack left led from RAM\n\r");
			print("\t0: Exit\n\r");
			print("> ");

			OptionNext = inbyte();
			if (isalpha(OptionNext)) {
				OptionNext = toupper(OptionNext);
			}

			xil_printf("%c\n\r", OptionNext);
		} while (!isdigit(OptionNext));

		switch (OptionNext) {
			case '0':
				return 0;
				break;

			case '1':

				xil_printf("PCAP STATUS = %x\r\n",Xil_In32(CSU_PCAP_STATUS));

				xil_printf("\nAdder and Left using PCAP\r\n");
				Xil_DCacheDisable();

				// Initialize SD controller and transfer partials to DDR
				Status = SD_Init();
				if (Status != XST_SUCCESS) {
					xil_printf("Failed to mount SD card\r\n");
					break;
				}

				Status = SD_TransferPartial("addp.bin", PARTIAL_ADDER_ADDR, (PARTIAL_ADDER_BITFILE_LENp << 2));
				if (Status != XST_SUCCESS) {
					xil_printf("Loading addp.bin from SD card failed\r\n");
					break;
				}

				Status = SD_TransferPartial("leftp.bin", PARTIAL_LEFT_ADDR, (PARTIAL_LEFT_BITFILE_LENp << 2));
				if (Status != XST_SUCCESS) {
					xil_printf("Loading leftp.bin from SD card failed\r\n");
					break;
				}

				xil_printf("Partial Binaries transferred successfully!\r\n");
				Xil_DCacheEnable();

				Status = XFpga_PL_BitStream_Load(PARTIAL_LEFT_ADDR, (PARTIAL_LEFT_BITFILE_LENp << 2), XFPGA_PARTIAL_EN);
				if (Status != XST_SUCCESS) {
					xil_printf("Adder PR failed\r\n");
				} else {
					xil_printf("Adder PR Successful\r\n");
				}

				Status = XFpga_PL_BitStream_Load(PARTIAL_ADDER_ADDR, (PARTIAL_ADDER_BITFILE_LENp << 2), XFPGA_PARTIAL_EN);
				if (Status != XST_SUCCESS) {
					xil_printf("Left PR failed\r\n");
				} else {
					xil_printf("Left PR Successful\r\n");
				}

				configPCAP = 0x01;

				break;
			case '2':
				xil_printf("\nMult and Right using ICAP (XPrc) - Not supported\r\n");
				break;
			case '3':
				xil_printf("\nAdder and Left ICAP\r\n");
				Xil_DCacheDisable();

				// Initialize SD controller and transfer partials to DDR
				if (SD_Init() != XST_SUCCESS) {
					xil_printf("Failed to mount SD card\r\n");
					break;
				}

				Status = SD_TransferPartial("add.bin", PARTIAL_ADDER_ADDR, (PARTIAL_ADDER_BITFILE_LEN << 2));
				if (Status != XST_SUCCESS) {
					xil_printf("Loading add.bin from SD card failed\r\n");
					break;
				}
				Status = SD_TransferPartial("left.bin", PARTIAL_LEFT_ADDR, (PARTIAL_LEFT_BITFILE_LEN << 2));
				if (Status != XST_SUCCESS) {
					xil_printf("Loading left.bin from SD card failed\r\n");
					break;
				}
				xil_printf("Partial Binaries transferred successfully!\r\n");
				Xil_DCacheEnable();

				setPRC_Registers();
				Status = initInterface((unsigned char) 0x01);
				xil_printf("CSU_PCAP_CTRL = %x\r\n",Xil_In32(CSU_PCAP_CTRL));
				Xil_Out32(rp_math_SW_TRIGGER, 0);  // Software trigger register is being assigned to trigger Addition RM
				Xil_Out32(rp_shift_SW_TRIGGER,0); // Software trigger register is being assigned to trigger Left Shift RM
				configPCAP = 0x00;
				xil_printf("Adder and Shift Left ICAP without driver Reconfiguration is Completed!\n\r");

				break;
			case '4':
				xil_printf("\nBlank using ICAP\r\n");

				Xil_DCacheDisable();
				// Initialize SD controller and transfer partials to DDR
				if (SD_Init() != XST_SUCCESS) {
					xil_printf("Failed to mount SD card\r\n");
					break;
				}

				Status = SD_TransferPartial("bmath.bin", PARTIAL_BLANK_MATH_ADDR, (PARTIAL_BLANK_MATH_BITFILE_LEN << 2));
				if (Status != XST_SUCCESS) {
					xil_printf("Loading bmath.bin from SD card failed\r\n");
					break;
				}

				Status = SD_TransferPartial("bled.bin", PARTIAL_BLANK_SHIFT_ADDR, (PARTIAL_BLANK_SHIFT_BITFILE_LEN << 2));
				if (Status != XST_SUCCESS) {
					xil_printf("Loading bled.bin from SD card failed\r\n");
					break;
				}

				// Invalidate and enable Data Cache
				Xil_DCacheEnable();
				setPRC_Registers();
				Status = initInterface((unsigned char) 0x01);
				xil_printf("CSU_PCAP_CTRL = %x\r\n",Xil_In32(CSU_PCAP_CTRL));
				Xil_Out32(rp_math_SW_TRIGGER,2);  // Software trigger register is being assigned to trigger Addition RM
				Xil_Out32(rp_shift_SW_TRIGGER,2);
				configPCAP = 0x00;
				break;

			case '5':
				get_operands();
				break;

			case '6':

				if (!configPCAP) {
					print("Please configure the device via PCAP to perform a readback operation.\r\n");
					break;
				}
				xil_printf("\nReadback Configuration\r\n");
				Status = initInterface((unsigned char) 0x00);

				Status = XFpga_ReadExample();
			 	if (Status != XST_SUCCESS) {
					xil_printf("FPGA Configuration Read back example Failed\r\n");
					break;
				}

				xil_printf("Successfully ran FPGA Configuration Read back example\r\n");
				break;

			case '7':
				xil_printf("\nReadBack left led from RAM\r\n");
				SD_TransferPartial_rev("left_rev.bin", PARTIAL_LEFT_ADDR, (PARTIAL_LEFT_BITFILE_LEN << 2));
				break;

			default:
				break;
		}
	}

    return 0;
}


