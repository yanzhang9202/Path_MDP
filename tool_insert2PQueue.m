%% Insert current state to PQueue with its priority p(s), and reorder.
%  Input:
%  s - [x_t, y_t, x_p, y_p, if_on_board], 5*1 vector, 650 states;
%      s(5) = 1 - not on board; s(5) = 2 - on board;
%  p(s) - priority of current state s;
%  PQu_cur - Current PQueue list;
%
%  Output:
%  PQu_out - Output PQueue list;

function [PQu_out] = tool_insert2PQueue(PQu_cur, s, ps)

if (isempty(PQu_cur))
   PQu_out = [ps, s];
else
   [~, index] = ismember(s, PQu_cur(:,2:6), 'rows');
   if (index ~= 0)
       PQu_cur(index, :) = [];
   end 
   PQu_out = zeros(size(PQu_cur,1)+1, size(PQu_cur,2));
   PQu_out(1:size(PQu_cur,1), :) = PQu_cur;
   for ii = 1 : size(PQu_out, 1)
      if (ps > PQu_out(ii, 1))
         PQu_out((ii+1):end, :) = PQu_cur(ii:end,:);
         PQu_out(ii, :) = [ps, s];
         break;
      end
   end
   if (PQu_out(end, 1) == 0) 
       PQu_out(end, : ) = [];
   end
end

end