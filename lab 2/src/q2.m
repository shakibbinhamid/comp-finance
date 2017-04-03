clc;

%% load data --------------------------------------
load('/home/shakib/Documents/MATLAB/comp-finance/lab 2/Data/prices');
load('/home/shakib/Documents/MATLAB/comp-finance/lab 2/Data/dates');
load('/home/shakib/Documents/MATLAB/comp-finance/lab 2/Data/stock');

% interest rate is fixed
interestRate = 6/100;

% strike prices
strikePrices = [2925, 3025, 3125, 3225, 3325, ...
                        2925, 3025, 3125, 3225, 3325];

%% divide into training and validation data

% neglect the last week as the timeToExpire (in years) becomes to small
% and the calcuations of volatility gives errors
neglectedDays = 0; % 10

% data is divided to training and testing
T = size(stock, 1);
nOptions = length(strikePrices);
nTrain = floor(T/4);
nTest = T-nTrain - neglectedDays;

actualValidationPrices = prices(nTrain+1: nTrain+nTest,:);
timeValues = dates(nTrain+1: nTrain+nTest);

% list of estimated prices of put and call options
estimatedValidationPrices = zeros(nTest, nOptions);

volatilityValues = zeros(nTest,nOptions);
sigmaValues = zeros(nTest,nOptions);
vegaValues = zeros(nTest,nOptions);
gammaValues = zeros(nTest,nOptions);
deltaValues = zeros(nTest,nOptions);

for i=1:nTest
    idx = nTrain +i;
    
    stockPrice = stock(idx);
    
    for j=1:nOptions
        
        optionPrice = prices(idx,j);
        strikePrice = strikePrices(j);
        maturityTime = (dates(T,j)+1 - dates(idx,j))/365;
        
        % calculate volatility from training data
        sigma = calcVolatility(prices(i:nTrain+i-1, j));
        
        % get some parameters of the model
        sigmaValues(i,j) = sigma;
        vegaValues(i,j) = blsvega(stockPrice, strikePrice, interestRate, maturityTime, sigma);
        gammaValues(i,j) = blsgamma(stockPrice, strikePrice, interestRate, maturityTime, sigma);
        deltaValues(i,j) = blsdelta(stockPrice, strikePrice, interestRate, maturityTime, sigma);
        
        % apply the model to get the option price        
        [pCall, pPut] = blsprice(stockPrice, strikePrice, interestRate, maturityTime, sigma);
        if (j <= 5)
            estimatedValidationPrices(i,j) = pCall;
        else
            estimatedValidationPrices(i,j) = pPut;
        end
    end
end

errors = abs(actualValidationPrices - estimatedValidationPrices);

%% plot the estimated option prices -----

figure(1);clf;

subplot(1, 2, 1);
hold on;
grid on;
box on;
axis tight;
for i=1:nOptions/2
    plot(timeValues, estimatedValidationPrices(:,i), 'b');
    plot(timeValues, actualValidationPrices(:,i), 'r');
end
title('BLS Estmations for Call Prices', 'FontSize', 14);
xlabel('Date (dd/mm)', 'FontSize', 14);
ylabel('Call Option Price', 'FontSize', 14);
plot_legend = legend ('Estimated', 'Actual');
set(plot_legend, 'FontSize', 14);
datetick('x','dd/mm','keeplimits');

subplot(1, 2, 2);
hold on;
grid on;
box on;
axis tight;
for i=1+(nOptions/2):nOptions
    plot(timeValues, estimatedValidationPrices(:,i), 'b');
    plot(timeValues, actualValidationPrices(:,i), 'r');
end
title('BLS Estmations for Put Prices', 'FontSize', 14);
xlabel('Date (dd/mm)', 'FontSize', 14);
ylabel('Put Option Price', 'FontSize', 14);
plot_legend = legend ('Estimated', 'Actual');
set(plot_legend, 'FontSize', 14);
datetick('x','dd/mm','keeplimits');

%% plot the absolute error between actual and estimated price
colorMaps = lines(10);

figure(2);clf;
subplot(1, 2, 1);
hold on;grid on;box on;axis tight;

for i=1:nOptions/2
    plot(timeValues, errors(:,i), 'Color', colorMaps(i,:));
end

title('Call Pricing Absolute Errors', 'FontSize', 14);
xlabel('Date (dd/mm)', 'FontSize', 14);
ylabel('Call Price Abs Error', 'FontSize', 14);
datetick('x','dd/mm','keeplimits');

subplot(1, 2, 2);
hold on;grid on;box on;axis tight;

for i=1+(nOptions/2):nOptions
    plot(timeValues, errors(:,i), 'Color', colorMaps(i-(nOptions/2),:));
end

title('Put Pricing Absolute Errors', 'FontSize', 14);
xlabel('Date (dd/mm)', 'FontSize', 14);
ylabel('Put Price Abs Error', 'FontSize', 14);
datetick('x','dd/mm','keeplimits');

%% box-plot of abs error ----------------------
figure(3);clf;

subplot(1, 2, 1);
hold on;grid on;box on;axis tight;

boxplot(errors(:,1:nOptions/2));

title('Call Option Pricing Absolute Errors', 'FontSize', 14);
xlabel('Call Options', 'FontSize', 16);
ylabel('Absolute Error', 'FontSize', 16);

subplot(1, 2, 2);
hold on;grid on;box on;axis tight;

boxplot(errors(:,1+(nOptions/2):nOptions));

title('Put Option Pricing Absolute Errors', 'FontSize', 14);
xlabel('Put Options', 'FontSize', 16);
ylabel('Absolute Error', 'FontSize', 16);

%% plot model parameters ------------------
colorMap = lines(5);

figure(4);clf;

subplot(4,1,1);
hold on;grid on;box on;axis tight;

plot(timeValues, sigmaValues, 'Color', colorMap(1,:), 'LineWidth', 0.5);

title('\sigma: Volatility', 'FontSize', 14);
ylabel('Value', 'FontSize', 14);
datetick('x','dd/mm','keeplimits');

subplot(4,1,2);
hold on;grid on;box on;axis tight;

plot(timeValues, vegaValues, 'Color', colorMap(2,:), 'LineWidth', 0.5);

title('\nu: Sensitivity to Underlying Price Volatility', 'FontSize', 14);
ylabel('Value', 'FontSize', 14);
datetick('x','dd/mm','keeplimits');

subplot(4,1,3);
hold on;grid on;box on;axis tight;

plot(timeValues, deltaValues, 'Color', colorMap(4,:), 'LineWidth', 0.5);

title('\Delta: Sensitivity to Underlying Price Change', 'FontSize', 14);
ylabel('Value', 'FontSize', 14);
datetick('x','dd/mm','keeplimits');

subplot(4,1,4);hold on;grid on;box on;axis tight;

plot(timeValues, gammaValues, 'Color', colorMap(5,:), 'LineWidth', 0.5);

title('\Gamma: Sensitivity to Underlying Delta Change', 'FontSize', 14);
xlabel('Date (dd/mm)', 'FontSize', 14);
ylabel('Value', 'FontSize', 14);
datetick('x','dd/mm','keeplimits');