# -*- coding: utf-8 -*-
"""
Created on Tue Jun 16 10:16:40 2020


@author: khazi
"""

# rootPath is the root folder path where the all the Bitstream folders are loacted
rootPath = "C:/Users/khazi/projects/MT/dpr_fine_grain/All_BS/"
filePath = rootPath + 'FAR_output.txt'

outFile = 'FAR_output_hex1.txt'

def Bin2Hex():
    """ Convert the 32 bit Binary FAR values
        to        
        Hexadecimal Equivalent"""
    
    file1 = open(filePath, 'r') 
    Lines = file1.readlines() 
    file2 = open(outFile, 'w+')

    for lines in Lines:
        line = lines[0:32]
        if line.startswith('B') or line.startswith('D') or line.startswith('X'):
            file2.write('\r')
            file2.write(line)
            
        else:
            bytes_str = bytes(line, 'utf-8')
            new_bytes = bytes_str.zfill(31)
            temp = hex(int(new_bytes, 2))
            print(temp)
          
            file2.write(temp)
            file2.write('\r')
            
    file2.close() 
    file1.close()


    
    
    
  
    