clc;

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
neglectedDays = 10;

% data is divided to training and testing
n = size(stock, 1);
m = length(strikePrices);
nTrain = int16(n/4);
nTest = n-nTrain - neglectedDays;

% in this question, we need only random 30 days form
% the test data
nSamples = 30;
testIdx = int16(randperm(nTest, nSamples)) + nTrain;
testIdx = sort(testIdx);

voltValues = zeros(nTest,m);
sigmaValues = zeros(nTest,m);

% loop on the test data. for each one, calcuate the volatility
% from train data and estimate the call price and save it
for i=1:nSamples
    
    idxCurrent = testIdx(i);
    
    % current price of the underlying asset
    stockPrice = stock(idxCurrent);
    
    % loop on the 10 options we have (5 call and 5 put)
    for j=1:m
        
        % current price of the option
        optionPrice = prices(idxCurrent,j);
        
        % strike price of the option
        strikePrice = strikePrices(j);
        
        % time untill the expiration of the option (in years)
        expTime = dates(n,j)+1 - dates(idxCurrent,j);
        expTime = expTime/365;
        
        % estimate the volatility based on nTrain historical data
        % note the difference between [blsimpv] and [blkimpv]
        if (j<=5)
            optionType = 1;
            optionClass = {'call'};
        else
            optionType = -1;
            optionClass = {'put'};
        end
        
        % implied volatility
        volt = blsimpv(stockPrice, strikePrice, intRate, expTime, optionPrice, [], [], [], optionClass);
        if (isnan(volt))
             volt = 0;
        end
        voltValues(i,j) = volt;
        
        % volatility, this is different than the implied volatility
        pr = prices(idxCurrent-nTrain:idxCurrent-1, j);
        sigma = calcVolatility(pr);
        sigmaValues(i,j) = sigma;
    end
    
end

% this is to choose the days whose volatilites are not zero
voltValues_ = [];
sigmaValues_ = [];
dates_ = [];
stock_ = [];
for i=1:nSamples
    v = voltValues(i,:);
    if (isempty(v(v==0)))
        voltValues_ = [voltValues_; v];
        sigmaValues_ = [sigmaValues_; sigmaValues(i,:)];
        dates_ = [dates_; dates(i,:)];
        stock_ = [stock_; stock(i)];
    end
end

%% scatter plot historical vs. implied volatility
colorMap = lines(5);
colorIdx = [1 2 3 4 5];
figure(1);clf;
subplot(1,2,1);
hold on;
grid on;
box on;
%axis tight;
%daspect([1,1,1]);
for i=1:m/2
    plot(voltValues_(:,i), sigmaValues_(:,i), '.', 'MarkerSize', 20, 'Color', colorMap(colorIdx(i),:));
end
title('Historical vs. Implied Volatility', 'FontSize', 14);
xlabel('Implied Volatility', 'FontSize', 14);
ylabel('Historical (Realised) Volatility', 'FontSize', 14);
plotLegend = legend('Call 1', 'Call 2', 'Call 3', 'Call 4', 'Call 5', 'Location', 'nw');
set(plotLegend, 'FontSize', 10);
subplot(1,2,2);
hold on;
grid on;
box on;
%axis tight;
%daspect([1,1,1]);
for i=1+(m/2):m
    plot(voltValues_(:,i), sigmaValues_(:,i), '.', 'MarkerSize', 20, 'Color', colorMap(colorIdx(i-(m/2)),:));
end
title('Historical vs. Implied Volatility', 'FontSize', 14);
xlabel('Implied Volatility', 'FontSize', 14);
ylabel('Historical (Realised) Volatility', 'FontSize', 14);
plotLegend = legend('Put 1', 'Put 2', 'Put 3', 'Put 4', 'Put 5', 'Location', 'ne');
set(plotLegend, 'FontSize', 10);

%% plot historical vs. implied volatility
colorMap = lines(5);
colorIdx = [1 2 3 4 5];
figure(2);clf;
subplot(1,2,1);
hold on;
grid on;
box on;
%axis tight;
%daspect([1,1,1]);
for i=1:m/2
    plot(voltValues_(:,i), 'LineWidth', 1, 'Color', 'k');
    plot(sigmaValues_(:,i), 'LineWidth', 2, 'Color', colorMap(colorIdx(i),:));
end
title('Historical vs. Implied Volatility', 'FontSize', 14);
xlabel('Implied Volatility', 'FontSize', 14);
ylabel('Historical (Realised) Volatility', 'FontSize', 14);
plotLegend = legend('Call 1', 'Call 2', 'Call 3', 'Call 4', 'Call 5', 'Location', 'nw');
set(plotLegend, 'FontSize', 10);
subplot(1,2,2);
hold on;
grid on;
box on;
%axis tight;
%daspect([1,1,1]);
for i=1+(m/2):m
    plot(voltValues_(:,i), 'LineWidth', 1, 'Color', 'k');
    plot(sigmaValues_(:,i), 'LineWidth', 2, 'Color', colorMap(colorIdx(i-(m/2)),:));
end
title('Historical vs. Implied Volatility', 'FontSize', 14);
xlabel('Implied Volatility', 'FontSize', 14);
ylabel('Historical (Realised) Volatility', 'FontSize', 14);
plotLegend = legend('Put 1', 'Put 2', 'Put 3', 'Put 4', 'Put 5', 'Location', 'ne');
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
hold on;
grid on;
box on;
for i=1:length(daysIdx)
    plot(strikePrices(1:m/2), voltValues_(daysIdx(i),1:m/2), '-', 'Color', colorMap(colorIdx(i),:));
    plots(i) = plot(strikePrices(1:m/2), voltValues_(daysIdx(i),1:m/2), '.', 'MarkerSize', 30, 'Color', colorMap(colorIdx(i),:));    
end
title('Implied Volatility for Call Options', 'FontSize', 14);
xlabel('Strike/Asset', 'FontSize', 14);
ylabel('Implied Volatility', 'FontSize', 14);
plotLegend = legend(plots, legendDates, 'Location', 'se');
set(plotLegend, 'FontSize', 10);
subplot(1, 2, 2);
hold on;
grid on;
box on;
for i=1:length(daysIdx)
    plot(strikePrices(1+(m/2):m), voltValues(daysIdx(i),1+(m/2):m), '-', 'Color', colorMap(colorIdx(i),:));
    plots(i) = plot(strikePrices(1+(m/2):m), voltValues(daysIdx(i),1+(m/2):m), '.', 'MarkerSize', 30, 'Color', colorMap(colorIdx(i),:));
end
title('Implied Volatility for Put Options', 'FontSize', 14);
xlabel('Strike/Asset', 'FontSize', 14);
ylabel('Implied Volatility', 'FontSize', 14);
plotLegend = legend(plots, legendDates, 'Location', 'se');
set(plotLegend, 'FontSize', 10);






