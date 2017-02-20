clc;
load_fin_data;
ftse = flipud(ftse);

%% convert returns to percentages -----------------------------------------
first_invest = returns(1, :);
returns = (returns - first_invest) ./ first_invest;
returns = returns(2:end,:);

ftse = (ftse - ftse(1)) ./ ftse(1);
ftse = ftse(2:end,:);

% for testing purpose, if we want the
% index to be the avarage of 20 assets we have
% not the real market index
%[~, ftse] = portfolioAverageReturn(returns);
%ftse = ftse';

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

%% run the GFFS algorithm -------------------------------------------------

% now, with the Greedy-Forward Feature Selection (GFFS) algorithm
% how many assets we want our portfolio to contain
maxSelectedAssets = 6;

% array to contain the indeces of selected assets
selectedAssetsIdx = zeros(1, maxSelectedAssets);
unSelectedAssetsIdx = 1:nAssets;

% max-1 iterations to select the next max-1 assets
for i=1:maxSelectedAssets
    
    avgReturns = zeros(1,length(unSelectedAssetsIdx));
    sharpeRatios = zeros(1,length(unSelectedAssetsIdx));
    rmse = zeros(1,length(unSelectedAssetsIdx));
    
    for j=1:length(unSelectedAssetsIdx)
        % collect the assets inside the portfolio
        idx = [nonzeros(selectedAssetsIdx)' unSelectedAssetsIdx(j)];
        portfolioReturns = returnsTrain(:,idx);
        avgReturns(j) = portfolioAverageReturn(portfolioReturns);
        sharpeRatios(j) = portfolioSharpeRatio(portfolioReturns);
        rmse(j) = portfolioError(portfolioReturns, ftseTest);
    end
    
    [~, idx] = min(rmse);
    selectedAssetsIdx(i) = unSelectedAssetsIdx(idx);
    unSelectedAssetsIdx(unSelectedAssetsIdx==selectedAssetsIdx(i)) = [];
end

% returns of our final portfolio
[~, avgReturnTrain] = portfolioAverageReturn(returnsTrain(:, selectedAssetsIdx));
[~, avgReturnTest] = portfolioAverageReturn(returnsTest(:, selectedAssetsIdx));

% plot results
figure(1); clf;

subplot(1,2,1);
hold on;
grid on;
box on;
for i=1:20
    if (ismember(i, selectedAssetsIdx))
        w = 1;
        c = [0 0.7 0.2];
        plot1 = plot(returnsTrain(:,i), 'LineWidth', w, 'Color', c);
    else
        w = 0.1;
        c = [0.7 0.7 0.7];
        plot2 = plot(returnsTrain(:,i), 'LineWidth', w, 'Color', c);
    end    
end
plot3 = plot(ftseTrain, 'b', 'LineWidth', 2);
plot4 = plot(avgReturnTrain, 'r', 'LineWidth', 2);
xlabel('Time (Days)', 'FontSize', 18);
ylabel('Return (%)', 'FontSize', 18);
title('Index Tracking (Training)', 'FontSize', 18);
fig_legend = legend([plot4, plot3, plot1, plot2], {'Our Portfolio', 'Market Index', 'Selected Assets', 'Unselected Assets'}, 'Location', 'northwest');
set(fig_legend,'FontSize',14);

subplot(1,2,2);
hold on;
grid on;
box on;
for i=1:20
    if (ismember(i, selectedAssetsIdx))
        w = 1;
        c = [0 0.7 0.2];
        plot1 = plot(returnsTest(:,i), 'LineWidth', w, 'Color', c);
    else
        w = 0.1;
        c = [0.7 0.7 0.7];
        plot2 = plot(returnsTest(:,i), 'LineWidth', w, 'Color', c);
    end
    
end
plot3 = plot(ftseTest, 'b', 'LineWidth', 2);
plot4 = plot(avgReturnTest, 'r', 'LineWidth', 2);
xlabel('Time (Days)', 'FontSize', 18);
ylabel('Return (%)', 'FontSize', 18);
title('Index Tracking (Testing)', 'FontSize', 18);
fig_legend = legend([plot4, plot3, plot1, plot2], {'Our Portfolio', 'Market Index', 'Selected Assets', 'Unselected Assets'}, 'Location', 'northwest');
set(fig_legend,'FontSize',14);