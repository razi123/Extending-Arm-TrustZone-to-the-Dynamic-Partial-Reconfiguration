# -*- coding: utf-8 -*-

"""
Created on Tue Jun 16 08:48:24 2020

@author: khazi
"""

from os import listdir, path
from os.path import isfile, join
import os

rootPath = "C:/Users/khazi/projects/MT/dpr_fine_grain/All_BS/New_BS"
FAR_address = "00110000000000000010000000000001";  # 0x30002001
FAR_output = "FAR_output.txt"

folderList = os.listdir(rootPath)
print(folderList)
fileList = [f for f in listdir() if isfile(join('', f)) and f[-3:]=='rbt']



def Pattern():
    #os.remove("FARs.txt")
    if path.isfile('FAR_output.txt'):
        os.remove('FAR_output.txt')
        
   
    count = 0
    for folderName in folderList:
        files = []
        compoName = []
        i = 0
        folderPath = rootPath + '/' + folderName + '/'
    
        for r, d, f in os.walk(folderPath):
            for file in f:
                if '.rbt' in file:
                    files.append(os.path.join(r, file))
                    compoName.append(file)
                    totFiles = len(compoName)
                
       
        for fileName in files:
            count = count + 1
            
            with open(fileName, mode='r') as infile: 
                top = 1;
                for line in infile:
                    if FAR_address in line:
                        #print('Found on line %s: %s' % (i, line))
                        #print('FAR Value on line %s: %s' % (i+1, allFile[i+1])) 
            
                        with open(FAR_output, mode='a+') as fars:
                            if os.stat(FAR_output).st_size == 0:
                                fars.writelines(compoName[i] + "\n")
                                fars.writelines([next(infile)])
                                top = 0
                                if(i< totFiles):
                                    i= i+1
                                else:
                                    i = 0
                                
                            else:
                                if top == 0:
                                    fars.writelines([next(infile)])
                                
                                else:
                                    fars.writelines(compoName[i] + "\n")
                                    fars.writelines([next(infile)])
                                    top = 0
                                    if(i< totFiles):
                                        i= i+1
                                    else:
                                        i = 0
                                        
    print(count)
                                    