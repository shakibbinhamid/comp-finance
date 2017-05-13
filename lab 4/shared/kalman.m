function [Y, W, e, K, A, Q, P, s_] = kalman(s, o, alpha, R)

N = size(s, 1);
Y = zeros(N - o + 1, o);
W = zeros(N - o + 1, o);
e = zeros(N - o + 1, 1);
K = zeros(N - o + 1, o);

s_ = zeros(N, 1);

A = eye(o); % What would this be?
Q = eye(o) * alpha; % tune this?
P = ones(o); % what would P(0) be?
W(1, :) = ones(1, o) * 1/o; % what would W(0) be?

% n = 1 is the initialisation, so loop from 2
for n = 2:(N - o + 1)
    
    % input
    Y(n,:) = s(n - 1: n + 1);
    
    % prediction
    w_ = A * W(n-1, :)';
    P_ = A * P * A' + Q; 
    s_(n + o - 1) = Y(n,:) * w_;
    
    % error
    e(n) = s(n + o -1) - s_(n + o - 1);
    
    % Kalman gain
    K(n, :) = (P_ * Y(n,:)' ./ (R + Y(n,:)*P_*Y(n,:)'))';
    
    % correction
    W(n,:) = W(n - 1) + K(n,:) * e(n);
    P = (eye(o) - K(n,:)' * Y(n,:)) * P;
end