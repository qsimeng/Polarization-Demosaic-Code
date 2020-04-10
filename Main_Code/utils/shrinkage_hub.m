function z = shrinkage_hub(x, kappa)
z = pos(1 - kappa./abs(x)).*x;
end

function y = pos(x)
y = zeros(size(x));
y(x > 0) = x(x > 0);
end

% function z = shrinkage_hub(a, kappa)
% if abs(a) > kappa
%     z = max(0, a-kappa) - max(0, -a-kappa);
% else
%     z = (1 ./ kappa).*a;
% end
