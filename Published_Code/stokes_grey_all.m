function Stokes_vector = stokes_grey_all(I_capture, S2Imat, S2Imat_trans, params, tol, maxiter, verbose)

if nargin < 5
    verbose = 'all';
end
[m, n] = size(I_capture); 
ch = 3;

%% Parameters
% Huber
lambda_hub = params.lambda_hub;
rho_hub    = params.rho_hub;
delta      = params.delta;
% Define operator to wrap huber rho's
rho_hub_op = @(x) bsxfun(@times, x, permute(rho_hub, [3 2 1]));

%% initialization
x     = zeros(m*n*ch, 1);
y     = reshape(I_capture, [], 1);
 
% Huber (sort: x, y, xx, xy, yy)
z_hub = zeros(m,n,ch, 5);
u_hub = zeros(m,n,ch, 5);

%% Define operators
% norm operators
norm1 = @(x) sum(abs(x(:)));
norm2 = @(x) norm(x(:));
% define 2D convolutional operators
bond_condition = 'circular';
dx  = [0 -1 1];
dy  = [0 -1 1]';
dxx = conv2(dx, dx);
dyy = conv2(dy, dy);
dxy = conv2(dx, dy);
% Primal 
Dx  = @(x) imfilter(x, dx,  bond_condition);
Dy  = @(x) imfilter(x, dy,  bond_condition);
Dxx = @(x) imfilter(x, dxx, bond_condition);
Dyy = @(x) imfilter(x, dyy, bond_condition);
Dxy = @(x) imfilter(x, dxy, bond_condition);
% Dual
DxT  = @(x) imfilter(x, rot90(dx,2),  bond_condition);
DyT  = @(x) imfilter(x, rot90(dy,2),  bond_condition);
DxxT = @(x) imfilter(x, rot90(dxx,2), bond_condition);
DyyT = @(x) imfilter(x, rot90(dyy,2), bond_condition);
DxyT = @(x) imfilter(x, rot90(dxy,2), bond_condition);
% Operators
M    = @(v) stokes2inten(S2Imat, reshape(v, m, n, ch));
KM   = @(v) polarmosaic(M(v));
KtKM = @(v) backpolarmosaic(KM(v));
MtKtKM = @(v) inten2stokes(S2Imat_trans, KtKM(v));
MtKt = @(v) inten2stokes(S2Imat_trans, backpolarmosaic(reshape(v, m, n)));
D    = @(v) cat(4, Dx(v), Dy(v), Dxx(v), Dxy(v), Dyy(v));
Dt   = @(w) DxT( w(:,:,:,1)) + DyT( w(:,:,:,2)) + ...
            DxxT(w(:,:,:,3)) + DxyT(w(:,:,:,4)) + DyyT(w(:,:,:,5));
s    = [0 0 1 0 0; 0 1 -7 1 0; 1 -7 20 -7 1; 0 1 -7 1 0; 0 0 1 0 0];
DtD  = @(v) imfilter(v, s, bond_condition);
b1   = MtKt(y);
A    = @(x) MtKtKM(x) + reshape(rho_hub_op(DtD(x)), m, n, ch);
%% Huber update
x = reshape(x, m, n, ch);
huber = @(x, delta, rho, lambda) ...
         (abs(x) <= (lambda+rho)/(rho+eps) * delta) .* (rho/(lambda + rho + eps) * x) + ...
         (x >  (lambda+rho)/(rho+eps) * delta) .* (x - delta/(rho+eps)*lambda) + ...
         (x < -(lambda+rho)/(rho+eps) * delta) .* (x + delta/(rho+eps)*lambda); 
%% ADMM + TV + Second derivative(2D) + Huber
obj_total = zeros(maxiter + 1, 3);
obj_total(1,:) = Inf;

for i = 1:maxiter
    % 1. x-update

    b2 = rho_hub_op(Dt(z_hub - u_hub));
    b = b1 + b2;
    x  = pcg_ND(A, b, tol);
    d  = D(x);
    du_hub  = d + u_hub;
    
    % 2. z-update    
    % Huber
    for ch_hub = 1:3
        z_hub(:,:,ch_hub,:) = huber(du_hub(:,:,ch_hub,:), delta(ch_hub), rho_hub(ch_hub), lambda_hub(ch_hub));
    end      
    % 3. u-update
    u_hub  = du_hub - z_hub;    
%% objective function

    obj_data  = 0.5 * norm(reshape(y,m,n) - KM(x))^2;
    obj_Hub = 0;
    
    for ch_hub = 1:3
        obj_Hub = obj_Hub + lambda_hub(ch_hub) * objective_hub_grey(d(:,:,ch_hub,:), delta(ch_hub));
    end
    
    obj_total(i+1, 1) = obj_data + obj_Hub;
    obj_total(i+1, 2) = obj_data;
    obj_total(i+1, 3) = obj_Hub;

    fprintf('Iter# %d: obj_total = %.2e, obj_data = %.2e, obj_Hub = %.2e\n', ...
            i, obj_total(i+1), obj_data, obj_Hub);
        
    if strcmpi(verbose, 'all')
    end

    rel_err = abs(obj_total(i+1) - obj_total(i));
    if rel_err < tol
        break;
    end
end
Stokes_vector = reshape(x, m, n, ch);
end