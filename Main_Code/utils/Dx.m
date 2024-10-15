function dx = Dx(x, m, n, k)
I = reshape(x, m, n, k);
Dx = circshift(I, -1, 2) - I;
dx = reshape(Dx, [], 1);
end