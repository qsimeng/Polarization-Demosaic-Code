function Mask = Mask(M, N)
Mask_R  = zeros(M, N);
Mask_G  = zeros(M, N);
Mask_B  = zeros(M, N);

Mask_R (1 : 4 : M, 1 : 4 : N) = 1;
Mask_R (1 : 4 : M, 2 : 4 : N) = 1;
Mask_R (2 : 4 : M, 1 : 4 : N) = 1;
Mask_R (2 : 4 : M, 2 : 4 : N) = 1;

Mask_G(1 : 4 : M, 3 : 4 : N) = 1; 
Mask_G(1 : 4 : M, 4 : 4 : N) = 1; 
Mask_G(2 : 4 : M, 3 : 4 : N) = 1; 
Mask_G(2 : 4 : M, 4 : 4 : N) = 1; 
Mask_G(3 : 4 : M, 1 : 4 : N) = 1; 
Mask_G(3 : 4 : M, 2 : 4 : N) = 1; 
Mask_G(4 : 4 : M, 1 : 4 : N) = 1; 
Mask_G(4 : 4 : M, 2 : 4 : N) = 1;

Mask_B (3 : 4 : M, 3 : 4 : N) = 1;
Mask_B (3 : 4 : M, 4 : 4 : N) = 1;
Mask_B (4 : 4 : M, 3 : 4 : N) = 1;
Mask_B (4 : 4 : M, 4 : 4 : N) = 1; 

Mask = cat(3, Mask_R, Mask_G, Mask_B);
end