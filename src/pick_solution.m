function [ S, nvalid ] = pick_solution(limits, slns)
%pick_solution given a set of solutions, validates and picks the best one
% valid is true iff there is at least one valid solution
% limits = [m x 2]
% slns = [m x n]
    n = size(slns,2); % number of solutions to check
    m = size(slns,1); % number of dimensions
    nvalid = 0;
    mag = Inf;
    S = zeros(m,1);
    limits = d2r(limits);
    for i = 1:n
        if (all(slns(:,i) > limits(:,1)) && all(slns(:,i) < limits(:,2)))
            nvalid = nvalid + 1;
            if norm(slns(:,i)) < mag
                S = slns(:,i);
                mag = norm(slns(:,i));
            end
        end
    end
    nvalid
end

