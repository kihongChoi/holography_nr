% open complex hologram binary file, and combine (CH.bin)
fileID = fopen('CH.bin');
CH_real = fread(fileID, [2192, 2192], 'double');
CH_imag = fread(fileID, [2192, 2192], 'double');
fclose(fileID);
CH = complex(CH_real, CH_imag);