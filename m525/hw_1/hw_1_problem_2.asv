%% Simulate data

clear all
M = 7; % Number of sigmas
[pi, sigma_edges] = stat_gen(M);

name_indx = ['1', '2', '3', '4'];
name = 'categorized_data_pi';
i = 1;

for N = [10 100 1000 10000]
    u = rand(1,N); %
    Y = discretize(u, sigma_edges); % Assign each random draw to a category
    mat_name = strcat(name,name_indx(i));
    save(mat_name,'Y', 'pi', '-mat');
    figure;
    h = histogram(Y);
    h.Normalization = 'probability';
    xlabel('\sigma_i')
    ylabel('Relative Frequency')
    title('Simulated Categorical Data')
    %disp(N)
    i = i+1;
end

%% Generate Data Statistics

function [pi,sigma_edges] = stat_gen(M)
    pi_draw = rand(1,M);
    sum_pi = sum(pi_draw);
    pi = pi_draw ./ sum_pi; % Creates pi for each category
    
    sigma_edges = zeros(1,M+1); % Used to create bins of each interval
    sigma_edges(1) = 0;
    
    for i = 1:M % Create bins
        sigma_edges(i+1) = sum(pi(1:i));
    end
end

