%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 1: draw theresults we got from Q 1_a, b ,...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;

%% plot PPR pricing and it's error in 3D
figure(8);clf;
nOption = 10;
colormap = lines(10);
colorGray = 'none';
subplot(1,2,1);
plotData = zeros(0, 3);
for i=1:nOption/2
    plotData = [plotData; sxTrain(:,i), ttmTrain, cxTrainPPR(:,i)];
end
hold all;
plot_tri = delaunay(plotData(:,1), plotData(:,2));
plot_fill = trisurf(plot_tri, plotData(:,1), plotData(:,2), plotData(:,3), 'EdgeColor', colorGray, 'FaceColor', 'k');
alpha(plot_fill, 0.25);
plots = zeros(nOption/2, 1);
for i=1:nOption/2
    plots(i) = plot3(sxTrain(:,i), ttmTrain, cxTrainPPR(:,i),'o', 'MarkerFaceColor', colormap(i,:), 'Color', 'none', 'MarkerSize', 6);
end
hold off;
grid on;
xlabel('S/X', 'FontSize', 18);
ylabel('T-t', 'FontSize', 18);
zlabel('$\widehat{C}/X$', 'Interpreter','Latex', 'FontSize', 18);
title('\textsf{PPR Prices $\widehat{C}/X$}', 'Interpreter','Latex', 'FontSize', 18);
plot_legend = legend(plots, {'Option 1', 'Option 2', 'Option 3', 'Option 4', 'Option 5'}, 'Location', 'nw');
set(plot_legend, 'FontSize', 12);
subplot(1,2,2);
plotData = zeros(0, 3);
for i=1:nOption/2
    plotData = [plotData; sxTrain(:,i), ttmTrain, errorTrainPPR(:,i)];
end
hold all;
plot_tri = delaunay(plotData(:,1), plotData(:,2));
plot_fill = trisurf(plot_tri, plotData(:,1), plotData(:,2), plotData(:,3), 'EdgeColor', colorGray, 'FaceColor', 'k');
alpha(plot_fill, 0.25);
plots = zeros(nOption/2, 1);
for i=1:nOption/2
    plots(i) = plot3(sxTrain(:,i), ttmTrain, errorTrainPPR(:,i),'o', 'MarkerFaceColor', colormap(i,:), 'Color', 'none', 'MarkerSize', 6);
end
hold off;
grid on;
xlabel('S/X', 'FontSize', 18);
ylabel('T-t', 'FontSize', 18);
zlabel('$\widehat{C}/X -C/X$', 'Interpreter','Latex', 'FontSize', 18);
title('\textsf{Error $\widehat{C}/X - C/X$}', 'Interpreter','Latex', 'FontSize', 18);
plot_legend = legend(plots, {'Option 1', 'Option 2', 'Option 3', 'Option 4', 'Option 5'}, 'Location', 'ne');
set(plot_legend, 'FontSize', 12);
return;

%% plot SVR pricing and it's error in 3D
% figure(8);clf;
% nOption = 10;
% colormap = lines(10);
% colorGray = 'none';
% subplot(1,2,1);
% plotData = zeros(0, 3);
% for i=1:nOption/2
%     plotData = [plotData; sxTrain(:,i), ttmTrain, cxTrainSVR(:,i)];
% end
% hold all;
% plot_tri = delaunay(plotData(:,1), plotData(:,2));
% plot_fill = trisurf(plot_tri, plotData(:,1), plotData(:,2), plotData(:,3), 'EdgeColor', colorGray, 'FaceColor', 'k');
% alpha(plot_fill, 0.25);
% plots = zeros(nOption/2, 1);
% for i=1:nOption/2
%     plots(i) = plot3(sxTrain(:,i), ttmTrain, cxTrainSVR(:,i),'o', 'MarkerFaceColor', colormap(i,:), 'Color', 'none', 'MarkerSize', 6);
% end
% hold off;
% grid on;
% xlabel('S/X', 'FontSize', 18);
% ylabel('T-t', 'FontSize', 18);
% zlabel('$\widehat{C}/X$', 'Interpreter','Latex', 'FontSize', 18);
% title('\textsf{SVR Prices $\widehat{C}/X$}', 'Interpreter','Latex', 'FontSize', 18);
% plot_legend = legend(plots, {'Option 1', 'Option 2', 'Option 3', 'Option 4', 'Option 5'}, 'Location', 'nw');
% set(plot_legend, 'FontSize', 12);
% subplot(1,2,2);
% plotData = zeros(0, 3);
% for i=1:nOption/2
%     plotData = [plotData; sxTrain(:,i), ttmTrain, errorTrainSVR(:,i)];
% end
% hold all;
% plot_tri = delaunay(plotData(:,1), plotData(:,2));
% plot_fill = trisurf(plot_tri, plotData(:,1), plotData(:,2), plotData(:,3), 'EdgeColor', colorGray, 'FaceColor', 'k');
% alpha(plot_fill, 0.25);
% plots = zeros(nOption/2, 1);
% for i=1:nOption/2
%     plots(i) = plot3(sxTrain(:,i), ttmTrain, errorTrainSVR(:,i),'o', 'MarkerFaceColor', colormap(i,:), 'Color', 'none', 'MarkerSize', 6);
% end
% hold off;
% grid on;
% xlabel('S/X', 'FontSize', 18);
% ylabel('T-t', 'FontSize', 18);
% zlabel('$\widehat{C}/X -C/X$', 'Interpreter','Latex', 'FontSize', 18);
% title('\textsf{Error $\widehat{C}/X - C/X$}', 'Interpreter','Latex', 'FontSize', 18);
% plot_legend = legend(plots, {'Option 1', 'Option 2', 'Option 3', 'Option 4', 'Option 5'}, 'Location', 'ne');
% set(plot_legend, 'FontSize', 12);
% return;



%% plot error rates for all the networks
figure(1); clf;
subplot(1,2,1);
hold on;
grid on;
box on;
boxplot(mean(abs(errorTrain))');
ylim([0 0.03]);
xlabel('RBF', 'FontSize', 14);
ylabel('Absolute Error', 'FontSize', 14);
title('Error (Training Data)', 'FontSize', 14);
subplot(1,2,2);
hold on;
grid on;
box on;
boxplot( mean(abs(errorTest))');
ylim([0 0.03]);
xlabel('RBF', 'FontSize', 14);
ylabel('Absolute Error', 'FontSize', 14);
title('Error (Test Data)', 'FontSize', 14);

colormap = lines(4);
graycolor = 'k';
figure(2);clf;
subplot(1,2,1);
hold on;
grid on;
box on;
plot(mean(abs(errorTrain)), '--.', 'LineWidth', 1, 'Color', graycolor);
plot(mean(abs(errorTrain)), '.', 'MarkerSize', 15, 'Color', colormap(1,:));
plot1 = plot(5, '^', 'LineWidth', 1, 'MarkerFaceColor', colormap(1,:), 'MarkerEdgeColor', 'k', 'MarkerSize', 10);
plot2 = plot(5, '*', 'LineWidth', 2, 'MarkerFaceColor', colormap(2,:), 'MarkerEdgeColor', colormap(2,:), 'MarkerSize', 10);
plot3 = plot(5, 's', 'LineWidth', 1, 'MarkerFaceColor', colormap(3,:), 'MarkerEdgeColor', 'k', 'MarkerSize', 10);
plot4 = plot(5, 'o', 'LineWidth', 1, 'MarkerFaceColor', colormap(4,:), 'MarkerEdgeColor', 'k', 'MarkerSize', 10);
ylim([0 0.03]);
xlabel('Call Option', 'FontSize', 14);
ylabel('Absolute Error', 'FontSize', 14);
title('Error (Training Data)', 'FontSize', 14);
fig_legend = legend([plot1, plot2, plot3, plot4], {'RBF', 'MLP', 'PPR', 'SVR'}, 'Location', 'northwest');
set(fig_legend,'FontSize',12);
subplot(1,2,2);
hold on;
grid on;
box on;
plot(mean(abs(errorTest)), '--.', 'LineWidth', 1, 'Color', graycolor);
plot(mean(abs(errorTest)), '^', 'LineWidth', 1, 'MarkerFaceColor', colormap(1,:), 'MarkerEdgeColor', 'k', 'MarkerSize', 10);
ylim([0 0.03]);
xlabel('Call Option', 'FontSize', 14);
ylabel('Absolute Error', 'FontSize', 14);
title('Error (Test Data)', 'FontSize', 14);










