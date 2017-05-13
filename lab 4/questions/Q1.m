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

X = mvnrnd(W(end,:), Q, 500);
if (o == 3)
    figure(4); clf;
    h = scatter3(X(:,1), X(:,2), X(:,3), ones(500, 1) * 10, ones(500, 1));
    h.MarkerFaceColor = [0 0.5 0.5];
elseif (o == 2)
    figure(4); clf; hold on;
    h = scatter(X(:,1), X(:,2), ones(500, 1) * 10, ones(500, 1));
    h.MarkerFaceColor = [0 0.5 0.5];
    x1 = linspace(min(W(:, 1)), max(W(:, 1))); x2 = linspace(min(W(:, 2)), max(W(:, 2)));
    [X1,X2] = meshgrid(x1,x2);
    F = mvnpdf([X1(:) X2(:)], W(end,:), Q);
    F = reshape(F,length(x2),length(x1));
    contour(x1,x2,F);
end
%%
figure(8); clf;
plot(alphas, errors);
title('Absolute Error as a Function of \alpha', 'Fontsize', 15);
xlabel('\alpha');
ylabel('Sum of Absolute Error');
set(gca, 'XScale', 'log');
grid on;