m = [ 0.10, 0.20, 0.15 ]';
C = [0.005, -0.010,  0.004 ;-0.010,  0.040, -0.002 ;0.004, -0.002,  0.023 ];
N = 10;

[PRisk1, PRoR1, PWts1] = naiveMV(m, C, N);
[PRisk2, PRoR2, PWts2] = naiveMV_CVX(m, C, N);
plot(PRisk1, PRoR1);
hold on;
plot(PRisk2, PRoR2, 'b*');
title('Efficient frontier');
xlabel('Risk (Variance)');
ylabel('Expected Return');