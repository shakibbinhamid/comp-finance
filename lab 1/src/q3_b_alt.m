load_fin_data;

taus = linspace(0, 0.5, 100)';
iter = size(taus, 1);
se = zeros(iter, 1);
ws = zeros(size(R, 2), iter);

for i = 1:iter
    [ w ] = calculateSparseIndex(R, y, taus(i));
    se(i) = norm(y - R * w) ^ 2;
    ws(:,i) = w;
end

[ ~, idx ] = min(se);
tau = taus(idx);
disp('this tau gives the smallest error from index and tracked index');
disp(tau);
    
[ w ] = calculateSparseIndex(R, y, tau);
trackedIndex = returns * w;

figure(1); clf;

subplot(1, 2, 1);
bar(w);
title(sprintf('L1-Regularization Index-tracking Portfolio tau = %d', round(tau, 4)));
ylabel('Weight');
xlabel('Asset number');

subplot(1, 2, 2);
[ax, p1, p2] = plotyy(1:size(ftse), ftse, 1:size(trackedIndex), trackedIndex);
title('Adjusted close prices against time');
ylabel(ax(1), 'FTSE 100');
ylabel(ax(2), 'Index-tracking portfolio');
xlabel('Time');
set(ax(1), 'YLim', [median(ftse) - range(ftse), median(ftse) + range(ftse)]);
set(ax(2), 'YLim', [median(trackedIndex) - range(trackedIndex), median(trackedIndex) + range(trackedIndex)]);