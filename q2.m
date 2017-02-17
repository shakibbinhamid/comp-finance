%% ------------- load ftse data first ---------------
load_fin_data;
max_risk = 0.0088;
%% ------- calculate the avg ret and cov over T days and N assets ---------

% first half of the time series for 3 assets
T = size(R, 1) / 2;
N = 10;
R_ = R(1:T, randperm(30, N));

%% ------------- calculate efficient portfolio

w = calculateEfficientPortfolio(R_, T, N, max_risk);

%% ------------- calculate 1/N portfolio ---------------

w2 = ones(N, 1) / N;

R_1= R(T: size(R, 1), 1:N);
m = sum(R_1) / T;
sharpe_1 = sharpe(R_1 * w);
sharpe_2 = sharpe(R_1 * w2);
total_1 = sum(R_1 * w);
total_2 = sum(R_1 * w2);

%% ------------- compare efficient vs 1/N portfolio ----
figure(2), clf;
title('Cumulative return over time for efficient and 1/N portfolios');
ylabel('Return');
xlabel('Time');
plot(cumsum(R_ * w)), hold on;
plot(cumsum(R_1 * w2));
legend('Efficient portfolio','1/N portfolio')