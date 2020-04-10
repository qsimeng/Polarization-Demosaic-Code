function dty = DyT(x, m, n, k)
I = reshape(x, m, n, k);
DyT = circshift(I, 1, 1) - I;
dty = reshape(DyT, [], 1);
end