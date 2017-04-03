
function [ w ] = calculateSparseIndex( returns, index, tau )

nAssets = size(returns, 2);

cvx_begin quiet
   variable w(nAssets,1)
   minimize(norm(index - (returns * w), 2) + tau * norm(w, 1))
   subject to
    w' * ones(nAssets, 1) == 1;
    w >= 0;
cvx_end

end