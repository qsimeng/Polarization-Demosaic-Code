function dxx = Dxx(x, m, n, k)
I   = reshape(x, m, n, k);
Dx  = circshift(I, -1, 2) - I;
Dxx = circshift(Dx, -1, 2) - Dx;
dxx  = reshape(Dxx, [], 1);
end