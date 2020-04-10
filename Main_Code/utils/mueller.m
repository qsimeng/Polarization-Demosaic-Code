function M = mueller(theta, k1, k2)
%   calculates the Mueller matrix M for polarizer angle THETA
%   k1 is the major transmittance, and k2 is the minor transmittance

M = zeros(3, 3);% Mueller matrix, symmetric

M(1, 1) = k1 + k2;
M(1, 2) = (k1 - k2) * cos(2 * deg2rad(theta));
M(1, 3) = (k1 - k2) * sin(2 * deg2rad(theta));

M(2, 1) = (k1 - k2) * cos(2 * deg2rad(theta));
M(2, 2) = (k1 + k2) * cos(2 * deg2rad(theta))^2 + 2 * k1 * k2 * sin(2 * deg2rad(theta))^2;
M(2, 3) = (k1 + k2 - 2 * sqrt(k1 * k2)) * sin(2 * deg2rad(theta)) * cos(2 * deg2rad(theta));

M(3, 1) = (k1 - k2) * sin(2 * deg2rad(theta));
M(3, 2) = (k1 + k2 - 2 * sqrt(k1 * k2)) * sin(2 * deg2rad(theta)) * cos(2 * deg2rad(theta));
M(3, 3) = (k1 + k2) * sin(2 * deg2rad(theta))^2 + 2 * k1 * k2 * cos(2 * deg2rad(theta))^2;

M = 0.5 * M;
end