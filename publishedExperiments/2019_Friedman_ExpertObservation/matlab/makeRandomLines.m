% MAKE RANDOM LINES - make a dot that moves along a line

function position = makeRandomLines(numFrames,numPerLine,velocity)

for k=1:numFrames
   if mod(k,numPerLine)==0 || k==1
       % Start a new line
       direction = rand * 2* pi;
       x = rand;
       y = rand;
   else
       x = position(k-1,1);
       y = position(k-1,2);
   end
   position(k,1) = x + velocity * cos(direction);
   position(k,2) = y + velocity * sin(direction);
   
   if position(k,1)>1
       position(k,1) = 0;
   elseif position(k,1)<0
       position(k,1) = 1;
   end
   if position(k,2)>1
       position(k,2) = 0;
   elseif position(k,2)<0
       position(k,2) = 1;
   end
end