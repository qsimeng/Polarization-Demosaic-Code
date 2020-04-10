function dtxy = DxyT(x, m, n, k)
I = reshape(x, m, n, k);
DxT = circshift(I, 1, 2) - I;
DxyT = circshift(DxT, 1, 1) - DxT;
dtxy = reshape(DxyT, [], 1);
end