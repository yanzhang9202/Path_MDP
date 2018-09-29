%% Tool code to Generate Instances
%  Instance specifies where the taxi is and where the goal is.

depot = [0,0; 0,4; 3,0; 4,4];

consider_start_depot_of_taxi = 0;

if (~consider_start_depot_of_taxi)
   instance = cell(1, 4*3);
   count = 1;
   for ii = 1 : 4       % 4 possible depots to place passenger;
       depot_passenger = depot(ii,:);
       depot_left = depot;
       depot_left(ii,:) = [];
       for jj = 1 : 3   % 3 possible depots left to place goal;
           instance{count}.passenger = depot_passenger;
           instance{count}.goal = depot_left(jj,:);
           count = count + 1;
       end
   end
end