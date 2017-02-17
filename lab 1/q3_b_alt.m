load_fin_data;

tau = 0.42;

cvx_begin quiet
variable w(N)
    minimize(square_pos(norm(y - R * w)) + tau * norm(w, 1));
    subject to
        w' * ones(N, 1) == 1;
        w >= 0;
cvx_end

disp(norm(y - R * w) ^ 2);
y2 = returns * w;
figure(1);
bar(w);
title('Index-tracking portfolio using l1-regularization algorithm');
ylabel('Weight');
xlabel('Asset number');
figure(2);
[ax, p1, p2] = plotyy(1:(T + 1), ftse, 1:(T + 1), y2);
title('Adjusted close prices against time');
ylabel(ax(1), 'FTSE 100');
ylabel(ax(2), 'Index-tracking portfolio');
xlabel('Time');
set(ax(1), 'YLim', [median(ftse) - range(ftse), median(ftse) + range(ftse)]);
set(ax(2), 'YLim', [median(y2) - range(y2), median(y2) + range(y2)]);