%% ~~~~~~~~~~~~~~~ Monochrome Polarization Demosaicking ~~~~~~~~~~~~~~~~ %%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Simeng Qiu ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Copyright 2019
% This code is mainly for monochrome plarization images demosaicking, the ground
% truth (GT) images are from this website we created. There are three important
% papameters to consider when solving a ploarization demosaicking problem.
% Itot: Total Intensity, which is S0.
% DoLP: Degree of Linear Polarization (DoLP_gt is ground truth).
% AoLP: Angle of Linear Polarization (AoLP_gt is ground truth).
% Monochrome dataset is from the green channel of the origional dataset.
% Project Page: vccimaging.org/Publications/Simeng2019PolarizationDemosaic/
% Dataset: repository.kaust.edu.sa/handle/10754/631914
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
clc
clear all; 
close all;
addpath('utils');
%% Input
%--------- Fruit ---------%
load('./data/fruit2.mat');

I_gt    = Itot/2;  
DoLP_gt = DoLP;               
AoLP_gt = AoLP;
scaledAoLP_gt = AoLP_gt/180;

S0 = Itot;
S1 = Itot .* DoLP_gt .* cosd(2*AoLP_gt);
S2 = Itot .* DoLP_gt .* sind(2*AoLP_gt);
[M, N, ch] = size(I_gt);

% Green channel = Gray Image 
AoLP    = AoLP(:,:,2);
DoLP    = DoLP(:,:,2);
AoLP_gt = AoLP_gt(:,:,2);
DoLP_gt = DoLP_gt(:,:,2);
I_gt    = I_gt(:,:,2);
Itot    = Itot(:,:,2);
S       = cat (3, S0(:,:,2), S1(:,:,2), S2(:,:,2));
S0      = S0(:,:,2);
S1      = S1(:,:,2);
S2      = S2(:,:,2);
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
S2Imat_trans = S2Imat.';                           %3 * 4

%% generate raw captures %%
% ground truth four intensity images for 0, 45, 90 and 135
Inten_gt    = stokes2inten(S2Imat, S);
% Mosaicked capture
I_capture   = polarmosaic(Inten_gt);
% Gaussain noise
noise_sigma = 0.5; % increase or decrease
I_capture   = I_capture + (noise_sigma / 255) * randn(size(I_capture));
%% Huber + first and second derivatives: tuning parameters %%
if 1
% Unpolarized illumination %
    % Initial
    maxiter = 30; %iteration
    tol = 1e-4;
    verbose = 1;
    % Huber2d
    params.lambda_hub  = repmat(0.95, [3 1]);  %1e-4; 
    params.rho_hub     = repmat(0.05, [3 1]);  %0.05; 
    params.delta       = repmat(0.001,[3 1]); %0.001; 
    
else
% Polarized illumination
    % Initial
    maxiter = 30; %iteration
    tol = 1e-4;
    verbose = 1;
    % Huber
    params.lambda_hub  = repmat(1e-4, [3 1]); 
    params.rho_hub     = repmat(0.001,[3 1]);  
    params.delta       = repmat(0.01, [3 1]);
end

fprintf('ADMM with Huber\n');
Stokes_vector_Huber2d  = stokes_grey_all(I_capture, S2Imat, S2Imat_trans, params, tol, maxiter, verbose);
[I_opt_Huber2d, DoLP_opt_Huber2d, AoLP_opt_Huber2d] = Stokes_computeLP(Stokes_vector_Huber2d);
scaledAoLP_opt_Huber2d = (AoLP_opt_Huber2d + 90) / 180;

PSNR_I_opt_Huber2d = psnr(I_opt_Huber2d, S0, 2);
PSNR_DoLP_opt_Huber2d  = psnr(DoLP_opt_Huber2d, DoLP_gt, 1);
PSNR_AoLP_opt_Huber2d  = psnr_angle(AoLP_opt_Huber2d, AoLP_gt);

%% Results
fprintf('Huber:     \tPSNR_S0 = %.2fdB, PSNR_DoLP = %.2fdB, PSNR_AoLP = %.2fdB\n', ...
                 PSNR_I_opt_Huber2d, PSNR_DoLP_opt_Huber2d, PSNR_AoLP_opt_Huber2d);