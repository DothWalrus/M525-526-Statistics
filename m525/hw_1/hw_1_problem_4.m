%% Calibration
clear all;
load('TTTR_calibration.mat')
v = sum(w.^2)/length(w)
%%
load('TTTR_experiment.mat')
w;
N = length(w)

log_like = @(lambda) -1*(N.*log(lambda/2)+(sum(lambda.^2.*v/2-lambda.*w)+ ...
    sum(log(erf((lambda.*v-w)./sqrt(2.*v))-1))));

lambda_hat = fminsearch(log_like,1)

x = 0:0.1:100;

figure('Name', 'Negative Log-Likelihood');
plot(x,log_like(x))
xlabel('\lambda')
ylabel('likelihood')