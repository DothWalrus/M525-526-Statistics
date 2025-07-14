clear all;
%% Forward Filtering Algorithm
load('corrupted_data.mat');
rho = [1 0 0]';
pi =  [1/2 1/4 1/4
    1/4 1/2 1/4
    1/4 1/4 1/2];
phi = [-1 3 6]';

N = length(w);
M = 3;

G = zeros(M,N);
A = zeros(M,N);
q = zeros(1,N);

G(:,1) = normpdf(w(1), phi, 1);
A(:,1) = G(:,1).*rho;
q(1) = sum(A(:,1));
A(:,1) = A(:,1)/q(1);
%A_hat(:,1);

%%
for n = 2:N
    G(:,n) = normpdf(w(n), phi, 1);
    A(:,n) = pi*A(:,n-1) .* G(:,n);
    q(n) = sum(A(:,n));
    A(:,n) = A(:,n)/q(n);
end
%%
p = sum(log(q))
%%
plot(1:N, w)

%% Viterbi Algorithm Wrong
%[J,K] = find(A == max(A));
%for m=[3 2 1]
%    J(J==m) = phi(m);
%end
%%
J = zeros(1,N);
n = sort(1:N, 'descend');
for j = n
    Q = pi*A(:,j);
    [J(j),K] = find(Q==max(Q));
end
for m=[3 2 1]
    J(J==m) = phi(m);
end


%%
figure('Name','Viterbi Algorithm')
plot(1:N, J, 'b*-', 'LineWidth',1); hold on;
plot(1:N,w);
title('Viterbi Algorithm')