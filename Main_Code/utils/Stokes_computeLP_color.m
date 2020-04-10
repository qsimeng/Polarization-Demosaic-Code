function [I, DoLP, AoLP, S1, S2] = Stokes_computeLP_color(SV)
% extract four stokes vector images
S0R   = SV(:,:,1);
S1R   = SV(:,:,2);
S2R   = SV(:,:,3);
S0G   = SV(:,:,4);
S1G   = SV(:,:,5);
S2G   = SV(:,:,6);
S0B   = SV(:,:,7);
S1B   = SV(:,:,8);
S2B   = SV(:,:,9);

S1    = cat(3, S1R, S1G, S1B);
S2    = cat(3, S2R, S2G, S2B);
% calculate DoLP and AoLP
IR    = S0R;
DoLPR = sqrt(S1R.^2 + S2R.^2) ./ S0R;
AoLPR = 0.5 * rad2deg(atan2(S2R, S1R));
AoLPR = mod(AoLPR, 180);
DoLPR(isnan(DoLPR)) = 0;

IG    = S0G;
DoLPG = sqrt(S1G.^2 + S2G.^2) ./ S0G;
AoLPG = 0.5 * rad2deg(atan2(S2G, S1G));
AoLPG = mod(AoLPG, 180);
DoLPG(isnan(DoLPG)) = 0;

IB    = S0B;
DoLPB = sqrt(S1B.^2 + S2B.^2) ./ S0B;
AoLPB = 0.5 * rad2deg(atan2(S2B, S1B));
AoLPB = mod(AoLPB, 180);
DoLPB(isnan(DoLPB)) = 0;

I    = cat(3, IR, IG, IB);
DoLP = cat(3, DoLPR, DoLPG, DoLPB);
AoLP = cat(3, AoLPR, AoLPG, AoLPB);
end
