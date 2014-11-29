classdef DefaultDict < handle
    %DefaultDict implements a default dict mapping D[a,b] = c
    %   Detailed explanation goes here
    
    properties (Hidden)
        v; % values
        s; % whether value has been set
        default; % default value
    end
    
    methods
        function obj = DefaultDict(m,n, val)
            % size, size, default value
            obj.v = sparse(m,n);
            obj.s = sparse(m,n);
            obj.default = val;
        end
        
        function insert(obj, k1, k2, val)
            obj.v(k1,k2) = val;
            obj.s(k1,k2) = 1;
        end
        
        function [val] = get(obj, k1, k2)
            if obj.s(k1, k2)
                val = full(obj.v(k1,k2));
            else
                val = obj.default;
            end
        end
        
        function show(obj)
            obj.s
            obj.v
        end
    end
end

