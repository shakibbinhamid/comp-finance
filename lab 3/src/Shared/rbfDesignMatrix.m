function [Phi, gmm] = rbfDesignMatrix(data, k)

n = size(data,1);

%% fit gaussian mixture model with k centres ------------------------------
gmm = fitgmdist(data, k);

%% build the design matrix Phi --------------------------------------------
Phi = zeros(n, k + 3);
Phi(:, k+1:k+2) = data;
Phi(:, k+3) = ones(n,1);
for i=1:n
    for j=1:k
        val = data(i,:) - gmm.mu(j,:);
        gmm_sig = gmm.Sigma(:,:,j);
        Phi(i,j) = val*gmm_sig*val'; % mahalanobis distance
    end
end

end