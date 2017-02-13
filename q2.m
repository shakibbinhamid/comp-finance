%% ------------- load ftse data first ---------------
load_fin_data;
max_risk = 0.0088;
%% ------------- calculate the avg ret and cov over T days and N assets ---------

% first half of the time series for 3 assets
T = size(R, 1) / 2;
N = 3;
R_ = R(1:T, 1:N);

m = sum(R_) / T;

C = zeros(N, N);
for t = 1:T
    C = C + (R_(t, :) - m)' * (R_(t, :) - m);
end
C = C / T;

%% ------------- calculate efficient portfolio ----------
cvx_begin quiet
variable w(3)
    maximize(w' * m')
    subject to
        w' * C * w <= max_risk ^ 2; % max tolerable risk
        w' * ones(3, 1) == 1; % proportions add to 1
        w >= 0; % no short selling
cvx_end

w2 = [1, 1, 1]';
w2 = w2 / norm(w2, 1);

%% ------------- calculate 1/N portfolio ---------------

R_1= R(T + 1: size(R, 1), 1:N);
m = sum(R_1) / T;
sharpe_1 = sharpe(R_1 * w);
sharpe_2 = sharpe(R_1 * w2);
total_1 = sum(R_1 * w);
total_2 = sum(R_1 * w2);

%% ------------- compare efficient vs 1/N portfolio ----
plot(cumsum(R_ * w));
hold on;
plot(cumsum(R_1 * w2));
title('Cumulative return over time for efficient and 1/N portfolios');
ylabel('Return');
xlabel('Time');
legend('Efficient portfolio','1/N portfolio')