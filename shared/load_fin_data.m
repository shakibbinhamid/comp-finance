clc;
%% -------------------------------------------------------------
data_dir = '/home/shakibbinhamid/Documents/MATLAB/comp-finance/data/Updated/';

%% -------------------------------------------------------------
returns = [];

ftse = csvread(strcat(data_dir, '^FTSE.csv'), 1, 6);

returns(:, 1) = csvread(strcat(data_dir, 'AAL.L.csv'), 1, 6);
returns(:, 2) = csvread(strcat(data_dir, 'AV.L.csv'), 1, 6);
returns(:,3) = csvread(strcat(data_dir, 'BA.L.csv'), 1, 6);
returns(:,4) = csvread(strcat(data_dir, 'BARC.L.csv'), 1, 6);
returns(:,5) = csvread(strcat(data_dir, 'BLT.L.csv'), 1, 6);
returns(:,6) = csvread(strcat(data_dir, 'BP.L.csv'), 1, 6);
returns(:,7) = csvread(strcat(data_dir, 'BT-A.L.csv'), 1, 6);
returns(:,8) = csvread(strcat(data_dir, 'CNA.L.csv'), 1, 6);
returns(:,9) = csvread(strcat(data_dir, 'GLEN.L.csv'), 1, 6);
returns(:,10) = csvread(strcat(data_dir, 'GSK.L.csv'), 1, 6);
returns(:,11) = csvread(strcat(data_dir, 'HSBA.L.csv'), 1, 6);
returns(:,12) = csvread(strcat(data_dir, 'ITV.L.csv'), 1, 6);
returns(:,13) = csvread(strcat(data_dir, 'KGF.L.csv'), 1, 6);
returns(:,14) = csvread(strcat(data_dir, 'LGEN.L.csv'), 1, 6);
returns(:,15) = csvread(strcat(data_dir, 'LLOY.L.csv'), 1, 6);
returns(:,16) = csvread(strcat(data_dir, 'MKS.L.csv'), 1, 6);
returns(:,17) = csvread(strcat(data_dir, 'MRW.L.csv'), 1, 6);
returns(:,18) = csvread(strcat(data_dir, 'NG.L.csv'), 1, 6);
returns(:,19) = csvread(strcat(data_dir, 'OML.L.csv'), 1, 6);
returns(:,20) = csvread(strcat(data_dir, 'RBS.L.csv'), 1, 6);
returns(:,21) = csvread(strcat(data_dir, 'RDSB.L.csv'), 1, 6);
returns(:,22) = csvread(strcat(data_dir, 'RIO.L.csv'), 1, 6);
returns(:,23) = csvread(strcat(data_dir, 'RR.L.csv'), 1, 6);
returns(:,24) = csvread(strcat(data_dir, 'SBRY.L.csv'), 1, 6);
returns(:,25) = csvread(strcat(data_dir, 'SGE.L.csv'), 1, 6);
returns(:,26) = csvread(strcat(data_dir, 'SKY.L.csv'), 1, 6);
returns(:,27) = csvread(strcat(data_dir, 'STAN.L.csv'), 1, 6);
returns(:,28) = csvread(strcat(data_dir, 'TSCO.L.csv'), 1, 6);
returns(:,29) = csvread(strcat(data_dir, 'TW.L.csv'), 1, 6);
returns(:,30) = csvread(strcat(data_dir, 'VOD.L.csv'), 1, 6);

y = tick2ret(ftse);
R = tick2ret(returns);

[T, N] = size(R);