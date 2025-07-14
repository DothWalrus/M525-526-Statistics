%% (ii)
s = 1/2;
J = 1e4;

banana_fun = @(u,v) exp(-10*(u^2-v).^2-(v-1/4).^4);

x = zeros([1,J]);
y = zeros([1,J]);

x(1) = 1;
y(1) = 0;

for i = 2:J
    x_prop = normrnd(x(i-1),s);
    y_prop = normrnd(y(i-1),s);

    q = normpdf(x_prop,x(i-1),s) * normpdf(y_prop,y(i-1),s);
    alpha = banana_fun(x_prop,y_prop)/banana_fun(x(i-1),y(i-1));

    if q < min(alpha,1)
        x(i) = x_prop;
        y(i) = y_prop;
    else 
        x(i) = x(i-1);
        y(i) = y(i-1);
    end
end

%% (iii)
figure("Name","Banana Distribution");
histogram2(x,y,'DisplayStyle','tile','Normalization','pdf','ShowEmptyBins','on')
title('Banana Distribution')
xlabel('x')
ylabel('y')

%%(iv)
x(x<0 | y<0) = 0;
y(x<=0 | y<0) = 0;
banana_int = 1/J * sum(sqrt(x.^2+y.^2))
