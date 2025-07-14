clear all;
%% load data
load("midterm_data_v2.mat");
N = length(wn);
M = 4;
mu_sigma = [1 2 3 4];
A = 2;
B = .5;
alpha = 1;
beta = [1/4, 1/4, 1/4, 1/4];
J = 1000;



%% initialize values for Gibb's Sampling

pi = zeros(M, J);
pi(:,1) = [1/4; 1/4; 1/4; 1/4];

tau = zeros(1,J);
tau(1) = gamrnd(A,B);

sn = zeros(N,J);
sn(:,1) = ones(N,1);

W_s = zeros(N,J);

A_p = A+N;
%B_p =  1/2 * sum((wn - mu_sigma).^2) + 1/B;

%meme = sum((wn - mu_sigma(:,j)).^2);

for j = 2:J
    c = zeros(1,M);
    t = zeros(1,M);
    for m = 1:M % generate pi
        c(m) = sum(sn(:,j-1) == m);
        t(m) = randg(alpha*beta(m)+c(m));
        %m
    end
    pi(:,j) = t/sum(t);

        h = zeros(1,M);
    for n = 1:N % generate sn
        for m = 1:M
            h(m) = normpdf(wn(n), mu_sigma(m), sqrt(1/tau(j-1))) * pi(m,j);
            %m
        end
        h = h/sum(h);
        sn(n,j) = generate_categorical(h);
        %n
    end
    
    %generate tau
    for n = 1:N % generate tau
        for m = 1:M
            if sn(n,j) == m
                W_s(n,j) = mu_sigma(m);
            end
            %m
        end
        %n
    end
        %size(xn-X_s(:,j))
        %sum((xn - X_s(:,j)).^2)
    B_p = 1/2 * sum((wn - W_s(:,j)).^2) + 1/B;    
    tau(j) = gamrnd(A_p, 1/B_p);    
end

%%
yes = sn(15,:) == sn(25,:);
p_equal = sum(yes)/J;
%%
figure("Name","Scatter of Data")
scatter(wn,zeros(1,N), 1, 'filled'); hold on;
plot(wn(15), 0, 'r*')
plot(wn(25), 0, 'g*')
legend('data', 'w_{15}', 'w_{25}')
title('Scatter of Data')
%%
%figure("Name", "Scatter of Labeled Data")
scatter(wn(sn(:,J)==1), zeros(1,sum(sn(:,J)==1)), 1, 'yellow', 'filled'); hold on;
scatter(wn(sn(:,J)==2), zeros(1,sum(sn(:,J)==2)), 1, 'magenta', 'filled');
scatter(wn(sn(:,J)==3), zeros(1,sum(sn(:,J)==3)), 1, 'cyan', 'filled');
scatter(wn(sn(:,J)==4), zeros(1,sum(sn(:,J)==4)), 1, 'red', 'filled');
legend('s_n = \sigma_1', 's_n = \sigma_2', 's_n = \sigma_3', 's_n = \sigma_4')
title('Posterior Sample of Data Labels')

%sum(sn(:,J) == 1)
%length(wn(sn(:,J) == 1))

function m = generate_categorical(p)
    P = cumsum(p);
    m = find(rand(1) < P/P(end), 1);
end
