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
    phiTrain = rbfDesignMatrix([sxTrain(:,i) ttmTrain], gmm_k);
    phiTest = rbfDesignMatrix([sxTest(:,i) ttmTest], gmm_k);
    
    % ill-conditioned matrix phiX. Use Moore-Penrose pseudoinverse
    %lambda = phiTrain \ cxTrainBS(:,i);
    lambda = pinv(phiTrain, 0.1) * cxTrain(:,i);
    
    % do the prediction of the RBF
    cxTrainRBF =  [cxTrainRBF, phiTrain * lambda];
    cxTestRBF = [cxTestRBF, phiTest * lambda];
    
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
    
%     figure(i);clf;
%     hold on;
%     grid on;
%     box on;
%     plot(ttmTrain, cxTrain(:,i), 'k');
%     plot(ttmTrain, cxTrainBS(:,i), 'r');
%     plot(ttmTrain, cxTrainRBF, 'b');
%     %axis([0, 0.7, -0.04, 0.04]);
%     %plot(ttmTrain, errorTrainRBF(:,i), 'b');
%     %plot(ttmTrain, errorTrain(:,i), 'r');
%     %plot(ttmTrain, cxTrainRBF(:,i), 'r');
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






