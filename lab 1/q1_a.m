clc; clearvars;

%% given ------------------------------------------------------------------

mean = [0.1; 0.2; 0.15];
covariance = [0.005, -0.010, 0.004; -0.010 0.040 -0.002; 0.004, -0.002, 0.023];
N = 100;

%% generate the efficient portfolio ---------------------------------------

portfolio = Portfolio('AssetMean', mean, 'AssetCovar', covariance);
portfolio = setDefaultConstraints(portfolio);
effWeights = estimateFrontier(portfolio);
[effRisk, effReturn] = estimatePortMoments(portfolio, effWeights);

%% generate N random sets of weights and calculate return for them --------

risk = zeros(N,1);
returns = zeros(N,1);
for i=1:N
    randomWeight = rand(3, 1);
    randomWeight = randomWeight / norm(randomWeight, 1);
%     risk(i) = mean' * randomWeight;
%     returns(i) = returns(i) + randomWeight' * covariance * randomWeight;
    [risk(i), returns(i)] = estimatePortMoments(portfolio, randomWeight);
end

%% plot E-V ---------------------------------------------------------------

figure(1); clf;
grid on;
hold on;
box on;
plot(effRisk, effReturn, 'r', 'LineWidth', 3);
plot(risk, returns, '.', 'MarkerSize', 8, 'Color', 'b');
xlabel('Risk (V)', 'FontSize', 18);
ylabel('Expected Return (E)', 'FontSize', 18);
title('Efficient Portfolio Frontier', 'FontSize', 18);
fig_legend = legend('Frontier', 'Portfolio', 'Location', 'southeast');
set(fig_legend,'FontSize',16);