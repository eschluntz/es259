classdef PQueue < Queue
   
   % PQueue - strongly-typed Priority Queue collection
   %
   % Properties:
   %
   %   Type (string)
   %   Comparator (function handle, @gt by default) 
   %   
   % Methods:
   %
   %   PQueue(type)
   %   PQueue(type,comparator) 
   %   display
   %   size
   %   isempty
   %   clear
   %   contains(obj)
   %   offer(obj)
   %   remove(obj)
   %   peek   - returns [] if queue is empty
   %   poll   - returns [] if queue is empty 
   %   values - returns contents in a cell array
   %
   % Notes:
   %
   % Compatible classes must overload eq() for object-to-object comparisons
   % 
   % Comparator must be defined in the class, or a base class: RedWidget and 
   % BlueWidget objects can be combined if a Widget comparator is defined
   %
   % Derived from Queue
   %
   % Example:
   %
   % q = PQueue('Widget',@gt)   
   %
   % q.offer(RedWidget(1))
   % q.offer(RedWidget(3))
   % q.offer(RedWidget(2))
   % q.offer(BlueWidget(2))
   % q.offer(BlueWidget(2))
   %
   % q.size
   % q.remove(RedWidget(2));
   % q.size
   % q.remove(BlueWidget(2));
   % q.size
   % 
   % q.peek
   % q.poll
   % q.size
   %
   % Author: dimitri.shvorob@gmail.com, 3/15/09 
   
   properties (SetAccess = protected)
       Comparator  % function handle
   end
         
   methods 
       
       function[obj] = PQueue(type,varargin)
           obj = obj@Queue(type);
           if nargin > 1
               obj.Comparator = varargin{1};
           else
               obj.Comparator = @gt;
           end
       end
      
       function[obj] = offer(obj,e)
           if length(e) > 1
              throw(MException('PQueue:offerMultiple','??? Cannot offer multiple elements at once.'))
           end   
           if ~isa(e,obj.Type)
              throw(MException('PQueue:offerInvalidType','??? Invalid type.'))
           end
           if isempty(obj.Elements)
              obj.Elements = {e};
           else
              n = obj.size;
              r = n + 1;    % prospective rank of new entry          
              for i = 1:n
                  r = r - obj.Comparator(e,obj.Elements{i});
              end            
              if r == n + 1
                 obj.Elements{end+1} = e;
              elseif r == 1
                 g = cell(obj.size+1,1);
                 g{1} = e;
                 g(2:end) = obj.Elements(:);
                 obj.Elements = g; 
              else
                 g = cell(obj.size+1,1); 
                 g(1:r-1) = obj.Elements(1:r-1);
                 g{r} = e;
                 g(r+1:end) = obj.Elements(r:end);
                 obj.Elements = g; 
              end
           end   
       end   
                  
   end   
    
end