function Inten = KpT(Itot)
%   polarizer layout is 
%   90     45
%   135    0


IR    = Itot(:, :, 1);
IG    = Itot(:, :, 2);
IB    = Itot(:, :, 3);

[M, N] = size(IR);

I0R   = zeros(M, N);
I45R  = zeros(M, N);
I90R  = zeros(M, N);
I135R = zeros(M, N);

I0G   = zeros(M, N);
I45G  = zeros(M, N);
I90G  = zeros(M, N);
I135G = zeros(M, N);

I0B   = zeros(M, N);
I45B  = zeros(M, N);
I90B  = zeros(M, N);
I135B = zeros(M, N);

I90R (1 : 2 : M, 1 : 2 : N) = IR(1 : 2 : M, 1 : 2 : N);
I45R (1 : 2 : M, 2 : 2 : N) = IR(1 : 2 : M, 2 : 2 : N);
I135R(2 : 2 : M, 1 : 2 : N) = IR(2 : 2 : M, 1 : 2 : N);
I0R  (2 : 2 : M, 2 : 2 : N) = IR(2 : 2 : M, 2 : 2 : N);

I90G (1 : 2 : M, 1 : 2 : N) = IG(1 : 2 : M, 1 : 2 : N);
I45G (1 : 2 : M, 2 : 2 : N) = IG(1 : 2 : M, 2 : 2 : N);
I135G(2 : 2 : M, 1 : 2 : N) = IG(2 : 2 : M, 1 : 2 : N);
I0G  (2 : 2 : M, 2 : 2 : N) = IG(2 : 2 : M, 2 : 2 : N);

I90B (1 : 2 : M, 1 : 2 : N) = IB(1 : 2 : M, 1 : 2 : N);
I45B (1 : 2 : M, 2 : 2 : N) = IB(1 : 2 : M, 2 : 2 : N);
I135B(2 : 2 : M, 1 : 2 : N) = IB(2 : 2 : M, 1 : 2 : N);
I0B  (2 : 2 : M, 2 : 2 : N) = IB(2 : 2 : M, 2 : 2 : N);

Inten = cat(3, I0R, I45R, I90R, I135R, I0G, I45G, I90G, I135G, I0B, I45B, I90B, I135B);
end
