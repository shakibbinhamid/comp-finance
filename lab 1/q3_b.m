clc;
load_fin_data;
ftse = flipud(ftse);
%% calculate percentage returns -------------------------------------------
first_invest = returns(1, :);
returns = (returns - first_invest) ./ first_invest;
returns = returns(2:end,:);

ftse = (ftse - ftse(1)) ./ ftse(1);
ftse = ftse(2:end,:);

% for testing purpose, if we want the
% index to be the avarage of 20 assets we have
% not the real market index
% [~, ftse] = portfolioAverageReturn(returns);
% ftse = ftse';

%% divide into train and test set as 50-50 --------------------------------
nAssets = size(returns,2);
nTotal = size(returns,1);
nTrain = floor(nTotal/2);
nTest = nTotal - nTrain;

% split the returns to train and test
returnsTrain = returns(1:nTrain,:);
returnsTest = returns(nTrain+1:nTotal,:);
ftseTrain = ftse(1:nTrain);
ftseTest = ftse(nTrain+1:nTotal);

%% run lasso regression to keep only the top k dominant assets ------------
maxSelectedAssets = 6;
taw = 0.42;
% get the weights and assets by doing lasso regression
[weights, selectedAssets] = sparseIndexTracking(returnsTrain, ftseTrain, maxSelectedAssets, taw);

% returns of sparse portfolio
avgReturnTrain = returnsTrain(:, selectedAssets) * weights;
avgReturnTest = returnsTest(:, selectedAssets) * weights;

%% plot index tracking on training data -----------------------------------
% plot results
figure(1); clf;

subplot(1,2,1);
hold on;
grid on;
box on;

green = [0 0.7 0.2];
grey = [0.7 0.7 0.7];

for i=1:nAssets
    if (ismember(i, selectedAssets))
        plot1 = plot(returnsTrain(:,i), 'LineWidth', 1, 'Color', green);
    else
        plot2 = plot(returnsTrain(:,i), 'LineWidth', 0.1, 'Color', grey);
    end    
end
plot3 = plot(ftseTrain, 'b', 'LineWidth', 2);
plot4 = plot(avgReturnTrain, 'r', 'LineWidth', 2);
xlabel('Time (Days)', 'FontSize', 18);
ylabel('Return (%)', 'FontSize', 18);
title('Index Tracking (Training)', 'FontSize', 18);
fig_legend = legend([plot4, plot3, plot1, plot2], {'Our Portfolio', 'Market Index', 'Selected Assets', 'Unselected Assets'}, 'Location', 'northwest');
set(fig_legend,'FontSize',14);

%% testing data -----------------------------------------------------------
subplot(1,2,2);
hold on;
grid on;
box on;
for i=1:nAssets
    if (ismember(i, selectedAssets))
        plot1 = plot(returnsTest(:,i), 'LineWidth', 1, 'Color', green);
    else
        plot2 = plot(returnsTest(:,i), 'LineWidth', 0.1, 'Color', grey);
    end
    
end
plot3 = plot(ftseTest, 'b', 'LineWidth', 2);
plot4 = plot(avgReturnTest, 'r', 'LineWidth', 2);
xlabel('Time (Days)', 'FontSize', 18);
ylabel('Return (%)', 'FontSize', 18);
title('Index Tracking (Testing)', 'FontSize', 18);
fig_legend = legend([plot4, plot3, plot1, plot2], {'Our Portfolio', 'Market Index', 'Selected Assets', 'Unselected Assets'}, 'Location', 'northwest');
set(fig_legend,'FontSize',14);