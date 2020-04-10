function g_hub = HuberLoss(z,k)

g_hub = zeros(size(z));
if k ~= 0
    g_hub(abs(z)<=k) = (1/2)*(z(abs(z)<=k).^2);
    g_hub(abs(z)>k)  = k*((abs(z(abs(z) > k))) - (1/2)*k);
else
    g_hub  = abs(z);    
end






