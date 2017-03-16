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
neglectedDays = 0; % 10

%% divide into training and validation data 

n = size(stock, 1);
nOptions = length(strikePrices);
nTrain = floor(n/4);
nTest = n-nTrain - neglectedDays;

% in this question, we need only random 30 days form
% the test data
nSamples = 68;
testIdx = floor(randperm(nTest, nSamples)) + nTrain;
testIdx = sort(testIdx);

impliedVolatilityValues = zeros(nTest,nOptions);
volatilityValues = zeros(nTest,nOptions);

% loop on the test data. for each one, calcuate the volatility
% from train data and estimate the call price and save it
for i=1:nSamples
    
    idx = testIdx(i);
    stockPrice = stock(idx);
    
    for j=1:nOptions
        
        optionPrice = prices(idx,j);
        strikePrice = strikePrices(j);
        expTime = (dates(n,j)+1 - dates(idx,j))/365;
        
        % estimate the volatility based on nTrain historical data
        % note the difference between [blsimpv] and [blkimpv]
        if (j<=5)
            optionClass = {'call'};
        else
            optionClass = {'put'};
        end
        
        % implied volatility
        volt = blsimpv(stockPrice, strikePrice, intRate, expTime, optionPrice, [], [], [], optionClass);
        if (isnan(volt))
             volt = 0;
        end
        impliedVolatilityValues(i,j) = volt;
        
        % historical volatility
        pr = prices(idx-nTrain:idx-1, j);
        volatilityValues(i,j) = calcVolatility(pr);
    end
    
end

% this is to choose the days whose volatilites are not zero
volatilityValues_ = [];
impliedVolatilityValues_ = [];
dates_ = [];
stock_ = [];
for i=1:nSamples
    v = impliedVolatilityValues(i,:);
    if (isempty(v(v==0)))
        volatilityValues_ = [volatilityValues_; v];
        impliedVolatilityValues_ = [impliedVolatilityValues_; volatilityValues(i,:)];
        dates_ = [dates_; dates(i,:)];
        stock_ = [stock_; stock(i)];
    end
end

%% scatter plot historical vs. implied volatility
colorMap = lines(5);
colorIdx = [1 2 3 4 5];

figure(1);clf;

subplot(1,2,1);
hold on;grid on;box on;

for i=1:nOptions/2
    plot(volatilityValues_(:,i), impliedVolatilityValues_(:,i), '.', 'MarkerSize', 20, 'Color', colorMap(colorIdx(i),:));
end

title('Historical vs. Implied Volatility', 'FontSize', 14);
xlabel('Implied Volatility', 'FontSize', 14);
ylabel('Historical Volatility', 'FontSize', 14);
plotLegend = legend('Call 1', 'Call 2', 'Call 3', 'Call 4', 'Call 5', 'Location', 'nw');
set(plotLegend, 'FontSize', 10);

subplot(1,2,2);
hold on;grid on;box on;

for i=1+(nOptions/2):nOptions
    plot(volatilityValues_(:,i), impliedVolatilityValues_(:,i), '.', 'MarkerSize', 20, 'Color', colorMap(colorIdx(i-(nOptions/2)),:));
end

title('Historical vs. Implied Volatility', 'FontSize', 14);
xlabel('Implied Volatility', 'FontSize', 14);
ylabel('Historical Volatility', 'FontSize', 14);
plotLegend = legend('Put 1', 'Put 2', 'Put 3', 'Put 4', 'Put 5', 'Location', 'nw');
set(plotLegend, 'FontSize', 10);

%% plot historical vs. implied volatility
colorMap = lines(5);
colorIdx = [1 2 3 4 5];

figure(2);clf;

subplot(1,2,1);
hold on;grid on;box on;

for i=1:nOptions/2
     plot(volatilityValues_(:,i), '-.', 'LineWidth', 1.5, 'Color', colorMap(colorIdx(i),:));
    plot(impliedVolatilityValues_(:,i), 'LineWidth', 2, 'Color', colorMap(colorIdx(i),:));
end

title('Historical vs. Implied Volatility', 'FontSize', 14);
xlabel('Implied Volatility', 'FontSize', 14);
ylabel('Historical (Realised) Volatility', 'FontSize', 14);
plotLegend = legend('Call 1',  'Call 1','Call 2', 'Call 2', 'Call 3','Call 4' ,'Call 4', 'Call 5','Call 5', 'Location', 'nw');
set(plotLegend, 'FontSize', 10);

subplot(1,2,2);
hold on;grid on;box on;

for i=1+(nOptions/2):nOptions
    plot(volatilityValues_(:,i), '-.', 'LineWidth', 1.5, 'Color', colorMap(colorIdx(i-(nOptions/2)),:));
    plot(impliedVolatilityValues_(:,i), 'LineWidth', 2, 'Color', colorMap(colorIdx(i-(nOptions/2)),:));
end

title('Historical vs. Implied Volatility', 'FontSize', 14);
xlabel('Days', 'FontSize', 14);
ylabel('Volatility', 'FontSize', 14);
plotLegend = legend('Put 1', 'Put 1','Put 2','Put 2', 'Put 3','Put 3', 'Put 4','Put 4', 'Put 5','Put 5', 'Location', 'nw');
set(plotLegend, 'FontSize', 10);

%% volatility smile
colorMap = lines(30);
daysIdx = [ 1 5 6 7 8 9 10];
colorIdx = [1 2 3 4 5 7 8 9 10 11 12 13 14 15 16 17 18];
legendDates = cell(length(daysIdx),1);
plots = zeros(length(daysIdx),1);
for i=1:length(daysIdx)
    legendDates{i} = datestr(dates_(testIdx(i)),'dd/mmm');
end

figure(3); clf;

subplot(1, 2, 1);
hold on;grid on;box on;

for i=1:length(daysIdx)
    plot(strikePrices(1:nOptions/2), impliedVolatilityValues(daysIdx(i),1:nOptions/2), '-', 'Color', colorMap(colorIdx(i),:));
    plots(i) = plot(strikePrices(1:nOptions/2), impliedVolatilityValues(daysIdx(i),1:nOptions/2), '.', 'MarkerSize', 30, 'Color', colorMap(colorIdx(i),:));    
end

title(' Call Option Volatility Smile', 'FontSize', 14);
xlabel('Strike/Asset', 'FontSize', 14);
ylabel('Implied Volatility', 'FontSize', 14);
plotLegend = legend(plots, legendDates, 'Location', 'se');
set(plotLegend, 'FontSize', 10);

subplot(1, 2, 2);
hold on;grid on;box on;

for i=1:length(daysIdx)
    plot(strikePrices(1+(nOptions/2):nOptions), impliedVolatilityValues(daysIdx(i),1+(nOptions/2):nOptions), '-', 'Color', colorMap(colorIdx(i),:));
    plots(i) = plot(strikePrices(1+(nOptions/2):nOptions), impliedVolatilityValues(daysIdx(i),1+(nOptions/2):nOptions), '.', 'MarkerSize', 30, 'Color', colorMap(colorIdx(i),:));
end

title('Put Option Volatility Smile', 'FontSize', 14);
xlabel('Strike/Asset', 'FontSize', 14);
ylabel('Implied Volatility', 'FontSize', 14);
plotLegend = legend(plots, legendDates, 'Location', 'se');
set(plotLegend, 'FontSize', 10);






