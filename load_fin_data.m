%% -------------------------------------------------------------
data_dir = '/home/shakibbinhamid/Documents/comp fin/lab 1 2015/data/Updated/';

%% -------------------------------------------------------------
ftse = csvread(strcat(data_dir, '^FTSE.csv'), 1, 6);

stocks(:, 1) = csvread(strcat(data_dir, 'AAL.L.csv'), 1, 6);
stocks(:, 2) = csvread(strcat(data_dir, 'AV.L.csv'), 1, 6);
stocks(:,3) = csvread(strcat(data_dir, 'BA.L.csv'), 1, 6);
stocks(:,4) = csvread(strcat(data_dir, 'BARC.L.csv'), 1, 6);
stocks(:,5) = csvread(strcat(data_dir, 'BLT.L.csv'), 1, 6);
stocks(:,6) = csvread(strcat(data_dir, 'BP.L.csv'), 1, 6);
stocks(:,7) = csvread(strcat(data_dir, 'BT-A.L.csv'), 1, 6);
stocks(:,8) = csvread(strcat(data_dir, 'CNA.L.csv'), 1, 6);
stocks(:,9) = csvread(strcat(data_dir, 'GLEN.L.csv'), 1, 6);
stocks(:,10) = csvread(strcat(data_dir, 'GSK.L.csv'), 1, 6);
stocks(:,11) = csvread(strcat(data_dir, 'HSBA.L.csv'), 1, 6);
stocks(:,12) = csvread(strcat(data_dir, 'ITV.L.csv'), 1, 6);
stocks(:,13) = csvread(strcat(data_dir, 'KGF.L.csv'), 1, 6);
stocks(:,14) = csvread(strcat(data_dir, 'LGEN.L.csv'), 1, 6);
stocks(:,15) = csvread(strcat(data_dir, 'LLOY.L.csv'), 1, 6);
stocks(:,16) = csvread(strcat(data_dir, 'MKS.L.csv'), 1, 6);
stocks(:,17) = csvread(strcat(data_dir, 'MRW.L.csv'), 1, 6);
stocks(:,18) = csvread(strcat(data_dir, 'NG.L.csv'), 1, 6);
stocks(:,19) = csvread(strcat(data_dir, 'OML.L.csv'), 1, 6);
stocks(:,20) = csvread(strcat(data_dir, 'RBS.L.csv'), 1, 6);
stocks(:,21) = csvread(strcat(data_dir, 'RDSB.L.csv'), 1, 6);
stocks(:,22) = csvread(strcat(data_dir, 'RIO.L.csv'), 1, 6);
stocks(:,23) = csvread(strcat(data_dir, 'RR.L.csv'), 1, 6);
stocks(:,24) = csvread(strcat(data_dir, 'SBRY.L.csv'), 1, 6);
stocks(:,25) = csvread(strcat(data_dir, 'SGE.L.csv'), 1, 6);
stocks(:,26) = csvread(strcat(data_dir, 'SKY.L.csv'), 1, 6);
stocks(:,27) = csvread(strcat(data_dir, 'STAN.L.csv'), 1, 6);
stocks(:,28) = csvread(strcat(data_dir, 'TSCO.L.csv'), 1, 6);
stocks(:,29) = csvread(strcat(data_dir, 'TW.L.csv'), 1, 6);
stocks(:,30) = csvread(strcat(data_dir, 'VOD.L.csv'), 1, 6);

%% -------------------------------------------------------------

y = tick2ret(ftse);
R = tick2ret(stocks);

[T, N] = size(R);

