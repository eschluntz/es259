function [ x ] = inhomog( X )
%inhomog turns a vertical homogenous vector normal

n = size(X,1);
s = X(n);

x = X ./ s;

x = x(1:n-1,:);

end

