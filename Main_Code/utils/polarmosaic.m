function I = polarmosaic(Inten)
%   polarizer layout is 
%   90     45
%   135    0

I0   = Inten(:,:,1);
I45  = Inten(:,:,2);
I90  = Inten(:,:,3);
I135 = Inten(:,:,4);

[M, N] = size(I0);
I(1 : 2 : M, 1 : 2 : N) = I90 (1 : 2 : M, 1 : 2 : N);
I(1 : 2 : M, 2 : 2 : N) = I45 (1 : 2 : M, 2 : 2 : N);
I(2 : 2 : M, 1 : 2 : N) = I135(2 : 2 : M, 1 : 2 : N);
I(2 : 2 : M, 2 : 2 : N) = I0  (2 : 2 : M, 2 : 2 : N);
end