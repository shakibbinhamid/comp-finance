function[E, V] = generateRandomPortfolio(N, exp_ret, exp_risk)

E = zeros(N, 1);
V = zeros(N, 1);

for n = 1:N
    y = rand(length(exp_ret), 1);
    y = y / sum(y);
    [E(n), V(n)] = calculateEV(y, exp_ret, exp_risk);
end