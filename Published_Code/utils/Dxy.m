function dxy = Dxy(x, m, n, k)
I   = reshape(x, m, n, k);
Dx  = circshift(I, -1, 2) - I;
Dxy = circshift(Dx, -1, 1) - Dx;
dxy = reshape(Dxy, [], 1);
end