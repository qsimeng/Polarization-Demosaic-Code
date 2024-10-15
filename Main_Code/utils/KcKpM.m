function y = KcKpM(C, x)

M = size(x,1);
N = size(x,2);

% ------------------- M ------------------- 
Inten = cat(3, reshape( reshape(x(:,:,1:3),[M*N 3]) * C(:,:,1), [M N 4] ), ...
               reshape( reshape(x(:,:,4:6),[M*N 3]) * C(:,:,2), [M N 4] ), ...
               reshape( reshape(x(:,:,7:9),[M*N 3]) * C(:,:,3), [M N 4] ));

% ------------------- Kp ------------------- 
IR = S_Layer(Inten(:,:,1:4),  2);
IG = S_Layer(Inten(:,:,5:8),  2);
IB = S_Layer(Inten(:,:,9:12), 2);

% ------------------- Kc ------------------- 
y = zeros(M,N);
y(2 : 4 : M, 2 : 4 : N) = IR(2 : 4 : M, 2 : 4 : N);
y(1 : 4 : M, 2 : 4 : N) = IR(1 : 4 : M, 2 : 4 : N);
y(1 : 4 : M, 1 : 4 : N) = IR(1 : 4 : M, 1 : 4 : N);
y(2 : 4 : M, 1 : 4 : N) = IR(2 : 4 : M, 1 : 4 : N);

y(1 : 4 : M, 3 : 4 : N) = IG(1 : 4 : M, 3 : 4 : N);
y(1 : 4 : M, 4 : 4 : N) = IG(1 : 4 : M, 4 : 4 : N);
y(2 : 4 : M, 3 : 4 : N) = IG(2 : 4 : M, 3 : 4 : N);
y(2 : 4 : M, 4 : 4 : N) = IG(2 : 4 : M, 4 : 4 : N);

y(3 : 4 : M, 1 : 4 : N) = IG(3 : 4 : M, 1 : 4 : N);
y(3 : 4 : M, 2 : 4 : N) = IG(3 : 4 : M, 2 : 4 : N);
y(4 : 4 : M, 1 : 4 : N) = IG(4 : 4 : M, 1 : 4 : N);
y(4 : 4 : M, 2 : 4 : N) = IG(4 : 4 : M, 2 : 4 : N);

y(3 : 4 : M, 3 : 4 : N) = IB(3 : 4 : M, 3 : 4 : N);
y(3 : 4 : M, 4 : 4 : N) = IB(3 : 4 : M, 4 : 4 : N);
y(4 : 4 : M, 3 : 4 : N) = IB(4 : 4 : M, 3 : 4 : N);
y(4 : 4 : M, 4 : 4 : N) = IB(4 : 4 : M, 4 : 4 : N);

end


function out = S_Layer(in, seq)

M = size(in,1);
N = size(in,2);

out = zeros(M,N);

out(2 : seq : M, 2 : seq : N) = in(2 : seq : M, 2 : seq : N, 1);
out(1 : seq : M, 2 : seq : N) = in(1 : seq : M, 2 : seq : N, 2);
out(1 : seq : M, 1 : seq : N) = in(1 : seq : M, 1 : seq : N, 3);
out(2 : seq : M, 1 : seq : N) = in(2 : seq : M, 1 : seq : N, 4);

end

