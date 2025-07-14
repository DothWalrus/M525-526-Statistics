%% 
clear all;
%% (2) 
x_star = -100:0.1:100;
M = length(x_star);
J = 10000;

lambda = 2;
l = 25;
C_kernel = @(x) lambda^2 * exp(-(x).^2 / (2*l^2));
C_star_star = C_kernel(x_star-x_star');
[U,S,V] = svd(C_star_star);
L = U*sqrt(S);

%syms h_prior_fun(x)
%h_prior_fun(x) = piecewise(abs(x)>40,0, abs(x) <= 40, -10);
h_prior_fun = @(x) -10 + 0*x;
h_star = h_prior_fun(x_star');

f_star = repmat(h_star,[1,J]) + L*randn([M,J]);

%%
figure('Name','Prior')
plot(x_star,f_star);
title('Prior Samples')

%% (3)
% load data and generate test points
load("streambed_data.mat")
x_sharp = x;
N = length(x_sharp);
y_sharp = y;
%x_star_sharp = [x_star x_sharp];

C_sharp_sharp = C_kernel(x_sharp-x_sharp');
C_star_sharp = C_kernel(x_star-x_sharp');

V_sharp_sharp = diag(d);
G_star_sharp = (C_sharp_sharp + V_sharp_sharp)\C_star_sharp;
h_sharp = h_prior_fun(x_sharp);
post_mean = h_star + G_star_sharp' * (y_sharp - h_sharp)';

C_post = C_star_star - G_star_sharp' * C_star_sharp;
[U,S,V] = svd(C_post);
L = U*sqrt(S);

f_post = repmat(post_mean,[1,J]) + L*randn([M,J]);
%%
figure('Name','Posterior')
plot(x_star,f_post);
title('Posterior Samples')

%% (4)
% f^*|y^# ~ Normal_M+N(h^* + (G^*#(y^#-h^#), C^** - G^*#C^#*)
% f^*_A|y^# ~ Normal([h^* + (G^*#(y^#-h^#)]_A, [C^** - G^*#C^#*]_A)
A = find(x_star==-20);
B = find(x_star==-10);
C = find(x_star==0);
D = find(x_star==10);
E = find(x_star==20);

mean_A = post_mean(A);
mean_B = post_mean(B);
mean_C = post_mean(C);
mean_D = post_mean(D);
mean_E = post_mean(E);

sd_A = sqrt(C_post(A,A));
sd_B = sqrt(C_post(B,B));
sd_C = sqrt(C_post(C,C));
sd_D = sqrt(C_post(D,D));
sd_E = sqrt(C_post(E,E));

p_A = 1-normcdf(-10, mean_A, sd_A)
p_B = 1-normcdf(-10, mean_B, sd_B)
p_C = 1-normcdf(-10, mean_C, sd_C)
p_D = 1-normcdf(-10, mean_D, sd_D)
p_E = 1-normcdf(-10, mean_E, sd_E)

p_A*p_B*p_C*p_D*p_E

f_post_x_A = f_post(A,:);
p_A_monte = (J-length(f_post_x_A(f_post_x_A<-10)))/J
f_post_x_B = f_post(B,:);
p_B_monte = (J-length(f_post_x_B(f_post_x_B<-10)))/J
f_post_x_C = f_post(C,:);
p_C_monte = (J-length(f_post_x_C(f_post_x_C<-10)))/J
f_post_x_D = f_post(D,:);
p_D_monte = (J-length(f_post_x_D(f_post_x_D<-10)))/J
f_post_x_E = f_post(E,:);
p_E_monte = (J-length(f_post_x_E(f_post_x_E<-10)))/J

p_A_monte*p_B_monte*p_C_monte*p_D_monte*p_E_monte

