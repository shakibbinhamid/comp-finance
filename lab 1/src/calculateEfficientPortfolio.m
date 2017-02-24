function[w] = calculateEfficientPortfolio(returns, T, N_assets, max_risk)

m = mean(returns);
C = cov(returns);

%% ------------- calculate efficient portfolio ----------
cvx_begin quiet
variable w(N_assets)
    maximize(w' * m')
    subject to
        w' * C * w <= max_risk ^ 2; % max tolerable risk
        w' * ones(N_assets, 1) == 1; % proportions add to 1
        w >= 0; % no short selling
cvx_end
