clear all;
load data_2a_v2.mat;

N = length  (w);
theta_param = 0:0.01:10;

psi = 1/(1/B + 1/2*sum(log(w./h).^2));
theta_star = psi*(A + N/2 - 1)

prior_dist_fun = @(x) gampdf(x, A,B);
post_dist_fun = @(x) gampdf(x, A+N/2, psi);

figure('Name','Prior vs Posterior');
plot(theta_param, prior_dist_fun(theta_param)); hold on;
plot(theta_param, post_dist_fun(theta_param));
xlabel('\theta');
ylabel('density');
title('Prior vs Posterior');
legend('prior', 'posterior');
