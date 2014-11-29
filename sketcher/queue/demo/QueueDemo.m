% Examples of Queue and PQueue usage
%{
q = Queue('Widget')   
 
q.offer(RedWidget(1))
q.offer(RedWidget(3))
q.offer(RedWidget(2))
q.offer(BlueWidget(2))
q.offer(BlueWidget(2))

q.size
q.remove(RedWidget(2))
q.size
q.remove(BlueWidget(2))
q.size

q.peek
q.poll
%}
%%

q = PQueue('Widget')    % default "gt comparator - defined in Widget  
 
q.offer(RedWidget(1));
q.offer(RedWidget(3));
q.offer(RedWidget(2));
q.offer(BlueWidget(2));
q.offer(BlueWidget(2));

q.size
q.remove(RedWidget(2))
q.size
q.remove(BlueWidget(2))
q.size

q.peek
q.poll