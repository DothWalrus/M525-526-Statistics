%% (i)
m = [1;2;3];
S = [1 1/2 0
    1/2 1 0
    0 0 1];
N = 1000000;
L = chol(S,"lower");
w = repmat(m,[1,N]) + L*randn([3,N]);
disp(size(w))

figure('Name','Normal_3')
plotmatrix(w')
title('Plotmatrix of Generated 3D Data')

%% (iii)
v = vecnorm(w);
chi = sum(logical(v(v<1)));
I = 1/N*(chi)
