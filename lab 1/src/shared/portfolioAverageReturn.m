% calcuate average of all the returns of the assets
% portfolio return of T * nAssets

function [ averageReturn, returns ] = portfolioAverageReturn( portfolioReturn )

returns = mean(portfolioReturn, 2)';

averageReturn = mean(returns);

end
