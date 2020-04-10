function x = KcKpM_T(C, y)

[M, N] = size(y);

% ------------------- KcT ------------------- 
IR = zeros(size(y));
IG = zeros(size(y));
IB = zeros(size(y));

IR(1 : 4 : M, 1 : 4 : N) = y(1 : 4 : M, 1 : 4 : N);%90
IR(1 : 4 : M, 2 : 4 : N) = y(1 : 4 : M, 2 : 4 : N);%45
IR(2 : 4 : M, 1 : 4 : N) = y(2 : 4 : M, 1 : 4 : N);%135
IR(2 : 4 : M, 2 : 4 : N) = y(2 : 4 : M, 2 : 4 : N);%0

IG(1 : 4 : M, 3 : 4 : N) = y(1 : 4 : M, 3 : 4 : N);
IG(1 : 4 : M, 4 : 4 : N) = y(1 : 4 : M, 4 : 4 : N);
IG(2 : 4 : M, 3 : 4 : N) = y(2 : 4 : M, 3 : 4 : N);
IG(2 : 4 : M, 4 : 4 : N) = y(2 : 4 : M, 4 : 4 : N);

IG(3 : 4 : M, 1 : 4 : N) = y(3 : 4 : M, 1 : 4 : N);
IG(3 : 4 : M, 2 : 4 : N) = y(3 : 4 : M, 2 : 4 : N);
IG(4 : 4 : M, 1 : 4 : N) = y(4 : 4 : M, 1 : 4 : N);
IG(4 : 4 : M, 2 : 4 : N) = y(4 : 4 : M, 2 : 4 : N);

IB(3 : 4 : M, 3 : 4 : N) = y(3 : 4 : M, 3 : 4 : N);
IB(3 : 4 : M, 4 : 4 : N) = y(3 : 4 : M, 4 : 4 : N);
IB(4 : 4 : M, 3 : 4 : N) = y(4 : 4 : M, 3 : 4 : N);
IB(4 : 4 : M, 4 : 4 : N) = y(4 : 4 : M, 4 : 4 : N);

% ------------------- KpT ------------------- 
SR = S_Layer_T(IR, 2);
SG = S_Layer_T(IG, 2);
SB = S_Layer_T(IB, 2);

% ------------------- MT ------------------- 
x = cat(3, reshape( reshape(SR,[M*N 4]) * C(:,:,1), [M N 3] ), ...
           reshape( reshape(SG,[M*N 4]) * C(:,:,2), [M N 3] ), ...
           reshape( reshape(SB,[M*N 4]) * C(:,:,3), [M N 3] ));
end


function out = S_Layer_T(in, seq)

M = size(in,1);
N = size(in,2);

I1 = zeros(M, N);
I2 = zeros(M, N);
I3 = zeros(M, N);
I4 = zeros(M, N);

I1(2 : seq : M, 2 : seq : N) = in(2 : seq : M, 2 : seq : N);
I2(1 : seq : M, 2 : seq : N) = in(1 : seq : M, 2 : seq : N);
I3(1 : seq : M, 1 : seq : N) = in(1 : seq : M, 1 : seq : N);
I4(2 : seq : M, 1 : seq : N) = in(2 : seq : M, 1 : seq : N);

out = cat(3, I1, I2, I3, I4);

end
