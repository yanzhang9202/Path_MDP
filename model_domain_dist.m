%% Distribution Model of Domain for Taxi Problem
%  Input:
%  s - [x_t, y_t, x_p, y_p, if_on_board], 5*1 vector, 650 states;
%      s(5) = 1 - not on board; s(5) = 2 - on board;
%  a - [up, down, left, right, pick_up, drop_off] 
%      [1,    2,    3,    4,     5,     6];
%  instance - struct: instance.goal - [x_g, y_g];
%                     instance.passenger - [x_p_init, x_p_init];
%  Output:
%  r - rows of rewards, each row represents a possible reward
%  s_prime - rows of s(input), each row represents a possible next state;
%  T - rows of probability, corresponding to s_prime

function [ r, s_prime, T ] = model_domain_dist( s, a, instance )

goal = instance.goal;
goal = [goal, goal, 1];

%% Check validity of input arguments
if (s(1) < 0 || s(1) > 4 || s(2) < 0 || s(2) > 4 || s(3) < 0 || ... 
    s(3) > 4 || s(4) < 0 || s(4) > 4 || s(5) < 1 || s(5) > 2 || ...
    a < 1 || a > 6)
    error('Error: Invalid input argument to domain model!');
end

if (s(5) == 2)
   if (s(1:2) ~= s(3:4))
       error('Error: Invalid input argument to domain model!');
   end
end

%% Distribution Model;
if (s(5) == 1) % Passenger not on board;
    
    if (s == goal) % If is goal state, stick to this state;
        r = 0;
        s_prime = s;
        T = 1;
    else if (a == 6) % Try to drop off when passenger not on board;
            r = -10;
            s_prime = s;
            T = 1;
         else if ( a == 5 ) % Try to pick up;
                 if (s(1:2) == s(3:4))
                     r = -1;
                     s_prime = [s(1:4), 2];
                     T = 1;
                 else
                     r = -10;
                     s_prime = s;
                     T = 1;
                 end
             else % Taxi is moving!
                 T = 0.05 * ones(4,1);
                 T(a) = T(a) + 0.8;     % Probability of every movement;
                 r = -1 * ones(4,1);    % Reward of every moverment;
                 s_prime(1:4,3:5) = repmat(s(3:5),4,1); % Passenger and on-board state don't change;
                 % Taxi next position of upward movement;
                 if (s(2) == 4)
                     s_prime(1,1:2) = s(1:2);
                 else
                     s_prime(1,1:2) = [s(1), s(2)+1];
                 end
                 % Taxi next position of downward movement;
                 if (s(2) == 0)
                     s_prime(2,1:2) = s(1:2);
                 else
                     s_prime(2,1:2) = [s(1), s(2)-1];
                 end
                 % Taxi next position of left movement;
                 if (s(1) == 0 || (s(1) == 1 && s(2) < 2) || ...
                     (s(1) == 3 && s(2) < 2) || (s(1) == 2 && s(2) > 2))
                     s_prime(3,1:2) = s(1:2);
                 else
                     s_prime(3,1:2) = [s(1)-1, s(2)];
                 end
                 % Taxi next position of right movement;
                 if (s(1) == 4 || (s(1) == 1 && s(2) > 2) || ...
                     (s(1) == 0 && s(2) < 2) || (s(1) == 2 && s(2) < 2))
                     s_prime(4,1:2) = s(1:2);
                 else
                     s_prime(4,1:2) = [s(1)+1, s(2)];
                 end
             end
         end
    end 
    
else if (s(5) == 2)          % Passenger on board;
        if (a == 6) % Taxi wants to drop off passenger
            if (s(1:4) == goal(1:4))
                r = 20;
                T = 1;
                s_prime = goal;
            else
                r = -1;
                T = 1;
                s_prime = [s(1:4), 1];
            end
        else if (a == 5) % Try to pick up passenger when he's on board;
                r = -1;
                T = 1;
                s_prime = s;
            else % Taxi is moving when passenger is on board;
                T = 0.05 * ones(4,1);
                T(a) = T(a) + 0.8;     % Probability of every movement;
                r = -1 * ones(4,1);    % Reward of every moverment;
                % Taxi next position of upward movement;
                if (s(2) == 4)
                    s_prime(1,1:2) = s(1:2);
                else
                    s_prime(1,1:2) = [s(1), s(2)+1];
                end
                % Taxi next position of downward movement;
                if (s(2) == 0)
                    s_prime(2,1:2) = s(1:2);
                else
                    s_prime(2,1:2) = [s(1), s(2)-1];
                end
                % Taxi next position of left movement;
                if (s(1) == 0 || (s(1) == 1 && s(2) < 2) || ...
                    (s(1) == 3 && s(2) < 2) || (s(1) == 2 && s(2) > 2))
                    s_prime(3,1:2) = s(1:2);
                else
                    s_prime(3,1:2) = [s(1)-1, s(2)];
                end
                % Taxi next position of right movement;
                if (s(1) == 4 || (s(1) == 1 && s(2) > 2) || ...
                    (s(1) == 0 && s(2) < 2) || (s(1) == 2 && s(2) < 2))
                    s_prime(4,1:2) = s(1:2);
                else
                    s_prime(4,1:2) = [s(1)+1, s(2)];
                end 
                s_prime = repmat(s_prime,1,2);
                s_prime(:,5) = 2;
            end
        end
    else
        error('Error: s(5) is neither 0 or 1!');
    end
end

end


%               else if (a == 1) % Moving upward;
%                       if (s(2) == 4) % If taxi is on the top row;
%                           r(1) = -1;
%                           s_prime(1,:) = s;
%                           T(1) = 0.85;
%                           if (s(1) == 0)
%                               r(2) = -1; T(2) = 0.05; s_prime(2,:) = s;
%                               r(3) = -1; T(3) = 0.05; s_prime(3,:) = [0, 3, s(3:5)];
%                               r(4) = -1; T(4) = 0.05; s_prime(4,:) = [1, 4, s(3:5)];
%                           else if (s(1) == 1)
%                                   r(2) = -1; T(2) = 0.05; s_prime(2,:) = s;
%                                   r(3) = -1; T(3) = 0.05; s_prime(3,:) = [0, 4, s(3:5)];
%                                   r(4) = -1; T(4) = 0.05; s_prime(4,:) = [1, 3, s(3:5)];
%                               else if (s(1) == 2)
%                                       r(2) = -1; T(2) = 0.05; s_prime(2,:) = s;
%                                       r(3) = -1; T(3) = 0.05; s_prime(3,:) = [3, 4, s(3:5)];
%                                       r(4) = -1; T(4) = 0.05; s_prime(4,:) = [2, 3, s(3:5)];
%                                   else if (s(1) == 3)
%                                           r(2) = -1; T(2) = 0.05; s_prime(2,:) = [2, 4, s(3:5)];
%                                           r(3) = -1; T(3) = 0.05; s_prime(3,:) = [3, 4, s(3:5)];
%                                           r(4) = -1; T(4) = 0.05; s_prime(4,:) = [3, 3, s(3:5)]; 
%                                       else if (s(1) == 4)
%                                               r(2) = -1; T(2) = 0.05; s_prime(2,:) = s;
%                                               r(3) = -1; T(3) = 0.05; s_prime(3,:) = [3, 4, s(3:5)];
%                                               r(4) = -1; T(4) = 0.05; s_prime(4,:) = [4, 3, s(3:5)];
%                                           else
%                                               error('Error: Detect s(1) is out of range!');
%                                           end
%                                       end
%                                    end
%                                end
%                           end
%                       else % When moving upward, taxi is not on the top row;
%                           r(1) = -1;
%                           s_prime(1,:) = [s(1),s(2)+1, s(3:5)];
%                           T(1) = 0.85;
%                           if (s(1) == 0 && s(2) > 1) % s(2) = 2 or 3;
%                               r(2) = -1; T(2) = 0.05; s_prime(2,:) = s;
%                               r(3) = -1; T(3) = 0.05; s_prime(3,:) = [0, s(2)-1, s(3:5)];
%                               r(4) = -1; T(4) = 0.05; s_prime(4,:) = [1, s(2), s(3:5)];
%                           end
%                           if (s(1) == 0 && s(2) == 1)
%                               r(2) = -1; T(2) = 0.05; s_prime(2,:) = s;
%                               r(3) = -1; T(3) = 0.05; s_prime(3,:) = s;
%                               r(4) = -1; T(4) = 0.05; s_prime(4,:) = [0, 0, s(3:5)];
%                           end
%                           if (s(1) == 0 && s(2) == 0)
%                               r(2) = -1; T(2) = 0.05; s_prime(2,:) = s;
%                               r(3) = -1; T(3) = 0.05; s_prime(3,:) = s;
%                               r(4) = -1; T(4) = 0.05; s_prime(4,:) = s;
%                           end
%                           
%                       end
%                    end