% RECONSTRUCTION WITH NOISE REDUCION
% hologram noise reduction by frequency histogram apodization
clear; clc;

    %createCH;
    openCH;

fCH = fftshift(fft2(fftshift(CH)));
