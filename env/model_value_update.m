function [Jsa, psa] = model_value_update(s, a, J, instance, ref)
% Model the environment given current state-action pair (s,a)
gamma = instance.gamma;
% Given (s,a), next state, reward, and probability
[r, s_prime, T] = model_react(s, a, instance, ref);
% Compute the expectation of current state value
Jsa = 0;
for ii = 1 : size(r,1)
   s_prime(ii,1:2) = s_prime(ii,1:2) + 1;
   temp = num2cell(s_prime(ii,:));
   Jsa = Jsa + T(ii)*(r(ii) + gamma*J(temp{:}));
end
% Compute the priority vector
s(1:2) = s(1:2) + 1;
temp = num2cell(s);
psa = Jsa - J(temp{:});
end