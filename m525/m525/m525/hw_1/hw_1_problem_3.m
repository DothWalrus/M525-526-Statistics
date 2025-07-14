N = 10000;
u = rand(1,N);
v = rand(1,N);
mu = 0;
sigma = 1;

[x, y] = box_mull(u,v, mu, sigma);

figure('Name','Box-Muller');
subplot(1,2,1)
hx = histogram(x);
hx.Normalization = 'probability';
xlabel('X = x')
ylabel('Relative Frequency')
xlim([-4,4])
ylim([0,0.09])
title('Box-Muller X')

subplot(1,2,2)
hy = histogram(y);
hy.Normalization = 'probability';
xlabel('Y = y')
xlim([-4,4])
ylim([0,0.09])
title('Box-Muller Y')


function[x,y] = box_mull(u, v, mu, sigma)
    x = mu + sigma .* sqrt(-2.*log(u)) .* cos(2*pi.*v);
    y = mu + sigma .* sqrt(-2.*log(u)) .* sin(2*pi.*v);
end