function [ c ] = seg_cost(s)
%seg_cost returns the cost of a segment from Fs
%c = -log(1+s(5));
c = 1 - s(5);
assert(c >= 0);
end

