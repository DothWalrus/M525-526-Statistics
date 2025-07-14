u = rand(1,10)
u_cond = u < 10 & u >=0
edges = [0, 0.2, 0.4, 0.6, 0.8, 1];
discretize(u,edges)
names = ['1','2'];
disp(names(2));