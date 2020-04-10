function dtx = DxxT(x, m, n, k)
I = reshape(x, m, n, k);
DxT = circshift(I, 1, 2) - I;
DxxT = circshift(DxT, 1, 2) - DxT;
dtx = reshape(DxxT, [], 1);
end