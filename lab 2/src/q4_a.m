clc;

%% load data --------------------------------------
load('/home/shakib/Documents/MATLAB/comp-finance/lab 2/Data/prices');
load('/home/shakib/Documents/MATLAB/comp-finance/lab 2/Data/dates');
load('/home/shakib/Documents/MATLAB/comp-finance/lab 2/Data/stock');

% interest rate is fixed
intRate = 6/100;
strikePrices = [2925, 3025, 3125, 3225, 3325, ...
                        2925, 3025, 3125, 3225, 3325];

% neglect the last week as the timeToExpire (in years) becomes to small
% and the calcuations of volatility gives errors
neglectedDays = 0; %30

%% dividing data in training and testing
nTotalDays = size(stock, 1);
nTotalOptions = length(strikePrices);
nTrainDays = floor(nTotalDays/4);
nTestDays = nTotalDays-nTrainDays - neglectedDays;

% pick up a day randomly from 1+(T/4) to T
% in this question, we need only random 1 day form the test data
nSamples = 1;
testIdx = floor(randperm(nTestDays, nSamples)) + nTrainDays;

% pick up a random option
nOptions = 1;
optionIdx = floor(randperm(nTotalOptions/2, nOptions));

stockPrice = stock(testIdx);
optionPrice = prices(testIdx,optionIdx);
strikePrice = strikePrices(optionIdx);
expTime = (dates(nTotalDays,optionIdx)+1 - dates(testIdx,optionIdx))/365;

% volatility is needed for pricing using Black-Scholes model
trainingPrices = prices(testIdx-nTrainDays:testIdx-1, optionIdx);
sigma = calcVolatility(trainingPrices);

%% BLS -----------------------------------------------
% estimate the call price using Black-Scholes and Binomial Lattice

% get the price using Black-Scholes
% estimate the volatility based on nTrain historical data
% note the difference between [blsimpv] and [blkimpv]
[pCall, pPut]  = blsprice(stockPrice, strikePrice, intRate, expTime, sigma);
if (optionIdx <= 5)
    pBlack = pCall;
    optionType = 1;
    optionClass = {'call'};
else
    pBlack = pPut;
    optionType = 0;
    optionClass = {'put'};
end

%% Binomial Lattice -----------------------------
deltaValues = logspace(1,4,20).^-1;
nDelta = length(deltaValues);
priceLattice = zeros(3, nDelta);

% get price using lattice with different delta_t
for i=1:nDelta
    latticeInc = deltaValues(i);
    [~, pLattice] = binprice(stockPrice, strikePrice, intRate, expTime, latticeInc, sigma, optionType);            
    priceLattice(1:2,i) = pLattice(1:2,2);
    if (size(pLattice,2) > 2)
        priceLattice(3,i) = pLattice(2,3);
    end
end

%% plot -----------------------------------------------
error = abs(priceLattice(1,:) - pBlack);
figure(1);clf;
semilogx(deltaValues, error, '--', 'Color', 'b', 'LineWidth', 1);
hold on;
semilogx(deltaValues, error,  'o', 'MarkerFaceColor','m', 'Color', 'k', 'MarkerSize', 6);
grid on;
box on;
title('Absolute Difference in Option Pricing', 'FontSize', 14);
xlabel('\delta t', 'FontSize', 14);
ylabel('Pricing Difference', 'FontSize', 14);
set(gca, 'XDir', 'reverse');