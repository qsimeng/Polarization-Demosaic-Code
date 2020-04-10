function Inten = backpolarmosaic(I)
%   polarizer layout is 
%   90     45
%   135    0

[M, N] = size(I);

I0   = zeros(M, N);
I45  = zeros(M, N);
I90  = zeros(M, N);
I135 = zeros(M, N);

I90 (1 : 2 : M, 1 : 2 : N) = I(1 : 2 : M, 1 : 2 : N);
I45 (1 : 2 : M, 2 : 2 : N) = I(1 : 2 : M, 2 : 2 : N);
I135(2 : 2 : M, 1 : 2 : N) = I(2 : 2 : M, 1 : 2 : N);
I0  (2 : 2 : M, 2 : 2 : N) = I(2 : 2 : M, 2 : 2 : N);

Inten = cat(3, I0, I45, I90, I135);
end