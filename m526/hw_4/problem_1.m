clear all;
close all;
clc;
%% Load Data
load('pollen_motion.mat')
W = [X Y Z]';

%% Parameters
M = 3;
N = length(X);

sigma = 0.15;
v = 0.0054;
mu = W(:,1);
A = [0 0 0]';
B = eye(M);
phi = [0 0 0]';
psi = eye(M);

mu_bar = zeros(M,N);
v_bar = zeros(M,M,N);
G = zeros(M,M,N);

mu_hat = zeros(M,N);

v_hat = zeros(M,M,N);

Sigma = sigma*eye(M);

lambda = v*eye(M);

%% Inititalize
mu_bar(:,1) = mu;
v_bar(:,:,1) = v*eye(M);

% G(:,1:M) = (Sigma^2 + psi*v_bar(:,1:M)*psi')\(v_bar(:,1:M)*psi');
G(:,:,1) = (v_bar(:,:,1)*psi')/(Sigma^2 + psi*v_bar(:,:,1)*psi');

mu_hat(:,1) = mu_bar(:,1) + G(:,:,1)*(W(:,1)-phi-psi*mu_bar(:,1));
v_hat(:,:,1) = (eye(M)-G(:,:,1)*psi)*v_bar(:,:,1);

%% Filtering

for n = 2:N
    mu_bar(:,n) = A + B*mu_hat(:,n-1);
    v_bar(:,:,n) = B*v_hat(:,:,n-1)*B' + lambda;
%     v_bar(:,(M*(n-1)+1):(M*(n-1)+M))
%     Sigma^2 + psi*v_bar(:,(M*(n-1)+1):(M*(n-1)+M))*psi'
%     v_bar(:,(M*(n-1)+1):(M*(n-1)+M))*psi'
    
%     G(:,(M*(n-1)+1):(M*(n-1)+M)) = (Sigma^2 + psi*v_bar(:,(M*(n-1)+1):(M*(n-1)+M))*psi')\(v_bar(:,(M*(n-1)+1):(M*(n-1)+M))*psi');
    G(:,:,n) = (v_bar(:,:,n)*psi')/(Sigma^2 + psi*v_bar(:,:,n)*psi');
    mu_hat(:,n) = mu_bar(:,n) + G(:,:,n)*(W(:,n)-phi-psi*mu_bar(:,n));
    v_hat(:,:,n) = (eye(M)-G(:,:,n)*psi)*v_bar(:,:,n);

%     r(:,n) = mu_hat(:,n) + sqrt(v_hat(:,(M*(n-1)+1):(M*(n-1)+M)))*randn(M,1);
end

%%
% plot3(r(1,:),r(2,:),r(3,:)); hold on;
% plot3(X,Y,Z, 'o');

figure('Name','Prediction and Correction Filter')
plot3(mu_bar(1,:),mu_bar(2,:),mu_bar(3,:),mu_hat(1,:),mu_hat(2,:),mu_hat(3,:)); hold on;
% plot3(mu_hat(1,:),mu_hat(2,:),mu_hat(3,:),'b-');
% plot3(X,Y,Z, 'k*', 'MarkerSize', 2);



%% Backwards Smoothing
J = zeros(M,M,N);
mu_check = zeros(M,N);
v_check = zeros(M,M,N);

mu_check(:,N) = mu_hat(:,N);
v_check(:,:,N) = v_hat(:,:,N);

K = sort(1:N-1, "descend");
for k = K
   J(:,:,k) = v_hat(:,:,k)*B'/v_bar(:,:,k+1);
   mu_check(:,k) = mu_hat(:,k) + J(:,:,k)*(mu_check(:,k+1) - mu_bar(:,k+1));
   v_check(:,:,k) = v_hat(:,:,k) + J(:,:,k)*(v_check(:,:,k+1)-v_bar(:,:,k+1))*J(:,:,k)';
end

figure('Name','X-axis Prediction, Correction, and Smoothing Filter')
plot(1:N, mu_bar(1,:)); hold on;
plot(1:N, mu_hat(1,:));
plot(1:N, mu_check(1,:));
plot(1:N,X, '*', 'MarkerSize', 1);
legend('$\overline{\mu}$', '$\hat{\mu}$', '$\check{\mu}$', '$X_n$','interpreter', 'latex');
xlabel('n');
ylabel('X_n');
title('X-axis Prediction, Correction, and Smoothing Filter')

% A_hat = zeros([M,N]);

% % Initialize Parameters
% r(:,1) = normrnd(mu,v);
% mu_hat(1,1) = (X(1)/sigma^2 + mu(1)/v)/(1/sigma^2 + 1/v);
% mu_hat(2,1) = (Y(1)/sigma^2 + mu(2)/v)/(1/sigma^2 + 1/v);
% mu_hat(3,1) = (Z(1)/sigma^2 + mu(3)/v)/(1/sigma^2 + 1/v);
% v_hat(1) = 1/(1/sigma^2 + 1/v);
% mean(W,2);
% 
% 
% 
% for n = 2:N
%     r(:,n) = normrnd(mu_hat(:,1),sqrt(v_hat(:,1)));
%     v_hat(n) = 1/(1/sigma^2 + 1/(v_hat(n-1)+v));
%     for m = 1:M
%         mu_hat(m,n) = (W(m,n)/sigma^2 + mu_hat(m,n-1)/(v_hat(n-1) + v))/v_hat(n);
%     end
%     
% end
% %%
% 
% 

%% DO NOT READ SIMULATION TRASH
% Lambda = sqrt(diag([v,v,v])); % transition noise covariance
% Psi = diag([sigma,sigma,sigma]); % measurement noise covariance
% A = ones([3,1]);
% B = eye(3);
% 
% phi = ones([3,1]);
% psi = eye(3);
% 
% F = @(r) A + B*r;
% H = @(r) phi + psi*r;
% 
% r = zeros([M,N]);
% w = zeros([M,N]);
% 
% mu = mean(W,2);
% 
% %% Simulation
% r(:,1) = mu + Lambda*randn([3,1]);
% w(:,1) = H(r(:,1)) + Psi*randn([3,1]);
% 
% for n = 2:N
%     r(:,n) = F(r(:,n-1)) + Lambda*randn([3,1]);
%     w(:,n) = H(r(:,n)) + Psi*randn([3,1]);
% end
