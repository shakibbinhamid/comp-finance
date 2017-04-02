% ------------- use RBF to simulate BLS -----------------------------------
clc;

%% construct a dataset by generating BLS call option prices ---------------
[sxTrain, sxTest, ttmTrain, ttmTest, cxTrainBS, cxTrain, cxTest, deltas] = bsPricing();

nOption = size(sxTrain,2);
gmm_k = 4;

errorTrainBS = [];
errorTrainRBF = [];
errorTrain = [];
errorTest = [];
errorDelta = [];
cxTrainRBF = [];
cxTestRBF = [];

%% simulate BLS only for the call options ---------------------------------
for i=1:nOption/2
    % construct the desgin matrix
    [phiTrain, gmmTrain] = rbfDesignMatrix([sxTrain(:,i) ttmTrain], gmm_k);
    [phiTest, gmmTest] = rbfDesignMatrix([sxTest(:,i) ttmTest], gmm_k);
    
    %% solve for weights --------------------------------------------------
    % ill-conditioned matrix phiX. Use Moore-Penrose pseudoinverse
    %lambda = phiTrain \ cxTrainBS(:,i);
    lambda = pinv(phiTrain, 0.1) * cxTrain(:,i);
    
    %% RBF prediction -----------------------------------------------------
    cxTrainRBF =  [cxTrainRBF, phiTrain * lambda];
    cxTestRBF = [cxTestRBF, phiTest * lambda];
    
    %% calculate the errors -----------------------------------------------
    errorTrainBS = [errorTrainBS, cxTrainBS(:,i) - cxTrain(:,i)];
    errorTrain = [errorTrain, cxTrainRBF(:,i) - cxTrain(:,i)];
    errorTrainRBF = [errorTrainRBF, cxTrainRBF(:,i) - cxTrainBS(:,i)];
    errorTest = [errorTest, cxTestRBF(:,i) - cxTest(:,i)];
    
    % estimating delta
    phiDelta = rbfDesignMatrix([deltas(:,i) ttmTrain], gmm_k);
    % use tolerance term for pseudo inverse
    %lambdaDelta = phiDelta \ deltas(:,i);
    lambdaDelta = pinv(phiDelta, 0.01) * deltas(:,i);
    deltasEstm =  phiDelta * lambdaDelta;
    errorDelta = [errorDelta, deltasEstm - deltas(:,i)];
end

%% plot errors of training using box plot ---------------------------------
figure(1);clf;
subplot(1,3,1);
hold on;
grid on;
box on;
boxplot(abs(errorTrainBS));
ylim([0 0.032]);
title('|BLS - actual|', 'FontSize', 14);
subplot(1,3,2);
hold on;
grid on;
box on;
boxplot(abs(errorTrain));
ylim([0 0.032]);
title('|RBF - actual|', 'FontSize', 14);
subplot(1,3,3);
hold on;
grid on;
box on;
boxplot(abs(errorTrainRBF));
ylim([0 0.032]);
title('|RBF - BLS|', 'FontSize', 14);

%% plot figure 4 in the paper ---------------------------------------------
plotData = zeros(0, 3);
for i=1:nOption/2
    plotData = [plotData; sxTrain(:,i), ttmTrain, cxTrainBS(:,i)];
end

figure(2); clf; hold all;

colormap = lines(5);

% create the surface with some transparency
plot_tri = delaunay(plotData(:,1), plotData(:,2));
plot_fill = trisurf(plot_tri, plotData(:,1), plotData(:,2), plotData(:,3), 'EdgeColor', 'none', 'FaceColor', 'k');
alpha(plot_fill, 0.25);

% plot the points
plots = zeros(nOption/2, 1);
for i=1:nOption/2
    plots(i) = plot3(sxTrain(:,i), ttmTrain, cxTrainBS(:,i),'o', 'MarkerFaceColor', colormap(i,:), 'Color', 'none', 'MarkerSize', 6);
end

hold off;
grid on;
xlabel('S/X', 'FontSize', 18);
ylabel('T-t', 'FontSize', 18);
zlabel('C/X', 'FontSize', 18);
title('Simulated option prices using Black-Scholes', 'FontSize', 18);
plot_legend = legend(plots, {'Call 1', 'Call 2', 'Call 3', 'Call 4', 'Call 5'}, 'Location', 'nw');
set(plot_legend, 'FontSize', 14);

%% plot RBF pricing and it's error in 3D
figure(3);clf;

colormap = lines(10);
colorGray = [0.4 0.4 0.4];
colorGray = 'none';
subplot(1,2,1);
plotData = zeros(0, 3);
for i=1:nOption/2
    plotData = [plotData; sxTrain(:,i), ttmTrain, cxTrainRBF(:,i)];
end
hold all;
plot_tri = delaunay(plotData(:,1), plotData(:,2));
plot_fill = trisurf(plot_tri, plotData(:,1), plotData(:,2), plotData(:,3), 'EdgeColor', colorGray, 'FaceColor', 'k');
alpha(plot_fill, 0.25);
plots = zeros(nOption/2, 1);
for i=1:nOption/2
    plots(i) = plot3(sxTrain(:,i), ttmTrain, cxTrainRBF(:,i),'o', 'MarkerFaceColor', colormap(i,:), 'Color', 'none', 'MarkerSize', 6);
end
hold off;
grid on;
xlabel('S/X', 'FontSize', 18);
ylabel('T-t', 'FontSize', 18);
zlabel('C/X', 'FontSize', 18);
title('RBF Prices C/X', 'FontSize', 18);
plot_legend = legend(plots, {'Call 1', 'Call 2', 'Call 3', 'Call 4', 'Call 5'}, 'Location', 'nw');
set(plot_legend, 'FontSize', 12);
subplot(1,2,2);
plotData = zeros(0, 3);
for i=1:nOption/2
    plotData = [plotData; sxTrain(:,i), ttmTrain, errorTrainRBF(:,i)];
end
hold all;
plot_tri = delaunay(plotData(:,1), plotData(:,2));
plot_fill = trisurf(plot_tri, plotData(:,1), plotData(:,2), plotData(:,3), 'EdgeColor', colorGray, 'FaceColor', 'k');
alpha(plot_fill, 0.25);
plots = zeros(nOption/2, 1);
for i=1:nOption/2
    plots(i) = plot3(sxTrain(:,i), ttmTrain, errorTrainRBF(:,i),'o', 'MarkerFaceColor', colormap(i,:), 'Color', 'none', 'MarkerSize', 6);
end
hold off;
grid on;
xlabel('S/X', 'FontSize', 18);
ylabel('T-t', 'FontSize', 18);
zlabel('Error C/X', 'FontSize', 18);
title('Error C/X', 'Interpreter','Latex', 'FontSize', 18);
plot_legend = legend(plots, {'Call 1', 'Call 2', 'Call 3', 'Call 4', 'Call 5'}, 'Location', 'ne');
set(plot_legend, 'FontSize', 12);

%% plot delta and it's error in 3D

figure(4);clf;

colormap = lines(10);

subplot(1,2,1);
plotData = zeros(0, 3);
for i=1:nOption/2
    plotData = [plotData; sxTrain(:,i), ttmTrain, deltas(:,i)];
end
hold all;
plot_tri = delaunay(plotData(:,1), plotData(:,2));
plot_fill = trisurf(plot_tri, plotData(:,1), plotData(:,2), plotData(:,3), 'EdgeColor', 'none', 'FaceColor', 'k');
alpha(plot_fill, 0.25);
plots = zeros(nOption/2, 1);
for i=1:nOption/2
    plots(i) = plot3(sxTrain(:,i), ttmTrain, deltas(:,i),'o', 'MarkerFaceColor', colormap(i,:), 'Color', 'none', 'MarkerSize', 6);
end
hold off;
grid on;
xlabel('S/X', 'FontSize', 18);
ylabel('T-t', 'FontSize', 18);
zlabel('\Delta', 'FontSize', 18);
title('Delta Estimates \Delta', 'FontSize', 18);
plot_legend = legend(plots, {'Call 1', 'Call 2', 'Call 3', 'Call 4', 'Call 5'}, 'Location', 'nw');
set(plot_legend, 'FontSize', 12);
subplot(1,2,2);
plotData = zeros(0, 3);
for i=1:nOption/2
    plotData = [plotData; sxTrain(:,i), ttmTrain, errorDelta(:,i)];
end
hold all;
plot_tri = delaunay(plotData(:,1), plotData(:,2));
plot_fill = trisurf(plot_tri, plotData(:,1), plotData(:,2), plotData(:,3), 'EdgeColor', 'none', 'FaceColor', 'k');
alpha(plot_fill, 0.25);
plots = zeros(nOption/2, 1);
for i=1:nOption/2
    plots(i) = plot3(sxTrain(:,i), ttmTrain, errorDelta(:,i),'o', 'MarkerFaceColor', colormap(i,:), 'Color', 'none', 'MarkerSize', 6);
end
hold off;
grid on;
xlabel('S/X', 'FontSize', 18);
ylabel('T-t', 'FontSize', 18);
zlabel('\Delta Error', 'Interpreter','Latex', 'FontSize', 18);
title('Error \Delta', 'FontSize', 18);
plot_legend = legend(plots, {'Call 1', 'Call 2', 'Call 3', 'Call 4', 'Call 5'}, 'Location', 'ne');
set(plot_legend, 'FontSize', 12);
