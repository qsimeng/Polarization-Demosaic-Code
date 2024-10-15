function dtyy = DyyT(x, m, n, k)
I = reshape(x, m, n, k);
DyT = circshift(I, 1, 1) - I;
DyyT = circshift(DyT, 1, 1) - DyT;
dtyy = reshape(DyyT, [], 1);
end