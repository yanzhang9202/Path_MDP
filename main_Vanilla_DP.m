%% Vanilla DP for Taxi Problem
%  Requirement:
%  Given: T(s'|s, a) and r(s, a, s'), use value iteration to approximate
%  the value function V(s) (a table) for the optimal policy pi(s).
%  By Yan Zhang

%% Generate instances in the workspace
tool_instance_gene;
num_instance = size(instance,2);

%% DP planning, via Value Iteration
%  Input: instance and environment model (specified in env_DP.m);
%  (1) Initialize Value function V(s); 
%  (2) Repeat, until the max innovation of V(s) is below some threshold:
%      For every state s /in S, 
%      estimate V(s) by maximizing the expected V(s) considering all poss-
%      ible actions a /in A(s);
%      improve pi(s) by choosing the optimal action a that maximizes V(s);
%  Output: the value function V(s), optimal policy pi(s).
%          # of backup.

%% Set DP parameters
gamma = 1;
threshold = 1e-0;
max_iter = 1e2;
eva_greedy_policy = 1;
eva_random_policy = 0;

tic;
%% Run test for every instance;
for ii = 1 : 12 %num_instance
    % Initialize value function at the start of instance;
    V_init = zeros(5,5,5,5,2);
    count_backup = 0;
    V_inv = 0;
    V_inv_max = 2*threshold;
    count_iter = 0;
    policy = cell(5,5,5,5,2); 
    
    % Start value iteration with DP;
    V_cur = V_init; V_upd = V_init;
    while ((V_inv_max > threshold) & (count_iter < max_iter))
       V_inv_max = 0;
       count_iter = count_iter + 1;
       % Sweeping the state space at every iteration step;
       for sxt = 0 : 4
           for syt = 0 : 4
               s = [sxt, syt, sxt, syt, 2]; % On board states;
               V_upd_s = zeros(1, 6);
               p = zeros(1, 6);
               % Evaluate random policy, and find greedy choice at
               % each step
               for aa = 1 : 6
                   [V_upd_s(aa), p(aa)] = model_update(s, aa, V_cur, gamma, instance{ii}); 
               end
               % Impove policy by Greedy choice here
               s(1:4) = s(1:4) + 1;
               temp = num2cell(s);
               policy{temp{:}} = find(V_upd_s == max(V_upd_s));
               if (eva_greedy_policy)
                   V_inv = max(V_upd_s) - V_cur(temp{:});
                   V_cur(temp{:}) = max(V_upd_s);
               end
               if (eva_random_policy)
                   V_inv = mean(V_upd_s) - V_cur(temp{:});
                   V_cur(temp{:}) = mean(V_upd_s);
               end
               if (V_inv > V_inv_max)
                   V_inv_max = V_inv;
               end
               count_backup = count_backup + 1;
               for sxp = 0 : 4
                   for syp = 0 : 4
                       s = [sxt, syt, sxp, syp, 1]; % Not on board states;
                       V_upd_s = zeros(1, 6);
                       p = zeros(1, 6);
                       % Evaluate every action in current state;
                       for aa = 1 : 6
                           [V_upd_s(aa), p(aa)] = model_update(s, aa, V_cur, gamma, instance{ii}); 
                       end
                       % Evaluate random policy, and find greedy choice at
                       % each step
                       s(1:4) = s(1:4) + 1;
                       temp = num2cell(s);
                       policy{temp{:}} = find(V_upd_s == max(V_upd_s));
                       temp = num2cell(s);
                       if (eva_greedy_policy)
                           V_inv = max(V_upd_s) - V_cur(temp{:});
                           V_cur(temp{:}) = max(V_upd_s);
                       end
                       if (eva_random_policy)
                           V_inv = mean(V_upd_s) - V_cur(temp{:});
                           V_cur(temp{:}) = mean(V_upd_s);
                       end
                       if (V_inv > V_inv_max)
                           V_inv_max = V_inv;
                       end
                       count_backup = count_backup + 1;
                   end
               end
           end
       end
    end
    
    instance{ii}.V_cur = V_cur;
    instance{ii}.policy = policy;
    instance{ii}.count_backup = count_backup;
    instance{ii}.count_iter = count_iter;
    
    disp(sprintf('Instance %i is finished!...', ii));
end
toc

vanilla = instance;
save('vanilla.mat', 'vanilla');
     




