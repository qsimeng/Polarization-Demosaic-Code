function Itot = Kp(Inten)
%   polarizer layout is 
%   90     45
%   135    0

I0R   = Inten(:,:,1);
I45R  = Inten(:,:,2);
I90R  = Inten(:,:,3);
I135R = Inten(:,:,4);

I0G   = Inten(:,:,5);
I45G  = Inten(:,:,6);
I90G  = Inten(:,:,7);
I135G = Inten(:,:,8);

I0B   = Inten(:,:,9);
I45B  = Inten(:,:,10);
I90B  = Inten(:,:,11);
I135B = Inten(:,:,12);


[M, N] = size(I0R);
IR(1 : 2 : M, 1 : 2 : N) = I90R (1 : 2 : M, 1 : 2 : N);
IR(1 : 2 : M, 2 : 2 : N) = I45R (1 : 2 : M, 2 : 2 : N);
IR(2 : 2 : M, 1 : 2 : N) = I135R(2 : 2 : M, 1 : 2 : N);
IR(2 : 2 : M, 2 : 2 : N) = I0R  (2 : 2 : M, 2 : 2 : N);

IG(1 : 2 : M, 1 : 2 : N) = I90G (1 : 2 : M, 1 : 2 : N);
IG(1 : 2 : M, 2 : 2 : N) = I45G (1 : 2 : M, 2 : 2 : N);
IG(2 : 2 : M, 1 : 2 : N) = I135G(2 : 2 : M, 1 : 2 : N);
IG(2 : 2 : M, 2 : 2 : N) = I0G  (2 : 2 : M, 2 : 2 : N);

IB(1 : 2 : M, 1 : 2 : N) = I90B (1 : 2 : M, 1 : 2 : N);
IB(1 : 2 : M, 2 : 2 : N) = I45B (1 : 2 : M, 2 : 2 : N);
IB(2 : 2 : M, 1 : 2 : N) = I135B(2 : 2 : M, 1 : 2 : N);
IB(2 : 2 : M, 2 : 2 : N) = I0B  (2 : 2 : M, 2 : 2 : N);

Itot = cat(3, IR, IG, IB);
end


