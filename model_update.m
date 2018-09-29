%% Update model for Taxi problem given the distribution model of environment
%  Input:
%  s - [x_t, y_t, x_p, y_p, if_on_board], 5*1 vector, 650 states;
%      s(5) = 1 - not on board; s(5) = 2 - on board;
%  a - [up, down, left, right, pick_up, drop_off];
%      [1,    2,    3,    4,     5,     6];
%  V_cur - 5*5*5*5*2 matrix, current belief of value function V(s);
%  gamma - discount factor;
%  instance - struct: instance.goal - [x_g, y_g];
%                     instance.passenger - [x_p_init, y_p_init];
%  Output:
%  V_upd - updated value of current state s given action a;
%  p - priority of this update;

function [ V_upd, p ] = model_update ( s, a, V_cur, gamma, instance )

[r, s_prime, T] = model_domain_dist(s, a, instance);

V_upd = 0;

for ii = 1 : size(r,1)
   s_prime(ii,1:4) = s_prime(ii,1:4) + 1;
   temp = num2cell(s_prime(ii,:));
   V_upd = V_upd + T(ii)*(r(ii) + gamma*V_cur(temp{:}));
end

s(1:4) = s(1:4) + 1;
temp = num2cell(s);
p = V_upd - V_cur(temp{:});

end
