function Itot = KcT(I)
IR = zeros(size(I));
IG = zeros(size(I));
IB = zeros(size(I));

[M, N] = size(I);

IR(1 : 4 : M, 1 : 4 : N) = I(1 : 4 : M, 1 : 4 : N);%90
IR(1 : 4 : M, 2 : 4 : N) = I(1 : 4 : M, 2 : 4 : N);%45
IR(2 : 4 : M, 1 : 4 : N) = I(2 : 4 : M, 1 : 4 : N);%135
IR(2 : 4 : M, 2 : 4 : N) = I(2 : 4 : M, 2 : 4 : N);%0


IG(1 : 4 : M, 3 : 4 : N) = I(1 : 4 : M, 3 : 4 : N);
IG(1 : 4 : M, 4 : 4 : N) = I(1 : 4 : M, 4 : 4 : N);
IG(2 : 4 : M, 3 : 4 : N) = I(2 : 4 : M, 3 : 4 : N);
IG(2 : 4 : M, 4 : 4 : N) = I(2 : 4 : M, 4 : 4 : N);


IG(3 : 4 : M, 1 : 4 : N) = I(3 : 4 : M, 1 : 4 : N);
IG(3 : 4 : M, 2 : 4 : N) = I(3 : 4 : M, 2 : 4 : N);
IG(4 : 4 : M, 1 : 4 : N) = I(4 : 4 : M, 1 : 4 : N);
IG(4 : 4 : M, 2 : 4 : N) = I(4 : 4 : M, 2 : 4 : N);


IB(3 : 4 : M, 3 : 4 : N) = I(3 : 4 : M, 3 : 4 : N);
IB(3 : 4 : M, 4 : 4 : N) = I(3 : 4 : M, 4 : 4 : N);
IB(4 : 4 : M, 3 : 4 : N) = I(4 : 4 : M, 3 : 4 : N);
IB(4 : 4 : M, 4 : 4 : N) = I(4 : 4 : M, 4 : 4 : N);

Itot = cat(3, IR, IG, IB);
end