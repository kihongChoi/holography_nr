% RECONSTRUCTION WITH NOISE REDUCION
% hologram noise reduction by frequency histogram apodization
clear; clc;

rD = 70e-3;
lambda = 635e-9;
    
    %createCH;
    openCH;
    res = size(CH, 2);
    
imshowpair(CH_real, CH_imag, 'montage');
title('complex hologram');

fCH = fftshift(fft2(fftshift(CH)));
fCH_re = real(fCH);
fCH_im = imag(fCH);
figure;
imshowpair(fCH_re, fCH_im, 'montage');
title('complex hologram - F.T.');

% method 1 - spatial filter
c = linspace(-res/2, res/2, res); r = c;
[C, R] = meshgrid(c, r);
spFilter = sqrt(C.^2 + R.^2);
spFilter(spFilter > 100) = 0;
spFilter(spFilter ~= 0) = 1;

fCH_filtered = fCH * spFilter;
CH_filtered = fftshift(fft2(fftshift(fCH_filtered)));

figure;
imshowpair(CH_imag, imag(CH_filtered), 'montage')
title('CH - before, and after filtered');

% reconstruction
A1 = fCH_filtered;
p = exp((1j*pi/(lambda*rD)) .* (R.^2 + C.^2));     % fresnel back propagation 
p = fftshift(fft2(fftshift(p)));
antialiased = (1/lambda) * (sqrt(R.^2 + C.^2)/rD);
pupil = antialiased < nfreq;
p = p .* pupil;
Az1 = A1.*p;
EI = fftshift(fft2(fftshift(Az1)));