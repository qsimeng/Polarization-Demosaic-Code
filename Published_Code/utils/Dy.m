function dy = Dy(x, m, n, k)
I = reshape(x, m, n, k);
Dy = circshift(I, -1, 1) - I;
dy = reshape(Dy, [], 1);
end