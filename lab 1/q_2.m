%% --------------------- clear and load the data --------------------------
clc;
load_fin_data;
%% ---------converting the returns for each asset to percentages-----------
% returns is T x N portfolio returns where T = time ticks, N = #assets
% row(i+1) = (row(i) - row(1))/row(1)
% remove row(1) since it's just 0's
% then select n columns or assets to look at. here n = 3

first_invest = returns(1, :);
returns = (returns - first_invest) ./ first_invest;
returns = returns(2:end,:);
returns = returns(:,randperm(30, 3));

%% ------- calculate the training and testing data in 50-50 ratio ---------
nAssets = size(returns,2);
nTotal = size(returns,1);
nTrain = int16(nTotal/2);
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

effWeights = estimateFrontier(p, num_points);
[effRisk, effReturn] = estimatePortMoments(p, effWeights);
effWeights = effWeights';

% plot the E-V graph (efficient frontier we get from the train data)
figure(1); clf;
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

effReturn = returnsTest * effWeights(num_points/2, :)';
naiveReturn = returnsTest * naiveWeights';

% plot the returns for the efficient protfolios vs. return from the naive portfolio
figure(2); clf;
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

%% ------- calculate sharpe ratio for both naive and eff portfolio --------

% risk free = 5%
riskFree = 5/100;
naiveSharpe = (mean(naiveReturn) - riskFree)/std(naiveReturn);
effSharpe = (mean(effReturn) - riskFree)/std(effReturn);

% plot the sharpe values
figure(3); clf;
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