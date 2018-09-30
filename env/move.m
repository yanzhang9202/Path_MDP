function [s_prime] = move(s, a, instance)
maxH = instance.maxH;
pos = s(1:2);
t = s(3);
% Movements with no obstacles
switch a
    case 1, s_prime = [min(pos(1)+1,4), pos(2), min(t+1, maxH)];          
    case 2, s_prime = [pos(1), min(pos(2)+1,4), min(t+1, maxH)];
    case 3, s_prime = [max(pos(1)-1,0), pos(2), min(t+1, maxH)];
    case 4, s_prime = [pos(1), max(pos(2)-1,0), min(t+1, maxH)];
    case 5, s_prime = [pos, min(t+1, maxH)];
end
% Movement with obstacles
switch sprintf('%d', pos)
    case {'00', '10', '02', '12', '31', '41'}
        if a == 2
            s_prime(1:2) = pos;
        end
    case {'01', '11', '03', '13', '32', '42'}
        if a == 4
            s_prime(1:2) = pos;
        end
    otherwise
        % Do nothing
end
end