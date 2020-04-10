function x = pcg_ND(A, b, tol, maxit, x)
% A should be a function handle to compute Ax by using A(x)


% set default parameters
if ~exist('x','var')
    x = zeros(size(b));
    
end
if ~exist('maxit','var')
    maxit = 100;
end

%%%%%%%%%%%%%%%% Concise version %%%%%%%%%%%%%%%%
% % initialization
% r = b - A(x);
% p = r;
% 
% % iterate
% k = 0;
% while (k < maxit) && (norm(r(:)) > tol)
%     k = k + 1;
%     alpha = sum(abs(r(:)).^2) / sum(reshape(conj(p).*A(p),[],1));
%     x = x + alpha*p;
%     r_new = r - alpha*A(p);
%     beta = sum(abs(r_new(:)).^2) / sum(abs(r(:)).^2);
%     r = r_new;
%     p = r + beta*p;
% end
%%%%%%%%%%%%%%%% Concise version %%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%% MATLAB version %%%%%%%%%%%%%%%%

% Check for all zero right hand side vector => all zero solution
n2b = norm(b(:));                     % Norm of rhs vector, b
if (n2b == 0)                      % if    rhs vector is all zeros
    x = zeros(size(b));                % then  solution is all zeros
    return
end

% Set up for the method
tolb = tol * n2b;                  % Relative tolerance
r = b - A(x);
normr = norm(r(:));                   % Norm of residual

if (normr <= tolb)                 % Initial guess is a good enough solution
    return
end

rho = 1;
stag = 0;                          % stagnation of the method
moresteps = 0;
maxmsteps = min([floor(numel(b)/50),5,numel(b)-maxit]);
maxstagsteps = 3;

% loop over maxit iterations (unless convergence or failure)
% no preconditioners
for ii = 1:maxit
    rho1 = rho;
    rho = sum(abs(r(:)).^2);
    
    if ((rho == 0) || isinf(rho))
        break
    end
    if (ii == 1)
        p = r;
    else
        beta = rho / rho1;
        if ((beta == 0) || isinf(beta))
            break
        end
        p = r + beta * p;
    end
    q = A(p);
    pq = sum(reshape(conj(p).*q,[],1));
    if ((pq <= 0) || isinf(pq))
        break
    else
        alpha = rho / pq;
    end
    if isinf(alpha)
        break
    end
    
    % Check for stagnation of the method    
    if (norm(p(:))*abs(alpha) < eps*norm(x(:)))
        stag = stag + 1;
    else
        stag = 0;
    end
    
    x = x + alpha * p;             % form new iterate
    r = r - alpha * q;
    normr = norm(r(:));
    
    % check for convergence
    if (normr <= tolb || stag >= maxstagsteps || moresteps)
        r = b - A(x);
        if (norm(r(:)) <= tolb)
            break
        else
            if stag >= maxstagsteps && moresteps == 0
                stag = 0;
            end
            moresteps = moresteps + 1;
            if moresteps >= maxmsteps
                break
            end
        end
    end
    if stag >= maxstagsteps
        break
    end
end

%%%%%%%%%%%%%%%% MATLAB version %%%%%%%%%%%%%%%%

