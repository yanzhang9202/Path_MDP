% Problem settings
depot = [0,0; 4,0; 0,3; 4,4];
instance.depot = depot;
instance.start = 1;
instance.goal = 3;
instance.maxH = 15;
instance.nAct = 4;

% MDP solver specifications
instance.epsilon = 1e-1;
instance.maxIter = 1e2;
instance.gamma = 1; % MDP discount factor
