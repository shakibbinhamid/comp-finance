
function [ weights, assetIdx ] = calculateKSparseIndex( returns, index, k, tau )

[ w ] = calculateSparseIndex(returns, index, tau);

% sort the weights
[weights, assetIdx] = sort(w, 'descend');

% select the top k weights
weights = weights(1:k);
assetIdx = assetIdx(1:k);

end