%% (ii)
m = [-2; 0; 1; -1];
S = [1 4/5 0 0
    4/5 5 -1 0
    0 -1 3 0
    0 0 0 2];
N = 10000;
L = chol(S,"lower");
w = repmat(m,[1,N]) + L*randn([4,N]);
size(w);

%% (iii)
figure('Name','Normal_4')
plotmatrix(w')
title('Plotmatrix of Generated 4D Data')

%% (iv)
elip_fun = @(x,y,z) (x+3).^2/2 + y.^2/2 + z.^2/9;

x_hold = w(1,:);
x = x_hold;
y_hold = w(2,:);
y = y_hold;
z_hold = w(3,:);
z = z_hold;

x(elip_fun(x_hold,y_hold,z_hold) > 1) = 0;
y(elip_fun(x_hold,y_hold,z_hold) > 1) = 0;
z(elip_fun(x_hold,y_hold,z_hold) > 1) = 0;

I = 1/N * sum((x-y).^2)
