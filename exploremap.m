function exploremap()
%EXPLOREMAP is an interactive 3D map of the main Hawaiian islands
% The EXPLOREMAP function takes in no inputs and returns no outputs
% It loads longitude, lattitude, and elevation data, creates a boundary
% box, and plots a surface which represents a section of overall terrain
% map. The terrain map is drawn in a subplot below the surface plot and
% shows the overall terrain along with the boundary lines that translate to
% the boundaries of the surface plot.

%Header stuff goes here
%{

Date: 11/10/2017

Version 1: The function takes in data from a mat file and then ses it it
create a map which one can explore and navigate

Status: Works
%}



%load data
E=load('Data9.mat','ELEV');
x=load('Data9.mat', 'X');    
y=load('Data9.mat', 'Y');


%we now have access to the variables X,Y ELEV

%initialises variable xdiff and ydiff
xdiff=[];
ydiff=[];


%calculate the differences between each element in X and Y and store it in
%xdiff and ydiff
for i=2:size(x.X,2)
    
    xdiff(1,i)=x.X(1,i)-x.X(1,i-1);

end

for i=2:size(y.Y,1)
    
    ydiff(i,1)=y.Y(i,1)-y.Y(i-1,1);

end

%create a vector of zeros xmeters and ymeters which will stores the x and
%y values in meters
xmeters=zeros(size(x.X,1),size(x.X,2));
ymeters=zeros(size(y.Y,1),size(y.Y,2));


%calculate the values of the X and Y vectors in METERS and stores in
%respective variables
for i=2:size(xdiff,2)
    
    xmeters(1,i)=xmeters(1,i-1)+(6.371*(10^6)*tand(xdiff(1,i)));
    
    
end

for i=2:size(ydiff,1)
    
    ymeters(i,1)=ymeters(i-1,1)+(6.371*(10^6)*tand(ydiff(i,1)));
    
    
end

%finds dimensions of the ELEV variable to determine the number of rows and
%columns
Erow=size(E.ELEV,1);
Ecolumn=size(E.ELEV,2);

%build grid
[xgrid, ygrid]=meshgrid(xdiff,ydiff);

%determines boundary box size
bound=50;

%gives starting and ending X and Y points
xstart=1;
xend=bound;
ystart=1;
yend=bound;

%determines how many points will shift when we move
move=10;

%create the vectors for the boundary box (two elements in each)

xTop = [xmeters(xstart) xmeters(xend)];
yTop = [ymeters(yend) ymeters(yend)];
xBottom = [xmeters(xstart) xmeters(xend)];
yBottom = [ymeters(ystart) ymeters(ystart)];
xLeft=[xmeters(xstart) xmeters(xstart)];
yLeft=[ymeters(ystart) ymeters(yend)];
xRight=[xmeters(xend) xmeters(xend)];
yRight=[ymeters(ystart) ymeters(yend)];


%plot first grid (use the value of the boundary box size)
%plotgrid=plot(xgrid(xstart:xend,xstart:xend),ygrid(ystart:yend,ystart:yend));

%calls subplot and plots the surface
subplot(2,1,1)

surfplot = surf(xmeters(xstart:xend),ymeters(ystart:yend),E.ELEV(xstart:xend,ystart:yend));


%set the axis to equal
axis equal

%call subplots and plots the entire contour map 
subplot(2,1,2)
contour(xmeters,ymeters,E.ELEV);
hold on

%plots the boundary box
top=plot(xTop,yTop,'b');
bottom=plot(xBottom,yBottom,'b');
left=plot(xLeft,yLeft,'b');
right=plot(xRight,yRight,'b');


set(gcf,'KeyPressFcn',@callback);
set(gcf,'CurrentCharacter','n');
while (true)
    choose = get(gcf,'CurrentCharacter');
    switch choose
        case 'w'
            %the user wants to move south, so changes the boundary box
            %accordingly
            
            if (ystart-move)<1
                
                ystart=1;
                yend=bound;
                disp(xstart)
                disp(xend);
                
            else
                
                ystart=ystart-move;
                yend=yend-move;
                
            end
            
            
        case 's'
            %the user wants to move north, so changes the boundary box
            %accordingly
            if yend+move>size(ymeters,1)
                
                ystart=yend-bound+1;
                yend=size(ymeters,1);
                
            else
                
                ystart=ystart+move;
                yend=yend+move;
                
            end
            
        case 'd'
            %the user wants to move west, so changes the boundary box
            %accordingly
            
            if (xstart-move)<1
                
                 xstart=1;
                 xend=bound;
                
            else
                
                xstart=xstart-move;
                xend=xend-move;
                
            end
            
        case 'a'
            %the user wants to move east, so changes the boundary box
            %accordingly
            l=size(xmeters,2);
            if xend+move>l
                
                xstart=l-bound+1;
                xend=l;
                
            elseif xend+move<=l
                
                xstart=xstart+move;
                xend=xend+move;
                
            end
            
        case 'q'
            %user quits
            break;
    end;
    set(gcf,'CurrentCharacter','n');
    
    
%calculates NEW boundary box X and Y values (for all 4 lines) & values for 
%the first subplot
xTop = [xmeters(xstart) xmeters(xend)];
yTop = [ymeters(yend) ymeters(yend)];
xBottom = [xmeters(xstart) xmeters(xend)];
yBottom = [ymeters(ystart) ymeters(ystart)];
xLeft=[xmeters(xstart) xmeters(xstart)];
yLeft=[ymeters(ystart) ymeters(yend)];
xRight=[xmeters(xend) xmeters(xend)];
yRight=[ymeters(ystart) ymeters(yend)];
surfx=xmeters(xstart:xend);
surfy=ymeters(ystart:yend);
surfz=E.ELEV(ystart:yend,xstart:xend);
    
%use set function to set XData and YData for the boundary lines and the
%surface plot
    set(top,'XData',xTop);
    set(top,'YData',yTop);
    set(bottom,'XData',xBottom);
    set(bottom,'YData',yBottom);
    set(right,'XData',xRight);
    set(right,'YData',yRight);
    set(left,'XData',xLeft);
    set(left,'YData',yLeft);
    set(surfplot,'XData',surfx);
    set(surfplot,'YData',surfy);
    set(surfplot,'ZData',surfz);
    
    
    %calls drawnow function
    drawnow;
end;
end


function callback(hObject, callbackdata)

end
