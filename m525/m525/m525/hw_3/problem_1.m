%% (i)
phi = 2;
psi = 2.5;
n = 1;
N = 10000;
m = 10;

tau = gamrnd(phi, psi, [1,N]);
size(tau)
mu = normrnd(m*ones([1,N]), sqrt(n./tau), [1,N]);
w = normrnd(mu, sqrt(1./tau), [1,N]);

c = 1/(sqrt(2*pi*(n+1))) * 1/(gamma(phi)*psi^phi) * gamma(phi+1/2);
y = -0:0.1:25;
pw = @(x) c * ((2*psi*(n+1))./(2*(n+1)+psi*(m-x).^2)).^(phi+1/2);

figure('Name', 'Ancestral Sampling Monte Carlo');
h = histogram(w, 'Normalization','pdf');
xlabel('w')
ylabel('Relative Frequency')
title('Ansestral Sampling'); hold on;
plot(y,pw(y))
legend('Ancesrtal Sampling', 'p(w)')
