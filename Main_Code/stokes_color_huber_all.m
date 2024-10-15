function Stokes_vector = stokes_color_huber_all(I_capture, S2Imat, params, tol, maxiter, verbose, S2Imat_trans, Itot, DoLP_gt, AoLP_gt, S_real)
if nargin < 6
    verbose = 'all';
end
[m, n]  = size(I_capture); 
ch = 9; % 9 dimensional
%% Parameters
% Huber
lambda_hub  = params.lambda_hub;
rho_hub     = params.rho_hub;
delta       = params.delta;

% define operator to wrap Huber rho's
rho_hub_op  = @(x) bsxfun(@times, x, permute(rho_hub, [3 2 1]));

%% Initialization
% x & y
x = zeros(m*n*ch, 1); % m * n * 9
y = I_capture;

% Huber (sort: x, y, xx, xy, yy)
z_hub = zeros(m,n,ch, 5);
u_hub = zeros(m,n,ch, 5);

%% Define operators
% norm operators
norm1 = @(x) sum(abs(x(:)));
norm2 = @(x) norm(x(:));

% define 2D convolutional operators
bond_condition = 'circular';
dx = [0 -1 1];
dy = [0 -1 1]';
dxx = conv2(dx, dx);
dyy = conv2(dy, dy);
dxy = conv2(dx, dy);
% --- primal --- 
Dx  = @(x) imfilter(x, dx,  bond_condition);
Dy  = @(x) imfilter(x, dy,  bond_condition);
Dxx = @(x) imfilter(x, dxx, bond_condition);
Dyy = @(x) imfilter(x, dyy, bond_condition);
Dxy = @(x) imfilter(x, dxy, bond_condition);
% --- dual --- 
DxT  = @(x) imfilter(x, rot90(dx,2),  bond_condition);
DyT  = @(x) imfilter(x, rot90(dy,2),  bond_condition);
DxxT = @(x) imfilter(x, rot90(dxx,2), bond_condition);
DyyT = @(x) imfilter(x, rot90(dyy,2), bond_condition);
DxyT = @(x) imfilter(x, rot90(dxy,2), bond_condition);
% operators
KpM           = @(v) Kp(M(S2Imat, v));
KcKpM         = @(v) Kc(KpM(v));
KcTKcKpM      = @(v) KcT(KcKpM(v));
KpTKcTKcKpM   = @(v) KpT(KcTKcKpM(v));
MtKpTKcTKcKpM = @(v) MT(S2Imat_trans, KpTKcTKcKpM(v));
KpTKcT        = @(v) KpT(KcT(reshape(v, m, n)));
MtKpTKcT      = @(v) MT(S2Imat_trans, KpTKcT(v));
D             = @(v) cat(4, Dx(v), Dy(v), Dxx(v), Dxy(v), Dyy(v));
Dt            = @(w) DxT( w(:,:,:,1)) + DyT( w(:,:,:,2)) + ...
                     DxxT(w(:,:,:,3)) + DxyT(w(:,:,:,4)) + DyyT(w(:,:,:,5));
s             = [0 0 1 0 0; 0 1 -7 1 0; 1 -7 20 -7 1; 0 1 -7 1 0; 0 0 1 0 0];
DtD           = @(v) imfilter(v, s,  bond_condition);
b1            = MtKpTKcT(y);
A             = @(v) MtKpTKcTKcKpM(v) + ...
                     rho_hub_op(DtD(v));
                 
% Huber update
huber = @(x, delta, rho, lambda) ...
         (abs(x) <= (lambda+rho)/(rho+eps) * delta) .* (rho/(lambda + rho + eps) * x) + ...
         (x >  (lambda+rho)/(rho + eps) * delta) .* (x - delta/(rho+eps)*lambda) + ...
         (x < -(lambda+rho)/(rho + eps) * delta) .* (x + delta/(rho+eps)*lambda) ;
%%
obj_total = zeros(maxiter+1, 3);
obj_total(1,:) = Inf;

for i = 1:maxiter
% 1. x-update
    b2 = rho_hub_op(Dt(z_hub - u_hub));
    b = b1 + b2;  
    x = pcg_ND(A, b, tol);

    % pre-caching
    d = D(x);
    du_hub  = d + u_hub;
    
% 2. z-update 
    % Huber
    for ch_hub = 1:9
        z_hub(:,:,ch_hub,:) = huber(du_hub(:,:,ch_hub,:), delta(ch_hub), rho_hub(ch_hub), lambda_hub(ch_hub));
    end
    
% 3. u-update
    u_hub  = du_hub  - z_hub;   

% Objective Function
    obj_data = 0.5 * norm2(y - KcKpM(x))^2;
    obj_Hub = 0;
    for ch_hub = 1:9
        obj_Hub = obj_Hub + lambda_hub(ch_hub) * objective_hub(d(:,:,ch_hub,:), delta(ch_hub));
    end
    
    obj_total(i+1, 1) = obj_data + obj_Hub;
    obj_total(i+1, 2) = obj_data;
    obj_total(i+1, 3) = obj_Hub;
    
    fprintf('Iter# %d: obj_total = %e, obj_data = %e, obj_Hub = %e\n', ...
            i, obj_total(i+1), obj_data, obj_Hub);
    if strcmpi(verbose, 'all')
    end
    %% ------------------------------------------------------------------%%
    [I_opt_huber_2d, DoLP_opt_huber_2d, AoLP_opt_huber_2d, S1_huber_2d, S2_huber_2d] = Stokes_computeLP_color(x);
    PSNR_I_opt_huber_2d    = psnr(I_opt_huber_2d, Itot, 2);
    PSNR_DoLP_opt_huber_2d  = psnr(DoLP_opt_huber_2d, DoLP_gt, 1);
    PSNR_AoLP_opt_huber_2d  = psnr_angle(AoLP_opt_huber_2d, AoLP_gt);    
    %Stokes
    Stokes_huber_2d       = cat(4, I_opt_huber_2d , S1_huber_2d , S2_huber_2d );    
    stokesErr_huber_2d     = Stokes_huber_2d  - S_real;
    stokesMSE_huber_2d     = norm(stokesErr_huber_2d (:), 2).^2 / numel(stokesErr_huber_2d );
    stokesPSNR_huber_2d    = 10 * log10(2^2./stokesMSE_huber_2d );
    
    fprintf('Iter# %d: PSNR_S0 = %f, PSNR_DoLP = %f, PSNR_AoLP = %f\n', ...
             i, PSNR_I_opt_huber_2d, PSNR_DoLP_opt_huber_2d, PSNR_AoLP_opt_huber_2d);
    %% ------------------------------------------------------------------%%
    rel_err = abs(obj_total(i+1) - obj_total(i));
    if rel_err < tol
        break;
    end
end
Stokes_vector = x;
end