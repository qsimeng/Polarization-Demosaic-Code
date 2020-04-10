function p = objective_hub(z, delta)
    p = sum(HuberLoss(z(:), delta)) ;
end
