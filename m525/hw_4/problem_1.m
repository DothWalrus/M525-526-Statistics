clear all;
%% (ii)
load("gen_normal.mat");
phi = 2;
M = 0;
psi = 1/2;
T = 1/2;

N = length(w);
J = 25000;

tau_init = 1;

tau = zeros([1,J]);
tau(1) = tau_init;

mu = zeros([1,J]);

mu_mean_cond_fun = @(x) (T*M + x*sum(w))/(T + x*N);
mu_var_cond_fun = @(x) 1/(T + x*N);
tau_beta_fun = @(x) 1/(1/psi + 1/2*sum((x-w).^2));

for i = 1:J
    
    mu(i) = normrnd(mu_mean_cond_fun(tau(i)),sqrt(mu_var_cond_fun(tau(i))));
    if i < J
    tau(i+1) = gamrnd(phi+N/2, tau_beta_fun(mu(i)));
    end
end

%% (iii)
figure("Name","Posterior Samples");
histogram2(mu,tau,'DisplayStyle','tile','Normalization','pdf','ShowEmptyBins','on')
title('Posterior Samples')
xlabel('\mu')
ylabel('\tau')

%% (iv)

mu_expect = 1/J * sum(mu)
tau_expect = 1/J * sum(tau)
