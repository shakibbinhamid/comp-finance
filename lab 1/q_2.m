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

% calcuate the returns for the test data using the 2 different
% weights: the efficient-frontier weights, and the naiive weights
returnsEfficient = zeros(nTest, num_points);
for i=1:num_points
    returnsEfficient(:,i) = returnsTest * effWeights(i,:)';
end
returnsNaive = returnsTest*naiveWeights';

% get the average of all efficient returns
% notice, we only want to get the average on non
returnsEfficientAverage = zeros(nTest, 1);
for i=1:nTest
    returnsEfficientAverage(i) = mean(returnsEfficient(i,:));
end

% now, we want to calcuate the Sharpe Ratio for the returns
% with risk free = 5%
riskFree = 20/100;
sharpeEfficient = zeros(1, num_points);
for i=1:num_points
    sharpeEfficient(i) = (mean(returnsEfficient(:,i)) - riskFree)/std(returnsEfficient(:,i));
end
sharpeNaive = (mean(returnsNaive) - riskFree)/std(returnsNaive);
sharpeEfficientAverage = mean(sharpeEfficient);

% % visualize the pair-wise correlation
% % for the pair-wise returns of 2 stocks
% figure(1);clf;
% box on;
% grid on;
% hold on;
% daspect([1 1 1]);
% plot(returnsTrain(:,1), returnsTrain(:,2), '.r');
% plot(returnsTrain(:,2), returnsTrain(:,3), '.b');
% plot(returnsTrain(:,1), returnsTrain(:,3), '.k');
% plot(returnsTest(:,1), returnsTest(:,2), '.g');
% plot(returnsTest(:,2), returnsTest(:,3), '.g');
% plot(returnsTest(:,1), returnsTest(:,3), '.g');
% 
% % visualize the pair-wise correlation but
% % on the simulated return
% figure(2);clf;
% box on;
% grid on;
% hold on;
% daspect([1 1 1]);
% plot(returnsTrainSim(:,1), returnsTrainSim(:,2), '.r');
% plot(returnsTrainSim(:,2), returnsTrainSim(:,3), '.b');
% plot(returnsTrainSim(:,1), returnsTrainSim(:,3), '.k');



% plot the returns for the efficient protfolios
% vs. return from the naive portfolio
colormap = autumn(num_points+2);
colormap = colormap(1:end-2,:);
figure(4); clf;
box on;
grid on;
hold on;
plot(returnsNaive, 'b', 'LineWidth', 3);
plot(returnsEfficientAverage, 'LineWidth', 3, 'Color', [0 0.7 0.2]);
returnsEfficient = fliplr(returnsEfficient);
for i=1:num_points
    plot(returnsEfficient(:,i), 'LineWidth', 1, 'Color', colormap(i,:));
end
returnsEfficient = fliplr(returnsEfficient);
xlabel('Time (Days)', 'FontSize', 18);
ylabel('Return (%)', 'FontSize', 18);
title('Portfolio Return Over Time', 'FontSize', 18);
fig_legend = legend('Naive Portfolio', 'Efficient Portfolio Avg.', 'Efficient Portfolios', 'Location', 'northwest');
set(fig_legend,'FontSize',16);

% plot the sharpe values
colormap = autumn(num_points);
figure(5); clf;
box on;
grid on;
hold on;
plot([1 num_points], [sharpeNaive sharpeNaive], 'LineWidth', 2, 'Color', 'b');
plot([1 num_points], [sharpeEfficientAverage sharpeEfficientAverage], 'LineWidth', 2, 'Color', [0 0.7 0.2]);
sharpeEfficient = fliplr(sharpeEfficient);
for i=1:num_points
    plot(i, sharpeEfficient(i), '.r', 'MarkerSize', 30, 'Color', colormap(i,:));
    plot(i, sharpeEfficient(i), '.k', 'MarkerSize', 10);
end
sharpeEfficient = fliplr(sharpeEfficient);
xlabel('Portfolio', 'FontSize', 18);
ylabel('Ratio', 'FontSize', 18);
title(strcat('Sharpe Ratio - Risk Free:', int2str(riskFree*100) ,'%' ), 'FontSize', 18);
fig_legend = legend('Naive Portfolio', 'Efficient Portfolio Avg.', 'Efficient Portfolios', 'Location', 'southwest');
set(fig_legend,'FontSize',14);