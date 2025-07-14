clear all;
%% (4)
load("cluster_data.mat");
N = length(xn);
M = 3;
%scatter(xn,yn);
Rx = [-3, 3, 7];
Ry = [3, 0, 6];
Cx = 1;
Cy = 1;
A = 2;
B = .5;
alpha = 1;
beta = [1/3, 1/3, 1/3];
J = 10;
%%
pi = zeros(3,J);
pi(:,1) = [1/3; 1/3; 1/3];

tau = zeros(1,J);
tau(1) = gamrnd(A,B);

sn = zeros(N,J);
sn(:,1) = ones(N,1);

X_sigma = zeros(M,J);
X_sigma(:,1) = Rx;

Y_sigma = zeros(M,J);
Y_sigma(:,1) = Ry;

X_s = zeros(N,J);
Y_s = zeros(N,J);


A_p = A+N;


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
            h(m) = normpdf(xn(n), X_sigma(m,j-1), sqrt(1/tau(j-1))) * normpdf(yn(n), Y_sigma(m,j-1), sqrt(1/tau(j-1))) * pi(m,j);
            %m
        end
        h = h/sum(h);
        sn(n,j) = generate_categorical(h);
        %n
    end


    for m = 1:M % generate X_sigma and Y_sigma
        Vx = Cx/(1+tau(j-1)*Cx*(sum(sn(:,j)==m)));
        Vy = Cy/(1+tau(j-1)*Cy*(sum(sn(:,j)==m)));
        Mx = (Cx*tau(j-1)*sum(xn(find(sn(:,j) == m)))+Rx(m))/(Cx*tau(j-1)*(sum(sn(:,j)==m))+1) ;
        My = (Cy*tau(j-1)*sum(yn(find(sn(:,j) == m)))+Ry(m))/(Cy*tau(j-1)*(sum(sn(:,j)==m))+1) ;
        %Mx = (Cx*sum(xn(find(sn(:,j) == m)))+Rx(m)/tau(j-1))/(1/tau(j-1)+Cx*N);
        %My = (Cy*sum(yn(find(sn(:,j) == m)))+Ry(m)/tau(j-1))/(1/tau(j-1)+Cy*N);

        X_sigma(m,j) = normrnd(Mx,sqrt(Vx));
        Y_sigma(m,j) = normrnd(My,sqrt(Vy));
        %m
    end
    
    for n = 1:N % generate tau
        for m = 1:M
            if sn(n,j) == m
                X_s(n,j) = X_sigma(m,j);
                Y_s(n,j) = Y_sigma(m,j);
            end
            %m
        end
        %n
    end
        %size(xn-X_s(:,j))
        %sum((xn - X_s(:,j)).^2)
        B_p = 1/2 * sum((xn - X_s(:,j)).^2+(yn - Y_s(:,j)).^2) + 1/B;
        tau(j) = gamrnd(A_p, 1/B_p);
    %j
end
%%
figure("Name","Posterior Samples of (X_\sigma,Y_\sigma)");
scatter(xn,yn,1,'filled'); hold on;
scatter(X_sigma(1,:),Y_sigma(1,:)); hold on;
scatter(X_sigma(2,:),Y_sigma(2,:)); hold on;
scatter(X_sigma(3,:),Y_sigma(3,:)); hold on;
plot(xn(11),yn(11), 'r*'); hold on;
plot(xn(982),yn(982), 'g*'); hold off;

legend('data', '(X_{\sigma_1},Y_{\sigma_1})', '(X_{\sigma_2},Y_{\sigma_2})', '(X_{\sigma_3},Y_{\sigma_3})', 'w(11)','w(982)')

title('Posterior Samples of (X_{\sigma_m},Y_{\sigma_m})')
%%
yes = sn(11,:) == sn(982,:);
p_equal = sum(yes)/J;
%%
%plot(1:J,sn(11,:))

function m = generate_categorical(p)
    P = cumsum(p);
    m = find(rand(1) < P/P(end), 1);
end
