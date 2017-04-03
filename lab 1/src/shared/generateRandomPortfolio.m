function[E, V] = generateRandomPortfolio(N, exp_ret, exp_risk, useFinToolBox)

E = zeros(N, 1);
V = zeros(N, 1);

portfolio = Portfolio('AssetMean', exp_ret, 'AssetCovar', exp_risk);
portfolio = setDefaultConstraints(portfolio);

for n = 1:N
    randomWeight = rand(length(exp_ret), 1);
    randomWeight = randomWeight / sum(randomWeight);
    if (useFinToolBox)
        [E(n), V(n)] = estimatePortMoments(portfolio, randomWeight);
    else
       [E(n), V(n)] = calculateEV(randomWeight, exp_ret, exp_risk);
    end
end