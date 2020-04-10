%% ~~~~~~~~~~~~~~~~~ Color Polarization Demosaicking ~~~~~~~~~~~~~~~~~~~ %%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Simeng Qiu ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Copyright 2019
% This code is mainly for monochrome plarization images demosaicking, the ground
% truth (GT) images are from this website we created. There are three important
% papameters to consider when solving a ploarization demosaicking problem.
% Itot: Total Intensity, which is S0.
% DoLP: Degree of Linear Polarization (DoLP_gt is ground truth).
% AoLP: Angle of Linear Polarization (AoLP_gt is ground truth).
% Dataset: https://repository.kaust.edu.sa/handle/10754/631914
% Project Page: vccimaging.org/Publications/Simeng2019PolarizationDemosaic/
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
clc
clear all;
close all;

addpath('utils'); 
load('./data/fruit2.mat');

I_gt    = Itot/2;  
DoLP_gt = DoLP;               
AoLP_gt = AoLP;
scaledAoLP_gt = AoLP_gt/180;
[M, N, ch]  = size(I_gt);

S0 = Itot;
S1 = Itot .* DoLP_gt .* cosd(2*AoLP_gt);
S2 = Itot .* DoLP_gt .* sind(2*AoLP_gt);
S_real = cat(4, cat(3, S0(:,:,1), S1(:,:,1), S2(:,:,1)), ...
                cat(3, S0(:,:,2), S1(:,:,2), S2(:,:,2)), ...
                cat(3, S0(:,:,3), S1(:,:,3), S2(:,:,3)) );            
%% polarizer characteristics %%
% Ideal polarizer, k1 = 1; k2 = 0
k1 = 1;
k2 = 0;
% these matrices should be replaced by real calibrated matrices
M0   = mueller(0, k1, k2);
M45  = mueller(45, k1, k2);
M90  = mueller(90, k1, k2);
M135 = mueller(135, k1, k2);
% conversion matrix from Stokes to Intensities
S2Imat = [M0(1,:); M45(1,:); M90(1,:); M135(1,:)]; %4 * 3
% S2Imat_trans = pinv(S2Imat); 
S2Imat_trans = S2Imat.'; 

%% I_capture
rgbMask = Mask(M, N);
I_capture = zeros(M, N);
for j = 1:3
    S = cat(3, S0(:, :, j), S1(:, :, j), S2(:, :, j));
    I = stokes2inten(S2Imat, S);  
    Imosaic = polarmosaic(I);
    I_capture = I_capture + rgbMask(:,:, j) .* Imosaic; % I_capture is captured raw data
end
rng(0); % for reproduciable
noise_sigma = 2;
I_capture   = I_capture + (noise_sigma / 255) * randn(size(I_capture));
I_capture = im2double(im2uint8(I_capture));
[M, N] =  size(I_capture);

%% Huber with first and second derivatives %%
if 1
% Unpolarized illumination %
    % Initial
    maxiter = 30;
    tol = 1e-5;   
    verbose = 1; 
    % Huber
    params.lambda_hub  = repmat(0.95, [9 1]); 
    params.rho_hub     = repmat(0.05, [9 1]);  
    params.delta       = repmat(0.001, [9 1]);   
else
% Polarized illumination %    
    % Initial
    maxiter = 30;
    tol = 1e-5;   
    verbose = 1; 
    % Huber
    params.lambda_hub  = repmat(5e-4, [9 1]); 
    params.rho_hub     = repmat(0.01, [9 1]);  
    params.delta       = repmat(0.01, [9 1]);
end

fprintf('ADMM with Huber_2d\n');
Stokes_vector_huber_2d  = stokes_color_huber_all(I_capture, S2Imat, params, tol, maxiter, verbose, S2Imat_trans, Itot, DoLP_gt, AoLP_gt, S_real);
[I_opt_huber_2d, DoLP_opt_huber_2d, AoLP_opt_huber_2d, S1_huber_2d, S2_huber_2d] = Stokes_computeLP_color(Stokes_vector_huber_2d);

scaledAoLP_opt_huber_2d = AoLP_opt_huber_2d / 180;
PSNR_I_opt_huber_2d    = psnr(I_opt_huber_2d, Itot, 2);
PSNR_DoLP_opt_huber_2d  = psnr(DoLP_opt_huber_2d, DoLP_gt, 1);
PSNR_AoLP_opt_huber_2d  = psnr_angle(AoLP_opt_huber_2d, AoLP_gt);

%% Printed Results            
fprintf('Huber_2d:      \tPSNR_S0 = %.2fdB, PSNR_DoLP = %.2fdB, PSNR_AoLP = %.2fdB\n', ...
                 PSNR_I_opt_huber_2d, PSNR_DoLP_opt_huber_2d, PSNR_AoLP_opt_huber_2d);           
             