data_dir = '/home/shakibbinhamid/Documents/comp fin/lab 1 2015/data/';
ftse = csvread(strcat(data_dir, '^FTSE.csv'), 1, 6);

stocks(:, 1) = csvread(strcat(data_dir, 'AAL.L.csv'), 1, 6);
% stocks(:, 2) = csvread(strcat(data_dir, 'ABF.L.csv'), 1, 6);
stocks(:, 3) = csvread(strcat(data_dir, 'ADM.L.csv'), 1, 6);
% stocks(:, 4) = csvread(strcat(data_dir, 'ADN.L.csv'), 1, 6);
stocks(:, 5) = csvread(strcat(data_dir, 'AGK.L.csv'), 1, 6);
% stocks(:, 6) = csvread(strcat(data_dir, 'AHT.L.csv'), 1, 6);
% stocks(:, 7) = csvread(strcat(data_dir, 'ANTO.L.csv'), 1, 6);
% stocks(:, 8) = csvread(strcat(data_dir, 'ARM.L.csv'), 1, 6);
% stocks(:, 9) = csvread(strcat(data_dir, 'AV.L.csv'), 1, 6);
 stocks(:,10) = csvread(strcat(data_dir, 'AZN.L.csv'), 1, 6);
% stocks(:,11) = csvread(strcat(data_dir, 'BA.L.csv'), 1, 6);
% stocks(:,12) = csvread(strcat(data_dir, 'BAB.L.csv'), 1, 6);
% stocks(:,13) = csvread(strcat(data_dir, 'BARC.L.csv'), 1, 6);
% stocks(:,14) = csvread(strcat(data_dir, 'BATS.L.csv'), 1, 6);
% stocks(:,15) = csvread(strcat(data_dir, 'BDEV.L.csv'), 1, 6);
% stocks(:,16) = csvread(strcat(data_dir, 'BG.L.csv'), 1, 6);
% stocks(:,17) = csvread(strcat(data_dir, 'BLND.L.csv'), 1, 6);
% stocks(:,18) = csvread(strcat(data_dir, 'BLT.L.csv'), 1, 6);
% stocks(:,19) = csvread(strcat(data_dir, 'BNZL.L.csv'), 1, 6);
% stocks(:,20) = csvread(strcat(data_dir, 'BP.L.csv'), 1, 6);
% stocks(:,21) = csvread(strcat(data_dir, 'BRBY.L.csv'), 1, 6);
% stocks(:,22) = csvread(strcat(data_dir, 'BT-A.L.csv'), 1, 6);
% stocks(:,23) = csvread(strcat(data_dir, 'CCL.L.csv'), 1, 6);
% stocks(:,24) = csvread(strcat(data_dir, 'CNA.L.csv'), 1, 6);
% stocks(:,25) = csvread(strcat(data_dir, 'CPG.L.csv'), 1, 6);
% stocks(:,26) = csvread(strcat(data_dir, 'CPI.L.csv'), 1, 6);
% stocks(:,27) = csvread(strcat(data_dir, 'CRH.L.csv'), 1, 6);
% stocks(:,28) = csvread(strcat(data_dir, 'DC.L.csv'), 1, 6);
% stocks(:,29) = csvread(strcat(data_dir, 'DGE.L.csv'), 1, 6);
% stocks(:,30) = csvread(strcat(data_dir, 'EXPN.L.csv'), 1, 6);

y = tick2ret(ftse);
R = tick2ret(stocks);

[T, N] = size(R);
