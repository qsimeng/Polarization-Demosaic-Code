function Inten = M(C, Stokes)
S0R = Stokes(:, :, 1);
S1R = Stokes(:, :, 2);
S2R = Stokes(:, :, 3);
S0G = Stokes(:, :, 4);
S1G = Stokes(:, :, 5);
S2G = Stokes(:, :, 6);
S0B = Stokes(:, :, 7);
S1B = Stokes(:, :, 8);
S2B = Stokes(:, :, 9);

Inten = zeros(size(Stokes, 1), size(Stokes, 2), 12);

Inten(:, :, 1)  = C(1, 1) * S0R + C(1, 2) * S1R + C(1, 3) * S2R;% I0
Inten(:, :, 2)  = C(2, 1) * S0R + C(2, 2) * S1R + C(2, 3) * S2R;% I45
Inten(:, :, 3)  = C(3, 1) * S0R + C(3, 2) * S1R + C(3, 3) * S2R;% I90
Inten(:, :, 4)  = C(4, 1) * S0R + C(4, 2) * S1R + C(4, 3) * S2R;% I135

Inten(:, :, 5)  = C(1, 1) * S0G + C(1, 2) * S1G + C(1, 3) * S2G;% I0
Inten(:, :, 6)  = C(2, 1) * S0G + C(2, 2) * S1G + C(2, 3) * S2G;% I45
Inten(:, :, 7)  = C(3, 1) * S0G + C(3, 2) * S1G + C(3, 3) * S2G;% I90
Inten(:, :, 8)  = C(4, 1) * S0G + C(4, 2) * S1G + C(4, 3) * S2G;% I135

Inten(:, :, 9)  = C(1, 1) * S0B + C(1, 2) * S1B + C(1, 3) * S2B;% I0
Inten(:, :, 10) = C(2, 1) * S0B + C(2, 2) * S1B + C(2, 3) * S2B;% I45
Inten(:, :, 11) = C(3, 1) * S0B + C(3, 2) * S1B + C(3, 3) * S2B;% I90
Inten(:, :, 12) = C(4, 1) * S0B + C(4, 2) * S1B + C(4, 3) * S2B;% I135
end