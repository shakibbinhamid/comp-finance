%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 1-a: Auto Regression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;

% load data
load('/home/shakib/Documents/MATLAB/comp-finance/lab 4/data/stockIndex.mat');
%% 
% we depend on the 4th column, which is the close price
y = stockIndex(:,4);
N = size(stockIndex, 1);

% get stock index (monthly) from 1/May/1999 to 1/May/2017
% and this will be the training

% for testing, we take from 2/May/2009 to 1/May/2017
ySplitIndex = 121;
yTrain = y(1:ySplitIndex);
yTest = y(ySplitIndex+1:end);

% get the V, which is the observation noise
arOrder = 3;
[yEstm, arVariance, arResidual, arParams] = autoRegression(y, arOrder);

%% plot the AR estimates vs the training
figure(1); clf;
subplot(2,1,1);
hold on;
grid on;
box on;
axis([0 N -inf inf]);
plot(y, 'b', 'LineWidth', 1);
plot(yEstm, 'r', 'LineWidth', 1);
xlabel('Time (month)', 'FontSize', 16);
ylabel('Value', 'FontSize', 16);
title('AR(3) Index Prediction', 'FontSize', 16);
plot_legend = legend('Actual', 'Estimated', 'Location', 'SE');
set(plot_legend, 'FontSize', 10);
subplot(2,1,2);
hold on;
grid on;
box on;
axis([0 N -inf inf]);
plot(arResidual, 'b', 'LineWidth', 1);
xlabel('Time (month)', 'FontSize', 16);
ylabel('Value', 'FontSize', 16);
title('Prediction Error (Absolute)', 'FontSize', 16);

figure(2); clf;
hold on;
grid on;
box on;
plot(boxplot(arResidual), 'b', 'LineWidth', 1);
ylabel('Prediction Error', 'FontSize', 16);
title('Prediction Error (Absolute)', 'FontSize', 16);

figure(3); clf;
hold on;
grid on;
box on;
plot(boxplot(abs(arResidual)./y), 'b', 'LineWidth', 1);
ylabel('Prediction Error', 'FontSize', 16);
title('Prediction Error (Absolute Percentage)', 'FontSize', 16);






