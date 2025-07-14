clear all;
%% (iii)
load("normal_normal.mat");
N = length(w);
v = 1;
M = 0;
V = 10;
mu = -10:0.01:10;
prior_dist = normpdf(mu, M, sqrt(V));

post_mean = (M*v + V*sum(w))/(v + V*N)
post_var = (v*V)/(v + V*N);
post_dist = normpdf(mu, post_mean, sqrt(post_var));

figure('Name','Prior vs Posterior');
plot(mu,prior_dist); hold on
plot(mu,post_dist);
xlabel('\mu');
ylabel('density');
title('Prior vs Posterior');
legend('prior', 'posterior');

%% (iv)
prior_dist_fun = @(x) normpdf(x,M,sqrt(V));
post_dist_fun = @(x) normpdf(x,post_mean,sqrt(post_var));

p_prior_is_neg = integral(prior_dist_fun, -inf, 0)
p_post_is_neg = integral(post_dist_fun, -inf, 0)
