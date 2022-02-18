function [snake] = buildingSnake(Project)

movingDirection = 3; %1 down, 2 rigth, 3 up 
xLocation = 1;
yLocation = Project.mrows;
for ii = 1:Project.mcolumns.*Project.mrows
    snake(ii).x = xLocation;
    snake(ii).y = yLocation;
    
    switch  movingDirection
       case 1
           if yLocation == Project.mrows
               movingDirection = 2;
               xLocation = xLocation+1;
           else
               yLocation = yLocation+1;
           end
       case 2
           if yLocation == Project.mrows
               movingDirection = 3;
               yLocation = yLocation-1;
           else
               movingDirection = 1;
               yLocation = yLocation+1;
           end           
       case 3
           if yLocation == 1
               movingDirection = 2;
               xLocation = xLocation+1;
           else
               yLocation = yLocation-1;
           end            
    
   end
end



