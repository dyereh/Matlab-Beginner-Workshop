clc; clear all; close all;

fid = fopen('P34816.7');
pointer = 66072 + 4*256;

fseek(fid, pointer, 'bof');
R = fread(fid, [256, 192], 'short', 2);

%% Part A
fseek(fid, pointer + 2, 'bof');
I = fread(fid, [256, 192], 'short', 2);     %Take interleaved real/imaginary data points reading every other point

recon = R + I*i;
recon_64  = zeros(512,512);     %Construct Empty Matrices
recon_128 = zeros(512,512);
recon_512 = zeros(512,512);

recon_64(224:287,224:287) = recon(96:159, 64:127);      %Insert Truncated K-space
recon_128(192:319,192:319) = recon(64:191, 32:159);
recon_512(128:383, 160:351) = recon;

recon_im = abs(fftshift(ifft2(recon)));
recon_64_im = abs(fftshift(ifft2(recon_64)));        %Image reconstruction
recon_128_im = abs(fftshift(ifft2(recon_128)));
recon_512_im = abs(fftshift(ifft2(recon_512)));

figure;
subplot(2,2,1); imagesc(recon_im); colormap('jet'); title('Reconstruction of Original Image');
subplot(2,2,2); imagesc(recon_64_im); colormap('jet'); title({'Reconstructed Image with 64x64 Truncation'; '& 512x512 Zero-padding'});
subplot(2,2,3); imagesc(recon_128_im); colormap('jet'); title({'Reconstructed Image with 128x128 Truncation'; '& 512x512 Zero-padding'});
subplot(2,2,4); imagesc(recon_512_im); colormap('jet'); title({'Reconstruction of Original Image'; 'with 512x512 Zero-padding'});

%% Part B
recon_fft     = abs(fftshift(fft2(recon_im)));              %Put back into k-space
recon_64_fft  = abs(fftshift(fft2(recon_64_im)));          
recon_128_fft = abs(fftshift(fft2(recon_128_im)));
recon_512_fft = abs(fftshift(fft2(recon_512_im)));

recon_psf = abs(fftshift(ifft(recon_fft)));
recon_64_psf = abs(fftshift(ifft(recon_64_fft)));
recon_128_psf = abs(fftshift(ifft(recon_128_fft)));
recon_512_psf = abs(fftshift(ifft(recon_512_fft)));

recon_psf = recon_psf/max(recon_psf(:,128));
recon_64_psf = recon_64_psf/max(recon_64_psf(:,256));
recon_128_psf = recon_128_psf/max(recon_128_psf(:,256));
recon_512_psf = recon_512_psf/max(recon_512_psf(:,256));

figure;
subplot(2,2,1); plot(-128:1:127, abs(recon_psf(:,128))); xlabel('Spatial Frequency'); ylabel('Magnitude'); title('PSF of original Data');
subplot(2,2,2); plot(-256:1:255, abs(recon_64_psf(:,256))); xlabel('Spatial Frequency'); ylabel('Magnitude'); title('PSF with 64x64 Truncation & 512x512 Zero-padding');
subplot(2,2,3); plot(-256:1:255, abs(recon_128_psf(:,256))); xlabel('Spatial Frequency'); ylabel('Magnitude'); title('PSF with 128x128 Truncation & 512x512 Zero-padding');
subplot(2,2,4); plot(-256:1:255, abs(recon_512_psf(:,256))); xlabel('Spatial Frequency'); ylabel('Magnitude'); title('PSF of Original Image with 512x512 Zero-padding');


%% With rect function

rect_64  = createRect(64, 512);     %Create Rectangular Functions
rect_128 = createRect(128, 512);
rect_256 = createRect(256, 512);

rect_64_psf = abs(fftshift(ifft(rect_64)));     %Calculate PSF of each rect function
rect_128_psf = abs(fftshift(ifft(rect_128)));
rect_256_psf = abs(fftshift(ifft(rect_256)));

rect_64_h = horzcat(zeros(1, 224), hamming(64)', zeros(1, 224));    %Create 1d hamming window
rect_128_h = horzcat(zeros(1, 192), hamming(128)', zeros(1, 192));
rect_256_h = horzcat(zeros(1, 128), hamming(256)', zeros(1, 128));

rect_64_h_psf = abs(fftshift(ifft(rect_64_h)));     %Calculate PSF of each hamming window
rect_128_h_psf = abs(fftshift(ifft(rect_128_h)));
rect_256_h_psf = abs(fftshift(ifft(rect_256_h)));

figure; %Show PSF's of rectangular functions
subplot(3,2,1); plot(-255:256, rect_64); xlabel('x'); ylabel('Mag'); title('64px Rectangular Function');
subplot(3,2,3); plot(-255:256, rect_128); xlabel('x'); ylabel('Mag'); title('128px Rectangular Function');
subplot(3,2,5); plot(-255:256, rect_256); xlabel('x'); ylabel('Mag'); title('256px Rectangular Function');

subplot(3,2,2); plot(-255:256, rect_64_psf); xlabel('x^-^1'); ylabel('Mag'); title('64px Rectangular Function PSF');
subplot(3,2,4); plot(-255:256, rect_128_psf); xlabel('x^-^1'); ylabel('Mag'); title('128px Rectangular Function PSF ');
subplot(3,2,6); plot(-255:256, rect_256_psf); xlabel('x^-^1'); ylabel('Mag'); title('256px Rectangular Function PSF');

figure; %Show PSF's after multiplication with a hamming window
subplot(3,2,1); plot(-255:256, rect_64_h); xlabel('x'); ylabel('Mag'); title('64px Hamming Window');
subplot(3,2,3); plot(-255:256, rect_128_h); xlabel('x'); ylabel('Mag'); title('128px Hamming Window');
subplot(3,2,5); plot(-255:256, rect_256_h); xlabel('x'); ylabel('Mag'); title('256px Hamming Window');

subplot(3,2,2); plot(-255:256, rect_64_h_psf); xlabel('x^-^1'); ylabel('Mag'); title('64px Hamming Window PSF');
subplot(3,2,4); plot(-255:256, rect_128_h_psf); xlabel('x^-^1'); ylabel('Mag'); title('128px Hamming Window PSF ');
subplot(3,2,6); plot(-255:256, rect_256_h_psf); xlabel('x^-^1'); ylabel('Mag'); title('256px Hamming Window PSF');

rect_64_h2 = rect_64_h' * rect_64_h;
rect_128_h2 = rect_128_h' * rect_128_h;
rect_256_h2 = rect_256_h' * rect_256_h;

figure; %Show Hamming windows
subplot(1,3,1); mesh(rect_64_h2); title('64x64 Hamming Window');
subplot(1,3,2); mesh(rect_128_h2); title('128x128 Hamming Window');
subplot(1,3,3); mesh(rect_256_h2); title('256x256 Hamming Window');

recon_64_h = recon_64.*rect_64_h2;      %Multiply k-space by hamming window
recon_128_h = recon_128.*rect_128_h2;
recon_256_h = recon_512.*rect_256_h2;

recon_64_im_h = abs(fftshift(ifft2(recon_64_h))); %Reconstruct image with hamming window
recon_128_im_h = abs(fftshift(ifft2(recon_128_h)));
recon_256_im_h = abs(fftshift(ifft2(recon_256_h)));

figure; %Display reconstructed image with hamming window
subplot(2,2,1); imagesc(recon_im); colormap('jet'); title('Reconstruction of Original Image');
subplot(2,2,2); imagesc(recon_64_im_h); colormap('jet'); title({'Reconstructed Image with 64x64 Truncation'; '& 512x512 Zero-padding'});
subplot(2,2,3); imagesc(recon_128_im_h); colormap('jet'); title({'Reconstructed Image with 128x128 Truncation'; '& 512x512 Zero-padding'});
subplot(2,2,4); imagesc(recon_256_im_h); colormap('jet'); title({'Reconstruction of Original Image'; 'with 512x512 Zero-padding'});
% length(rect_64_h)
% 
% rect_64_h_psf = abs(fftshift(ifft(rect_64_h)));
% 
% 
% figure; plot(rect_64_psf);
% 
% figure; plot(rect_64_h_psf);

% figure; plot(20*log(abs(recon_64(:,256))));
% figure; plot(abs(recon_64_fft(:,256)));
% 
% figure; imagesc(abs(recon_64_fft));
% test = abs(recon_64_fft(:,256))

