function[V, E] = calculateEV(randomWeight, exp_ret, exp_risk)

E = randomWeight' * exp_ret;

V = sqrt(randomWeight' * exp_risk * randomWeight);