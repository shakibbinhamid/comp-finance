%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  Black-Scholes model

clc;

% load data
load('/home/shakib/Documents/MATLAB/comp-finance/lab 2/Data/prices.mat');
load('/home/shakib/Documents/MATLAB/comp-finance/lab 2/Data/dates.mat');
load('/home/shakib/Documents/MATLAB/comp-finance/lab 2/Data/stock.mat');

% interet rate is 6.0% = 0.06
segma = 6/100;

[M,N] = size(prices);

% how many options we have (from each type: call and put)
mOptions = N/2;

% get the prices of the call options
%priceCO = 
%ast = options(1:nPrices)

figure(1); clf;
hold on;
grid on;
box on;
for i=1:mOptions
    plot(prices(:,i), 'b');
end








