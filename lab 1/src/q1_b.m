clc; clearvars;

%% given ------------------------------------------------------------------

mean_3assets = [0.1; 0.2; 0.15];
covariance_3assets = [0.005, -0.010, 0.004; -0.010 0.040 -0.002; 0.004, -0.002, 0.023];
N = 100;

%% generate the 2 combinations of mean and cov and eff portfolio ----------

nAssets = size(mean_3assets, 1);

eff_2_Risks = zeros(N, nAssets);
eff_2_Returns = zeros(N, nAssets);
eff_2_Weights = zeros(N, nAssets*(nAssets - 1));

for i=1:3
    
    mean_2assets = mean_3assets;
    covariance_2assets = covariance_3assets;
    
    switch(i)
        case 1
            indexToRemove = 3;
        case 2
            indexToRemove = 1;
        case 3
            indexToRemove = 2;
        otherwise
    end
    
    mean_2assets(indexToRemove) = [];
    covariance_2assets(indexToRemove,:) = [];
    covariance_2assets(:,indexToRemove) = [];
    
    [effRisk, effReturn, effWeight] = naiveMV(mean_2assets, covariance_2assets, N);
    
    eff_2_Risks(:, i) = effRisk;
    eff_2_Returns(:, i) = effReturn;
    eff_2_Weights(:, i:i+size(effWeight, 2) - 1) = effWeight;

%% plot the efficient frontier with random portfolio EV -------------------
    [ risk_2, returns_2 ] = generateRandomPortfolio(N, mean_2assets, covariance_2assets, false);
    figure(i); clf;
    box on;
    grid on;
    hold on;
    plot(effRisk, effReturn, 'Linewidth', 2);
    scatter(risk_2, returns_2, 'rx');

    xlabel('Risk', 'FontSize', 18);
    ylabel('Expected Return', 'FontSize', 18);
    title(sprintf('Efficient Portfolio Frontier for Porfolio %d', i), 'FontSize', 18);
    fig_legend = legend( 'Efficient Frontier', 'Scatter of Random E-V', 'Location', 'southeast');
    set(fig_legend,'FontSize',12);
end

%% generate the total eff portfolio ---------------------------------------

[eff_3_Risk, eff_3_Return, eff_3_Weight] = naiveMV(mean_3assets, covariance_3assets, N);


%% plot the efficient portfolios ------------------------------------------

figure(i+1); clf;
box on;
grid on;
hold on;
plot(eff_3_Risk(:), eff_3_Return(:), '-.', 'LineWidth', 4, 'Color', [0.7 0.7 0.7]);
plot(eff_2_Risks(:,1), eff_2_Returns(:,1), 'r', 'LineWidth', 2);
plot(eff_2_Risks(:,2), eff_2_Returns(:,2), 'b', 'LineWidth', 2);
plot(eff_2_Risks(:,3), eff_2_Returns(:,3), 'LineWidth', 2, 'Color', [0 0.7 0.2]);

xlabel('Risk', 'FontSize', 18);
ylabel('Expected Return', 'FontSize', 18);
title('Efficient Portfolio Frontiers', 'FontSize', 18);
fig_legend = legend( 'Asset 1,2,3', 'Asset 1,2', 'Asset 2,3', 'Asset 1,3', 'Location', 'southeast');
set(fig_legend,'FontSize',12);

%% generate N random returns for the 3 set portfolio ----------------------

N = 600;
returns = mvnrnd(mean_3assets, covariance_3assets, N);

%% plot how the 2 assets are distributed ----------------------------------
figure(i+2); clf;
set(gcf, 'Units', 'Inches', 'Position', [0, 0, 20, 6], 'PaperUnits', 'Inches', 'PaperSize', [7.25, 9.125])

subplot(1,3,1);
plot(returns(:,1), returns(:,2), '.r');
box on;
grid on;
daspect([1 1 1]);
axis([-1,1,-1,1]);
xlabel('Asset 1 Return', 'FontSize', 14);
ylabel('Asset 2 Return', 'FontSize', 14);
title('Portfolio 1 Return Distribution', 'FontSize', 14);

subplot(1,3,2);
plot(returns(:,2), returns(:,3), '.b');
box on;
grid on;
daspect([1 1 1]);
axis([-1,1,-1,1]);
xlabel('Asset 2 Return', 'FontSize', 14);
ylabel('Asset 3 Return', 'FontSize', 14);
title('Portfolio 2 Return Distribution', 'FontSize', 14);

subplot(1,3,3);
plot(returns(:,1), returns(:,3), '.', 'Color', [0 0.7 0.2]);
box on;
grid on;
daspect([1 1 1]);
axis([-1,1,-1,1]);
xlabel('Asset 1 Return', 'FontSize', 14);
ylabel('Asset 3 Return', 'FontSize', 14);
title('Portfolio 3 Return Distribution', 'FontSize', 14);