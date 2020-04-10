function Stokes = inten2stokes(C, Inten)
%   converts intensity to Stokes parameters 
%   C is a 4 x 3 matrix. Stokes is a 3-channel array with S0, S1, and S2
%   Inten is a 4-channel array with I0, I45, I90, I135

if isempty(C)
    % definition
    C = [0.5 0.5 0.5 0.5; 1 0 -1 0; 0 1 0 -1];
end

Stokes = zeros(size(Inten, 1), size(Inten, 2), 3);

I0   = Inten(:,:,1);
I45  = Inten(:,:,2);
I90  = Inten(:,:,3);
I135 = Inten(:,:,4);

Stokes(:,:,1) = C(1, 1) * I0 + C(1, 2) * I45 + C(1, 3) * I90 + C(1, 4) * I135;% S0
Stokes(:,:,2) = C(2, 1) * I0 + C(2, 2) * I45 + C(2, 3) * I90 + C(2, 4) * I135;% S1
Stokes(:,:,3) = C(3, 1) * I0 + C(3, 2) * I45 + C(3, 3) * I90 + C(3, 4) * I135;% S2

end