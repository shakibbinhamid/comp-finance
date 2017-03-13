%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 5-a: Black-Scholes vs. Binomial Lattice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;

%% step one: prepare data
% load data
load('/home/shakib/Documents/MATLAB/comp-finance/lab 2/Data/prices');
load('/home/shakib/Documents/MATLAB/comp-finance/lab 2/Data/dates');
load('/home/shakib/Documents/MATLAB/comp-finance/lab 2/Data/stock');

% interest rate is fixed
intRate = 6/100;

% list of strike prices for all the 5 call options
% and 5 put options we have
% note that the strike price is different from the option price
strikePrices = [...
    2925, 3025, 3125, 3225, 3325, ...
    2925, 3025, 3125, 3225, 3325];

% neglect the last week as the timeToExpire (in years) becomes to small
% and the calcuations of volatility gives errors
neglectedDays = 30;

% data is divided to training and testing
n = size(stock, 1);
m = length(strikePrices);
nTrain = floor(n/4);
nTest = n-nTrain - neglectedDays;

% pick up a day randomly from 1+(T/4) to T
% in this question, we need only random 1 day form the test data
nSamples = 1;
testIdx = floor(randperm(nTest, nSamples)) + nTrain;

% pick up a random option
nOptions = 1;
optionIdx = int16(randperm(m/2, nOptions));

% current price of the underlying asset
stockPrice = stock(testIdx);

% current price of the option
optionPrice = prices(testIdx,optionIdx);

% strike price of the option
strikePrice = strikePrices(optionIdx);

% time untill the expiration of the option (in years)
expTime = dates(n,optionIdx)+1 - dates(testIdx,optionIdx);
expTime = expTime/365;

% volatility is needed for pricing using Black-Scholes model
pr = prices(testIdx-nTrain:testIdx-1, optionIdx);
sigma = calcVolatility(pr);

%% step two: pricing
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

%latticeN = double(nTrain + nTest - testIdx);
%latticeN = 10000;
%latticeInc = expTime/latticeN;
deltaValues = logspace(1,4,20).^-1;
%deltaValues = [5, 10, 100, 1000, 10000, 50000].^-1;
nDelta = length(deltaValues);
priceLattice = zeros(3, nDelta);
priceLattice_ = zeros(1, nDelta);

% get price using lattice with different delta_t
for i=1:nDelta
    latticeInc = deltaValues(i);
    [~, pLattice] = binprice(stockPrice, strikePrice, intRate, expTime, latticeInc, sigma, optionType);            
    priceLattice(1:2,i) = pLattice(1:2,2);
    if (size(pLattice,2) > 2)
        priceLattice(3,i) = pLattice(2,3);
    end
    %priceLattice_(i) = amPutLattice(stockPrice, strikePrice, intRate , expTime , sigma, int16(expTime/latticeInc));
end

%[~, pLattice] = binprice(52, 50, 0.1, 5/12, 1/12, 0.4, 0, 0, 2.06, 3.5);
% %[AssetPrice, OptionValue] = binprice(Price, Strike, Rate, Time, Increment, Volatility, Flag, DividendRate, Dividend, ExDiv)
% 
% price  =  amPutLattice (SO, K, r , T , sigma, N);
% p,  01  =  binprice(SO,K,r,T,T/N,sigma,O); 
%% plot
error = priceLattice(1,:) - pBlack;
figure(1);clf;
semilogx(deltaValues, error, '.--', 'Color', 'k', 'LineWidth', 1);
hold on;
semilogx(deltaValues, error,  'o', 'MarkerFaceColor','b', 'Color', 'k', 'MarkerSize', 10);
grid on;
box on;
title('Difference in Option Pricing', 'FontSize', 18);
xlabel('Time Increment', 'FontSize', 18);
ylabel('Pricing Difference', 'FontSize', 18);
set(gca, 'XDir', 'reverse');