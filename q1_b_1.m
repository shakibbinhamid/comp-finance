m = [ 0.20, 0.15 ]';
C = [
      [  0.040, -0.002 ]
      [ -0.002,  0.023 ]
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