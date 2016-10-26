% read images and generate complex hologram (3 step PSH)
h1 = double(imread('h1.tif'));
h2 = double(imread('h2.tif'));
h3 = double(imread('h3.tif'));
CH = h1*(exp(-1j*d3)-exp(-1j*d2)) + h2*(exp(-1j*d1) - exp(-1j*d3)) + h3*(exp(-1j*d2) - exp(-1j*d1));

% save complex hologram into binary file [real imaginary]
CH_real = real(CH);
CH_imag = imag(CH);
adjacent = [CH_real CH_imag];
fileID = fopen('CH.bin', 'w');
fwrite(fileID,adjacent,'double');
fclose(fileID);