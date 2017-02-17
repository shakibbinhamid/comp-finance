load_fin_data;

w = zeros(30, 1);
for n = 1:6
    best_norm = Inf;
    best_w = w;
    for i = 1:30
        if best_w(i) > 0
           continue;
        end
        new_w = w;
        new_w(i) = 1;
        new_norm = norm(y - R * new_w) ^ 2;
        if new_norm < best_norm
            best_norm = new_norm;
            best_w = new_w;
        end
    end
    w = best_w;
end

w = w / norm(w, 1);

disp(norm(y - R * w) ^ 2);
y2 = returns * w;
figure(1);
bar(w);
title('Index-tracking portfolio using greedy search algorithm');
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