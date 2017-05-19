%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 1-a: Lasso Regression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;

% load data
load('/home/shakib/Documents/MATLAB/comp-finance/lab 4/data/features');
load('/home/shakib/Documents/MATLAB/comp-finance/lab 4/data/stockIndex');
load('/home/shakib/Documents/MATLAB/comp-finance/lab 4/data/kalman_estimate');
load('/home/shakib/Documents/MATLAB/comp-finance/lab 4/data/autoreg_estimate');

%%

N = size(data, 1);
index_pred_kalman = index_pred_kalman(4:N);
index_pred_autoReg = index_pred_autoReg(4:N);
stockIndex = stockIndex(4:N)';
data = data(4:end,:);
N = N - 3;

%%
% normalize the predictors, i.e the features
normFeatures = zscore(data);

%%
% build a lasso regression model to see which of these
% features is of a great important, i.e. which of these
% micro-ecoonomic predictor has a greate influence
% in predicting the stock index

% lassoTarget is the residue of the Kalman filter
% make sure to normalize it
lassoTarget = zscore(stockIndex - index_pred_kalman);

feature_names = {'PRE','OIL','PMI','INCOME','CORP PROFIT', 'POPULATION', 'UNEMPLOYED'};

% lasso regression
[lassoWeights,lassoInfo] = lasso(normFeatures,lassoTarget, 'CV',5, 'PredictorNames', feature_names);
lassoLambda = lassoInfo.Lambda;

% find the best set of weights by calculating the error
lassoErrors = zeros(length(lassoLambda),1);
for i=1:length(lassoErrors)
    lassoResult = normFeatures * lassoWeights(:, i);
    lassoErrors(i) = mean(abs(lassoResult-lassoTarget));
end

%
numberOfNnz = lassoInfo.DF;

%% plot the errors of lasso
figure(1); clf;
hold on;
grid on;
box on;
plot(lassoLambda, lassoErrors, 'LineWidth', 2);
xlabel('Lasso Regulariser');
ylabel('Mean Absoute Normalised Noise Prediction Error');
xlim([min(lassoLambda), max(lassoLambda)]);
title('Mean Absolute Error vs Lasso Regression');

%% plot the weights
figure(2); clf;
subplot(1,2,1);
colorMap = lines(10);
hold on;
grid on;
box on;
plot(lassoLambda, lassoWeights', 'LineWidth', 2);
xlabel('Lasso Regulariser');
ylabel('Weight Value');
xlim([min(lassoLambda), max(lassoLambda)]);
title('Decay of Feature Weights in Lasso Regression');
plot_legend = legend('PER','OIL','PMI','INCOME','CORP PROFIT','POPULATION','UNEMPLOYMENT', 'Location', 'SE');
set(plot_legend, 'FontSize', 10);

subplot(1,2,2);
plot(lassoLambda, numberOfNnz, 'LineWidth', 1.5);
title('#(Non Zero Coefficients) as f(Lasso Regularizer)');
xlabel('Lasso Regularizer');
ylabel('#(Non Zero Coefficients)');
xlim([min(lassoLambda), max(lassoLambda)]);
grid on;

%% plot the AR/Kalman estimates vs the training

% use the weights of the smallest error
% it is chosen imperically
lassoResult = normFeatures * lassoWeights(:, 81);

coloMap = lines(30);
colorGreen = [0 0.7 0.2];
figure(3); clf;
hold on;
grid on;
box on;
plot1 = plot(lassoTarget, 'LineWidth', 1, 'Color', 'b');
plot2 = plot(lassoResult, 'LineWidth', 1, 'Color', 'r');
xlabel('Time');
ylabel('Normalised Noise');
xlim([1 N]);
title('Kalman Actual Residual and Predicted Residual');
plot_legend = legend('Actual Noise', 'Predicted Noise');

%%
lassoPlot(lassoWeights, lassoInfo,'PlotType','CV');
grid on;
