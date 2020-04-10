function PSNRa = psnr_angle(beta, alpha, deg)

% calculate PSNR by considering the 180 angle wraparound.



if nargin < 3

    deg = true;

end



if ~deg

    % convert from rad to deg

    beta = beta * 180 / pi;

    alpha = alpha * 180 / pi;

end



err1 = beta - alpha;

err2 = 180 - abs(beta - alpha);



err = min(abs(err1), abs(err2));



MSEa = norm(err(:), 2).^2 / numel(err(:));

PSNRa = 10 * log10 (180^2 / MSEa);



% MSEb = norm(err1(:), 2).^2 / numel(err1(:));

% PSNRb = 10 * log10 (180^2 / MSEb);



end