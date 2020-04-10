function Inten = stokes2inten(C, Stokes)
%   converts the Stokes parameters to intensity
%   C is a 4 x 3 matrix. Stokes is a 3-channel array with S0, S1, and S2
%   Inten is a 4-channel array with I0, I45, I90, I135

% extract the Stokes components
S0 = Stokes(:, :, 1);
S1 = Stokes(:, :, 2);
S2 = Stokes(:, :, 3);

Inten = zeros(size(Stokes, 1), size(Stokes, 2), 4);

Inten(:, :, 1) = C(1, 1) * S0 + C(1, 2) * S1 + C(1, 3) * S2;% I0
Inten(:, :, 2) = C(2, 1) * S0 + C(2, 2) * S1 + C(2, 3) * S2;% I45
Inten(:, :, 3) = C(3, 1) * S0 + C(3, 2) * S1 + C(3, 3) * S2;% I90
Inten(:, :, 4) = C(4, 1) * S0 + C(4, 2) * S1 + C(4, 3) * S2;% I135

end