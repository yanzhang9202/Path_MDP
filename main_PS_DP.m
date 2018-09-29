%% Prioritized Sweeping DP for Problem 2
%  Requirement:
%  Given: T(s'|s, a) and r(s, a), use Prioritized Sweeping to
%  accelerate Vanilla DP, approximating the value function V(s) (a table) 
%  and the optimal policy pi(s).
%  By Yan Zhang

%% Generate Instances
%  Instance specifies where the taxi is and where the goal is.
tool_instance_gene;
num_instance = size(instance,2);

%% DP planning, accelerated by Prioritized Sweeping
%  Input: instance and environment model (specified in env_DP.m);
%  (1) Initialize (1) Value function V(s); 
%  (2) Setting a prioritized threshould theta;
%  (3) Given a findPred(s) function, find the predecessors of the terminal
%      state {sn}, update their V(s) and optimal pi(s) by vanilla DP rule,
%      and record their Value innovation p(s);
%      if p(s) > theta, insert state s and its p(s) into PQueue, according
%      to their priority p(s);
%  (4) Repeat, until the PQueue is empty, i.e., no innovation of V(s) is
%      larger than theta:
%      Choose state s on the top of PQueue, remove s from PQueue, and call
%      function {s'} = findPred(s);
%      Update V(s') and pi(s'), update p(s'), update PQueue, return to (4).
%   Output: Final V(s), pi(s), # of backup.

%% Set DP parameters
gamma = 1;
pthreshold = 1e-2;
max_iter = 1e2; % This means different thing than Vanilla DP;
eva_greedy_policy = 1;
eva_random_policy = 0;

%% Run test for every instance;
tic;
for ii = 1 : 12
    % Initialize value function at the start of instance;
    V_init = zeros(5,5,5,5,2);
    count_backup = 0;
%     count_iter = 0;
    V_inv = 0;
    V_cur = V_init;
    policy = cell(5,5,5,5,2);
    PQueue = [];
    
    % From the goal state, find it's predecessors;
    goal = instance{ii}.goal;
    goal = [goal, goal, 1];
    pred = tool_findPred(goal);
    
    % Evaluate every predecessor and insert into PQueue;
    for jj = 1 : size(pred, 1)
        s = pred(jj,:);
        V_upd_s = zeros(1, 6);
        p = zeros(1, 6);
        for aa = 1 : 6
           [V_upd_s(aa), p(aa)] = model_update(s, aa, V_cur, gamma, instance{ii});
        end
        % Should insert to PQueue?
%         if (max(abs(p)) > pthreshold)
%            PQueue = tool_insert2PQueue(PQueue, s, max(abs(p)));
%         end
        if (max((p)) > pthreshold)
           PQueue = tool_insert2PQueue(PQueue, s, max((p)));
        end
        % Impove policy by Greedy choice here
        s(1:4) = s(1:4) + 1;
        temp = num2cell(s);
        policy{temp{:}} = find(V_upd_s == max(V_upd_s));
        if (eva_greedy_policy)
            V_cur(temp{:}) = max(V_upd_s);
        end
        if (eva_random_policy)
            V_cur(temp{:}) = mean(V_upd_s);
        end
        count_backup = count_backup + 1;
    end
    
    if (isempty(PQueue))
       error('Goal is unachievable for instance %i', ii);
    else  % Repeat until PQueue is empty
       while (~isempty(PQueue))
          pred = tool_findPred(PQueue(1,2:6));
          PQueue(1,:) = []; % Remove the first row of PQueue;
          for jj = 1 : size(pred, 1)
             s = pred(jj,:);
             V_upd_s = zeros(1, 6);
             p = zeros(1, 6);
             for aa = 1 : 6
                [V_upd_s(aa), p(aa)] = model_update(s, aa, V_cur, gamma, instance{ii});
             end
%              if (max((p)) > pthreshold)
%                 PQueue = tool_insert2PQueue(PQueue, s, max((p)));
%              end
             % Should insert to PQueue?
             if (max(p) > pthreshold)
                PQueue = tool_insert2PQueue(PQueue, s, max(p));
             end
             % Impove policy by Greedy choice here
             s(1:4) = s(1:4) + 1;
             temp = num2cell(s);
             policy{temp{:}} = find(V_upd_s == max(V_upd_s));
             if (eva_greedy_policy)
                 V_cur(temp{:}) = max(V_upd_s);
             end
             if (eva_random_policy)
                 V_cur(temp{:}) = mean(V_upd_s);
             end
             count_backup = count_backup + 1;
          end       
       end
    end
    
    instance{ii}.V_cur = V_cur;
    instance{ii}.policy = policy;
    instance{ii}.count_backup = count_backup;
    
    disp(sprintf('Instance %i is finished!...', ii));
end
toc;

ps = instance;
save('ps.mat', 'ps');
