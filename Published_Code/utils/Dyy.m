function dyy = Dyy(x, m, n, k)
I = reshape(x, m, n, k);
Dy = circshift(I, -1, 1) - I;
Dyy = circshift(Dy, -1, 1) - Dy;
dyy = reshape(Dyy, [], 1);
end