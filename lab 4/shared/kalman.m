function [Y, W, e, K, Q, P, s_] = kalman(s, o, alpha)

N = size(s, 1);
m = ar(s, o);
R = m.NoiseVariance;

Y = zeros(N - o + 1, o);
W = zeros(N, o);
w = (m.a(2:o+1) * -1)';
P = eye(o);
Q = alpha * eye(o);
e = zeros(N, 1);
s_ = zeros(N, 1);

for n = o+1:N
    P = P + Q;
    x = s((n - o):(n - 1));
    Y(n,:) = x;
    s_(n) = w' * x;
    e(n) = s(n) - s_(n);
    K = (P * x) / (R + x' * P * x);
    w = w + K * e(n);
    W(n, :) = w;
    P = (eye(o) - K * x') * P;
end
