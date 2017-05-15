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
    [~, ~, e_kalman, ~, ~, ~, ~] = kalman(s, o, alphas(i));
    
    errors(i) = sum(abs(e_kalman));
end

[Y, W, e_kalman, K, Q, P, index_pred_kalman] = kalman(s, o, alpha);

e_autoReg = e_autoReg(o:end);
%%
figure(1); clf;

maxError = max([max(abs(e_kalman)) max(abs(e_autoReg))]);

subplot(2, 1, 1);

plot(abs(e_kalman), 'b');
grid on;
xlim([o N]);
ylim([o maxError]);

title('Kalman Filter Absolute Error');
ylabel('Absolute Error');
xlabel('Time');

subplot(2, 1, 2);

plot(abs(e_autoReg), 'm');
grid on;
xlim([o N]);
ylim([o maxError]);

title('Autoregression Absolute Error');
ylabel('Absolute Error');
xlabel('Time');

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
boxplot([abs(e_kalman(o:end)), abs(e_autoReg)], 'Labels', {'Kalman Filter', 'Autoregression'}, 'Colors', 'bm');
title('Absolute Error in S&P Index Prediction', 'Fontsize', 15);
ylabel('Absolute Error')

%%

X = mvnrnd(W(end,:), P, 500);
if (o == 3)
    figure; clf;
    grid on;
    
    h = scatter3(X(:,1), X(:,2), X(:,3), ones(500, 1) * 10, ones(500, 1));
    h.MarkerFaceColor = [0 0.5 0.5];
    
    title('Gaussian Distribution \mu=W_n \Sigma=P');
elseif (o == 2)
    figure; clf; hold on;
    grid on;
    
    x1 = linspace(W(end,1) - 0.5, W(end,1) + 0.5); x2 = linspace(W(end, 2) - 0.5, W(end, 2) + 0.5);
    [X1,X2] = meshgrid(x1,x2);
    F = mvnpdf([X1(:) X2(:)], W(end,:), P);
    F = reshape(F,length(x2),length(x1));
    contour(x1,x2,F);
    
    title('Gaussian Distribution \mu=W_n \Sigma=P');
end
%%
figure; clf;
plot(alphas, errors);
title('Absolute Error as a Function of \alpha', 'Fontsize', 15);
xlabel('\alpha');
ylabel('Sum of Absolute Error');
set(gca, 'XScale', 'log');
grid on;

%%
figure; clf; hold on; grid on;

for i=1:o
   
    plot(W(:,i), 'Linewidth', 1.5);
    
end

title('Parameters Converging');
ylabel('Parameter Component Value');
xlabel('Time');

%%
N = 1000;

ts = zeros(N, 1);
noise = wgn(N, 1, 20);

ts(1:3) = ones(3, 1) * 2000;
for n = 4:N
    ts(n) = 0.5 * ts(n - 1) + 0.6 * ts(n - 2) - 0.1 * ts(n - 3) + noise(n);
end

[~, R, ~, ~] = autoRegression(ts, 3);

[Y, W, e, K, Q, P, s_] = kalman(ts, 3, 0.000000001);

figure; clf; hold on; grid on;

for i=1:3
   
    plot(W(:,i), 'Linewidth', 1.5);
    
end

title('Parameters Converging');
ylabel('Parameter Component Value');
xlabel('Time');
