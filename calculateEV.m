function[E, V] = calculateEV(port_weights, exp_ret, exp_risk)

E = exp_ret' * port_weights;
V = sqrt(port_weights' * exp_risk * port_weights);
