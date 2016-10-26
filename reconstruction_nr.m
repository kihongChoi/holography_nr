% RECONSTRUCTION WITH NOISE REDUCION
% hologram noise reduction by frequency histogram apodization
clear; clc; close all;

rD = 70e-3;
lambda = 635e-9;
pp = 4.54e-6;
nfreq = 1/(2*sqrt(2)*pp);
gamma = 0.25;
    
    %createCH;
    openCH;
    res = size(CH, 2);
    
% imshowpair(CH_real, CH_imag, 'montage');
% title('complex hologram');

fCH = fftshift(fft2(fftshift(CH)));
fCH_re = real(fCH);
fCH_im = imag(fCH);
% figure;
% imshowpair(fCH_re, fCH_im, 'montage');
% title('complex hologram - F.T.');

% create mesh
r = linspace(-pp*res/2, pp*res/2, res);  
c = r;
[C, R] = meshgrid(r, c);


% conventional reconstruction
A1 = fCH;
p = exp((1j*pi/(lambda*rD)) .* (R.^2 + C.^2));     % fresnel back propagation 
p = fftshift(fft2(fftshift(p)));
antialiased = (1/lambda) * (sqrt(R.^2 + C.^2)/rD);
pupil = antialiased < nfreq;
p = p .* pupil;
Az1 = A1.*p;
EI = fftshift(fft2(fftshift(Az1)));
EI1 = EI .* conj(EI);
EI1 = EI1.^gamma;
imwrite(uint8(255.*EI1./max(max(EI1))), 'img_original.jpg');

% Q(s) generation
p = exp((1j*pi/(lambda*rD)) .* (R.^2 + C.^2));     % fresnel back propagation 
p = fftshift(fft2(fftshift(p)));
antialiased = (1/lambda) * (sqrt(R.^2 + C.^2)/rD);
pupil = antialiased < nfreq;
p = p .* pupil;

filterRadius = 0:0.25e-3:5e-3;
for i = filterRadius
    % spatial filter generation
    spFilter = sqrt(C.^2 + R.^2);
    spFilter(spFilter > i) = 0;
    spFilter = spFilter./max(max(spFilter));
%     spFilter(spFilter ~= 0) = 1;
    %figure; imshow(spFilter);

    fCH_filtered = fCH .* spFilter;



    A1 = fCH_filtered;

    Az1 = A1.*p;
    EI = fftshift(fft2(fftshift(Az1)));
    EI2 = EI .* conj(EI);
    EI2 = EI2.^gamma;
    EI2 = 255 .* EI2 ./ max(max(EI2));
    imwrite(uint8(EI2), sprintf('img_invCircFilter_%d.jpg', i));
end

figure;
imshowpair(EI1.^gamma, EI2.^gamma, 'montage');
title('reconstructed - before and after filtered, \gamma = 0.25')

% method2 - spatial frequency apodization
