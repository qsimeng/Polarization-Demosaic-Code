function dtx = DxT(x, m, n, k)
I = reshape(x, m, n, k);
DxT = circshift(I, 1, 2) - I;
dtx = reshape(DxT, [], 1);
end

