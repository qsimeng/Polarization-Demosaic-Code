function p = objective_hub_grey(z, delta)
    p = sum(HuberLoss(z(:), delta)) ;
end
