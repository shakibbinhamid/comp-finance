%% --------------------- clear and load the data --------------------------

clc; clear;
load_fin_data;

%% ---------converting the returns for each asset to percentages-----------
rng(1)
nAssets = 3;
 returns = R;
returns = returns(:,randperm(30, nAssets));

%% ------- calculate the training and testing data in 50-50 ratio ---------

nTotal = size(returns,1);
nTrain = floor(nTotal/2);
nTest = nTotal - nTrain;

% split the returns to train and test
returnsTrain = returns(1:nTrain,:);
returnsTest = returns(nTrain+1:nTotal,:);

% get mean and covariance for these returns
rMean = mean(returnsTrain);
rCovar = cov(returnsTrain);

%% ---- efficient markowitz portfolio based on data from the first half ---
num_points = 100;

% calcuate efficient forntier
p = Portfolio;
p = setAssetMoments(p, rMean, rCovar);
p = setDefaultConstraints(p);
p = setBounds(p, 0, 1);

effWeights = estimateFrontier(p, num_points);
[effRisk, effReturn] = estimatePortMoments(p, effWeights);
effWeights = effWeights';

% plot the E-V graph (efficient frontier we get from the train data)
set(gcf, 'Units', 'Inches', 'Position', [0, 0, 20, 6], 'PaperUnits', 'Inches', 'PaperSize', [7.25, 9.125])
figure(1); clf;
subplot(1,4,1);
box on;
grid on;
hold on;
plotFrontier(p, num_points);
xlabel('Risk (V)', 'FontSize', 18);
ylabel('Expected Return (E)', 'FontSize', 18);
title('Efficient Portfolio Frontier', 'FontSize', 18);
fig_legend = legend('Efficient Frontier', 'Location', 'southeast');
set(fig_legend,'FontSize',16);

%% -------- naive 1/N portfolio based on data from the first half ---------

naiveWeights = ones(1, nAssets) *(1/nAssets);

%% --------- calculate returns for both naive and eff portfolio -----------

% which effWeight to pick on the efficient frontier? currently it's the
% middle one. we probably want to target a return and get the wts for that
max_risk = 0.08;
effReturn = returnsTest * calculateEfficientPortfolio(returnsTrain, nTotal, nAssets, max_risk);
naiveReturn = returnsTest * naiveWeights';

% plot the returns for the efficient protfolios vs. return from the naive portfolio
subplot(1,4,2);
box on;
grid on;
hold on;
plot(naiveReturn, 'b', 'LineWidth', 2);
plot(effReturn, 'r', 'LineWidth', 2);
xlabel('Time (Days)', 'FontSize', 18);
ylabel('Return (%)', 'FontSize', 18);
title('Portfolio Return Over Time', 'FontSize', 18);
fig_legend = legend('Naive Portfolio', 'Efficient Portfolios', 'Location', 'northwest');
set(fig_legend,'FontSize',16);

subplot(1,4,3);
title('Cumulative return over time for efficient and 1/N portfolios');
ylabel('Return');
xlabel('Time');
plot(cumsum(naiveReturn)), hold on;
plot(cumsum(effReturn));
xlabel('Cumulative Return', 'FontSize', 18);
ylabel('Time (Days)', 'FontSize', 18);
title(strcat('Cumulative Return over Time' ), 'FontSize', 18);
legend('1/N portfolio', 'Efficient portfolio');

%% ------- calculate sharpe ratio for both naive and eff portfolio --------

% risk free = 5%
riskFree = 0;
naiveSharpe = (mean(naiveReturn) - riskFree)/std(naiveReturn);
effSharpe = (mean(effReturn) - riskFree)/std(effReturn);

% plot the sharpe values
subplot(1,4,4);
box on;
grid on;
hold on;
plot([1 nAssets], [naiveSharpe naiveSharpe], 'LineWidth', 2, 'Color', 'b');
plot([1 nAssets], [effSharpe effSharpe], 'LineWidth', 2, 'Color', 'r');
xlabel('Portfolio', 'FontSize', 18);
ylabel('Ratio', 'FontSize', 18);
title(strcat('Sharpe Ratio - Risk Free:', int2str(riskFree*100) ,'%' ), 'FontSize', 18);
fig_legend = legend('Naive Portfolio', 'Efficient Portfolios', 'Location', 'east');
set(fig_legend,'FontSize',14);