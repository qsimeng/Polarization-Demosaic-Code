function z = shrinkage(x, kappa)
%   soft shrinage operator for ell_1
z = max( 0, x - kappa ) - max( 0, -x - kappa );
end