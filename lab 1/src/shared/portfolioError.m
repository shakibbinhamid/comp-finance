% calcuate the root-mean-square error between the given
% portfolio and the target
function [ rmse ] = portfolioError( portfolioReturns, targetReturns )

% given portfolio of T*N
% T: opeservations
% N: assets
% required to calcuate the return per observation
% then calcuate the sharpe ratio for these returns

% T = size(portfolioReturns, 1);
% returns = zeros(1, T);
% for i=1:T
%     returns(i) = mean(portfolioReturns(i,:));
% end

returns = mean(portfolioReturns, 2);

rmse = sqrt(mean((returns - targetReturns).^2));

end