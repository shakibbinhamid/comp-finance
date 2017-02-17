% select n assets from the given returns and tune their weights 
% to form an n-asset portfolio that best mimics the index
function [ weights, assetIdx ] = sparseIndexTracking( returns, index, k, taw )

nAssets = size(returns, 2);

% taw for the penalty of the regularization
% taw = 0.42;

% it is a minimization problem, so use cvx to do it
cvx_begin quiet
   variable w(nAssets,1)
   minimize(norm(index - (returns * w), 2) + taw * norm(w, 1))
   subject to
    w' * ones(nAssets, 1) == 1;
    w >= 0;
cvx_end

% sort the weights
[weights, assetIdx] = sort(w, 'descend');

% select the top k weights
weights = weights(1:k);
assetIdx = assetIdx(1:k);

end