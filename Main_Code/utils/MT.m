function Stokes = MT(C, Inten)
%   converts intensity to Stokes parameters 
%   C is a 4 x 3 matrix. Stokes is a 3-channel array with S0, S1, and S2
%   Inten is a 4-channel array with I0, I45, I90, I135

if isempty(C)
    % definition
    C = [0.5 0.5 0.5 0.5; 1 0 -1 0; 0 1 0 -1];
end

Stokes = zeros(size(Inten, 1), size(Inten, 2), 3);

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

Stokes(:,:,1) = C(1, 1) * I0R + C(1, 2) * I45R + C(1, 3) * I90R + C(1, 4) * I135R;% S0R
Stokes(:,:,2) = C(2, 1) * I0R + C(2, 2) * I45R + C(2, 3) * I90R + C(2, 4) * I135R;% S1R
Stokes(:,:,3) = C(3, 1) * I0R + C(3, 2) * I45R + C(3, 3) * I90R + C(3, 4) * I135R;% S2R
Stokes(:,:,4) = C(1, 1) * I0G + C(1, 2) * I45G + C(1, 3) * I90G + C(1, 4) * I135G;% S0G
Stokes(:,:,5) = C(2, 1) * I0G + C(2, 2) * I45G + C(2, 3) * I90G + C(2, 4) * I135G;% S1G
Stokes(:,:,6) = C(3, 1) * I0G + C(3, 2) * I45G + C(3, 3) * I90G + C(3, 4) * I135G;% S2G
Stokes(:,:,7) = C(1, 1) * I0B + C(1, 2) * I45B + C(1, 3) * I90B + C(1, 4) * I135B;% S0B
Stokes(:,:,8) = C(2, 1) * I0B + C(2, 2) * I45B + C(2, 3) * I90B + C(2, 4) * I135B;% S1B
Stokes(:,:,9) = C(3, 1) * I0B + C(3, 2) * I45B + C(3, 3) * I90B + C(3, 4) * I135B;% S2B
end