%% ------------- load ftse data first ---------------
load_fin_data;
max_risk = 0.088;
%% ------- calculate the avg ret and cov over T days and N assets ---------

% first half of the time series for 3 assets
T = nTrain;
R_ = R(1:T, randperm(30, nAssets));
R_1= R(T: size(R, 1), 1:nAssets);

%% ------------- calculate efficient portfolio

w = calculateEfficientPortfolio(R_, T, nAssets, max_risk);

%% ------------- calculate 1/N portfolio ---------------

w2 = ones(nAssets, 1) / nAssets;

%% ---------------- sharpe ratio ---------------------------
m = sum(R_1) / T;
sharpe_1 = sharpe(R_1 * w);
sharpe_2 = sharpe(R_1 * w2);
total_1 = sum(R_1 * w);
total_2 = sum(R_1 * w2);

%% ------------- compare efficient vs 1/N portfolio ----
subplot(1,4,3);
title('Cumulative return over time for efficient and 1/N portfolios');
ylabel('Return');
xlabel('Time');
% plot(cumsum(effReturn)), hold on;
% plot(cumsum(naiveReturn));
plot(cumsum(R_ * w)), hold on;
plot(cumsum(R_1 * w2));
legend('Efficient portfolio','1/N portfolio')