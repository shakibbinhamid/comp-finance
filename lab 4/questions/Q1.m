clc;

% load data
load('/home/shakib/Documents/MATLAB/comp-finance/lab 4/data/stockIndex.mat');

% we depend on the 4th column, which is the close price

s = stockIndex(:,4);
alpha = 10^-3;
N = size(s, 1);
o = 3;

[index_pred_autoReg, R, e_autoReg, arParams] = autoRegression(s, o);

[Y, W, e_kalman, K, A, Q, P, index_pred_kalman] = kalman(s, o, alpha, R);


%%
figure(1); clf;
plot(e_kalman);

figure(2); clf;
plot(e_autoReg);

%%
figure(3); clf;
boxplot(e_kalman);

figure(4); clf;
boxplot(e_autoReg);