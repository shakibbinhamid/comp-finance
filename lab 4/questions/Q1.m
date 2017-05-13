clc;

% load data
load('/home/shakib/Documents/MATLAB/comp-finance/lab 4/data/stockIndex.mat');

%%

s = stockIndex(:,4);
alpha = 10^-3;
N = size(s, 1);
o = 3;

[index_pred_autoReg, R, e_autoReg, arParams] = autoRegression(s, o);

% we depend on the 4th column, which is the close price
alphas = zeros(100, 1);
errors = zeros(100, 1);
for i = 1:100
    alphas(i) = 10^-(i/10);
    [~, ~, e_kalman, ~, ~, ~, ~, ~] = kalman(s, o, alphas(i), R);
    
    errors(i) = sum(abs(e_kalman));
end

[Y, W, e_kalman, K, A, Q, P, index_pred_kalman] = kalman(s, o, alpha, R);

e_autoReg = e_autoReg(o:end);
%%
figure(1); clf;

maxError = max([max(abs(e_kalman)) max(abs(e_autoReg))]);

subplot(2, 1, 1);

plot(abs(e_kalman), 'b');
xlim([o N]);
ylim([o maxError]);

title('Kalman Filter Absolute Error');
ylabel('Absolute Error');

subplot(2, 1, 2);

plot(abs(e_autoReg), 'm');
xlim([o N]);
ylim([o maxError]);

title('Autoregression Absolute Error');
ylabel('Absolute Error');

%%

figure(2); clf;
hold on; grid on;

plot(s(o:end), 'g', 'Linewidth', 2);
xlim([o N]);

plot(index_pred_kalman(o:end), 'r');
xlim([o N]);

plot(index_pred_autoReg(o:end), 'b');
xlim([o N]);

title('S&P 500 Monthly Index May 1999 - May 2017', 'Fontsize', 13);
xlabel('Time');
ylabel('Index Value');
legend('Actual Index', 'Kalman Prediction', 'Autoregression Prediction');

%%
figure(3); clf;
boxplot([abs(e_kalman), abs(e_autoReg)], 'Labels', {'Kalman Filter', 'Autoregression'}, 'Colors', 'bm');
title('Absolute Error in S&P Index Prediction', 'Fontsize', 15);
ylabel('Absolute Error')

%%
figure(8); clf;
plot(alphas, errors);
title('Absolute Error as a Function of \alpha', 'Fontsize', 15);
xlabel('\alpha');
ylabel('Sum of Absolute Error');
set(gca, 'XScale', 'log');
grid on;