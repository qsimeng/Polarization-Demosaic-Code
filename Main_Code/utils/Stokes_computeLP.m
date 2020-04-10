function [I, DoLP, AoLP] = Stokes_computeLP(SV)
% extract four stokes vector images
S0   = SV(:,:,1);
S1   = SV(:,:,2);
S2   = SV(:,:,3);
% calculate DoLP and AoLP
I = S0;
DoLP = sqrt(S1.^2 + S2.^2) ./ S0;
AoLP = 0.5 * rad2deg(atan2(S2, S1));
AoLP = mod(AoLP, 180);
end
