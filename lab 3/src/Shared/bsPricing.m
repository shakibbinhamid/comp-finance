% this function will generate BLS prices dataset --------------------------
function [sxTrain, sxTest, ttmTrain, ttmTest, fxTrainBS, fxTrain, fxTest, deltas] = bsPricing()

%% given data -------------------------------------------------------------
load('/home/shakib/Documents/MATLAB/comp-finance/lab 3/Data/prices');
load('/home/shakib/Documents/MATLAB/comp-finance/lab 3/Data/dates');
load('/home/shakib/Documents/MATLAB/comp-finance/lab 3/Data/stock');

intRate = 6/100;
strikePrices = [2925, 3025, 3125, 3225, 3325, ...
                2925, 3025, 3125, 3225, 3325];

% neglect the last week as the timeToExpire (in years) becomes to small
% and the calcuations of volatility gives errors
neglectedDays = 10;

%% divide the data for training and validation ----------------------------
numberOfDays = size(stock,1);
numberOfCountedDays = numberOfDays - neglectedDays;
numberOfOptions = length(strikePrices);
numberOfTrainDays = floor(numberOfDays/4);
numberOfTestDays = numberOfCountedDays - numberOfTrainDays;

%% generate BLS prices ----------------------------------------------------
estmPrices = zeros(numberOfTestDays,numberOfOptions);
deltas = zeros(numberOfTestDays,numberOfOptions);
ttmTrain = zeros(numberOfTestDays,1); % ttm = time to maturity
tMat = dates(numberOfTrainDays+numberOfTestDays+1);

% loop on the test days, calcuate the volatility and BLS price ------------
for i=1:numberOfTestDays
    
    idxCurrent = i + numberOfTrainDays;
    stockPrice = stock(idxCurrent);
    expTime = (tMat - dates(idxCurrent))/252; % ? should be 365?
    ttmTrain(i) = expTime;
    
    % calculate BLS price for each option
    for j=1:numberOfOptions
        
        strikePrice = strikePrices(j);
        histPrices = prices(i:numberOfTrainDays+i-1, j);
        sigma = calcVolatility1(histPrices);
        % sigmaValues(i,j) = sigma;
        deltas(i,j) = blsdelta(stockPrice, strikePrice, intRate, expTime, sigma);
        
        % BLS price
        [pCall, pPut] = blsprice(stockPrice, strikePrice, intRate, expTime, sigma);
        if (j <= 5)
            estmPrices(i,j) = pCall;
        else
            estmPrices(i,j) = pPut;
        end
    end
    
end

%% normalizing to (c/K, s/K) instead of (c, s)

% normalize by dividing by strike price
% normalize the predicted prices as well
sx = zeros(numberOfTestDays+numberOfTrainDays,numberOfOptions);
fx = zeros(numberOfTestDays+numberOfTrainDays,numberOfOptions);
fxTrainBS = zeros(numberOfTestDays,numberOfOptions);

for i=1:numberOfOptions
    sx(:,i) = stock(1:numberOfCountedDays)/strikePrices(i);
    fx(:,i) = prices(1:numberOfCountedDays,i)/strikePrices(i);
    fxTrainBS(:,i) = estmPrices(:,i)/strikePrices(i);
end

sxTest = sx(1:numberOfTrainDays,:);
sxTrain = sx(numberOfTrainDays+1:end,:);

ttmTest = zeros(numberOfTrainDays,1);
for i=1:numberOfTrainDays
    expTime = (tMat - dates(i))/365;
    ttmTest(i) = expTime;
end

% split the normalized option prices
fxTrain = fx(numberOfTrainDays+1:numberOfCountedDays,:);
fxTest = fx(1:numberOfTrainDays,:);

end