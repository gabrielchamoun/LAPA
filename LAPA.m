clc; close all; clear all;
set(0, 'DefaultFigureWindowStyle', 'docked')

nx = 50;   % # of colums
ny = 50;   % # of rows
ni = 10000; % # of iterations
V = zeros(nx,ny); % Initializing matrix

% Boundary Condition Variables
boundMin = 1;	% Boundary at n = 1
boundMax = 0;	% Boundary at n = ny
boundSide = 0;	% Side Boundaries ==> (-1) - Insulated
% ----------------------------------------------------------------

% Variables used to detect when sim is close to convergence
detect = 1;    % Use this to toggle ON (1) or OFF (0) detection
percentileDiff = 0.000005; % Threshold to stop simulation
previousValue = 0;
currentValue = 0;
% ----------------------------------------------------------------

% Iterating ni times over every node
for i = 1:ni
    for m = 1:nx
        for n = 1:ny
            
            % Handling every edge case
            if n == 1
                V(m,n) = boundMin;
            elseif n == ny
                V(m,n) = boundMax;
            elseif boundSide ~= -1 && (m == 1 || m == nx)
                V(m,n) = boundSide;
            elseif m == 1       % Handling the sides if no conditions set
                V(m,n) = ( V(m+1,n) + V(m,n+1) + V(m,n-1) ) / 3;
            elseif m == nx      % Handling the sides if no conditions set
                V(m,n) = ( V(m-1,n) + V(m,n+1) + V(m,n-1) ) / 3;
            elseif n > 1 && m > 1 && n < ny && m < nx   % Double check for edge cases
                V(m,n) = ( V(m+1,n) + V(m-1,n) + V(m,n+1) + V(m,n-1) ) / 4;
            end
            
        end
        
        % Plot the surface every 50 iterations
        if mod(i,50) == 0
            surf(V');
            pause(0.0001);
        end
        
    end
    
    % Detection based on finding the mean of every node along the middle.
    % Percent difference compared with set value above.
    currentValue = mean(V(:,round(nx/2)));
    diff = abs((currentValue - previousValue))/previousValue;
    if detect && i > 1 && diff < percentileDiff
        break
    end
    previousValue = currentValue;
    
end

% Plotting the vectorss
[Ex, Ey] = gradient(V);
figure
quiver(-Ey',-Ex',1);
