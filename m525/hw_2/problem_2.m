clear all;
%% (iii)
load("geo_beta.mat");
N = length(w);
a = 1;
b = 1;
pi_param = 0:0.01:1;

prior_dist_fun = @(x) x.^(a-1).*(1-x).^(b-1)./(beta(a,b));
post_didt_fun = @(x) x.^(N+a-1).*(1-x).^(sum(w)+b-1)./(beta(N+a, sum(w)+b-1));

figure('Name','Prior vs Posterior');
plot(pi_param, prior_dist_fun(pi_param)); hold on;
plot(pi_param, post_didt_fun(pi_param));
xlabel('\pi');
ylabel('density');
title('Prior vs Posterior');
legend('prior', 'posterior');

%% (iv)
integral(prior_dist_fun, 0.15, 1)
integral(post_didt_fun, 0.15, 1)

%% (v)

sum(w)