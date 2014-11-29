classdef Widget
    
    properties (SetAccess = private)
        x
    end
    
    methods
        
        function[obj] = Widget(x)
            obj.x = x;
        end
               
        function[out] = get.x(obj)
            out = obj.x;
        end
        
        function[out] = eq(obj,obj2) 
            if length(obj2) > 1
               throw(MException('Widget:eqMultiple','??? Cannot compare to multiple elements at once.'))
            end   
            out = strcmp(class(obj),class(obj2)) && obj.x == obj2.x;   % obj2 must be of the same class
        end
        
        function[out] = gt(obj,obj2) 
            if length(obj2) > 1
               throw(MException('Widget:gtMultiple','??? Cannot compare to multiple elements at once.'))
            end  
            out = isa(obj2,'Widget') && obj.x > obj2.x;                % obj2 must be a Widget
        end
        
    end
    
end