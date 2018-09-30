% Problem settings
depot = [0,0; 4,0; 0,3; 4,4];
instance.depot = depot;
instance.start = 1;
instance.goal = 4;
instance.maxH = 15;
instance.nAct = 5;

% MDP solver specifications
instance.epsilon = 1e-1;
instance.maxIter = 1e2;
instance.gamma = 1; % MDP discount factor

% Generate reference trajectory
% ref = zeros(instance.maxH, 2);  % [u_k, x_{k+1}]_{ref}, k = 0,1,...,maxH.
ref = repmat(depot(instance.goal,:), instance.maxH, 1);
ref1 = [0,0;1,0;2,0;2,1;2,2;2,3;3,3;4,3;4,4];
ref(1:size(ref1, 1),:) = ref1;

clear depot ref1