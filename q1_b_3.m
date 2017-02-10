m = [ 0.10, 0.2 ]';
C = [
      [  0.005, -0.010 ]
      [ -0.010,  0.040 ]
    ];

N = 1000;

[E, V] = generateRandomPortfolio(N, m, C);

p = Portfolio;
p = setAssetMoments(p, m, C);
p = setDefaultConstraints(p);

plotFrontier(p, N);

title('E-V plot and efficient frontier of three-asset model');
hold on;
scatter(V, E, 'b.');