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
neglectedDays = 0; %10

%% divide data into training and testing
n = size(stock, 1);
totalNOptions = length(strikePrices);
nTrain = floor(n/4);
nTest = n-nTrain - neglectedDays;

% in this question, we need only random 50 days
nSamples = 100;
testIdx = floor(randperm(nTest, 140)) + nTrain;
testIdx = sort(testIdx);

errorBlack = zeros(1, nSamples);
errorLattice = zeros(1, nSamples);
errorMonte = zeros(1, nSamples);

%% calculate option prices -------------------
for i=1:nSamples
    
    idxCurrent = testIdx(i);
    stockPrice = stock(idxCurrent);
    
    % pick up a random option
    % we're only interested in Put Options
    nOptions = 1;
    optionIdx = floor(randperm(totalNOptions/2, nOptions));
    optionIdx = optionIdx + totalNOptions/2;
    
    optionPrice = prices(idxCurrent,optionIdx);
    strikePrice = strikePrices(optionIdx);
    expTime = (dates(n,optionIdx)+1 - dates(idxCurrent,optionIdx))/365;
    
    % estimate the volatility based on nTrain historical data
    % note the difference between [blsimpv] and [blkimpv]
    if (optionIdx<=5)
        optionType = 1;
        optionClass = {'call'};
    else
        optionType = 0;
        optionClass = {'put'};
    end
    
    % volatility, this is different than the implied volatility
    pr = prices(idxCurrent-nTrain:idxCurrent-1, optionIdx);
    sigma = calcVolatility(pr);
    
    % get the price using Black-Scholes
    [pCall, pPut]  = blsprice(stockPrice, strikePrice, intRate, expTime, sigma);
    if (optionIdx <= 5)
        pBlack = pCall;
    else
        pBlack = pPut;
    end
    
    % pricing using binomial lattice
    expTimeDays = dates(n,optionIdx)+1 - dates(idxCurrent,optionIdx);
    latticeInc = 1/expTimeDays;
    [~, pLattice] = binprice(stockPrice, strikePrice, intRate, expTime, latticeInc, sigma, optionType);
    
    % pricing using Monte Carlo
    pMonte = mCarlo(stockPrice, strikePrice, intRate, expTime, sigma);
    
    errorBlack(i) = pBlack - optionPrice;
    errorLattice(i) = pLattice(2,3) - optionPrice;
    errorMonte(i) = pMonte - optionPrice;
    
end

%% plot -----------------------------------------------
figure(1);clf;

hold on;grid on;box on;

boxplot([abs(errorBlack); abs(errorLattice); abs(errorMonte);]');

title('Pricing Performance', 'FontSize', 14);
xlabel('Black-Scholes  Binomial Lattice  Monte-Carlo   ', 'FontSize', 14);
ylabel('Absolute Error', 'FontSize', 14);
set(gca, 'XDir', 'reverse');