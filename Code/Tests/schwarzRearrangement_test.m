clc
clear

% Parameters
nLevels = 100;
nCells = 100;

% Functions
F1 = @peaks; % To be reordered
F2 = @squareTest; % Giving the levels to reorder


% General square domain 
x1=-2;
x2=2;
y1=-2;
y2=2;
gridCoordinates = [x1, x2, y1, y2];
x=linspace(x1,x2,nCells);
y=linspace(y1,y2,nCells);
[X,Y]=meshgrid(x,y);

% Preset the window to plot 3 surfaces
FG=figure('Name','Schwarz Rearrangement','NumberTitle','off');
FG.Position= [100 150 1350 450];
tiledlayout(1,2);
nexttile;

% Plot F1
Z=arrayfun(F1,X,Y);
S1=surf(X,Y,Z,'EdgeAlpha','.3');
nexttile;

% Construct the object contourLines to reorder F1
F1Lines=contourLines(F1,gridCoordinates,nCells,nLevels);


% Construct the object contourLines to obtain the levels of F2
F2Lines = contourLines(F2,gridCoordinates,nCells,nLevels);

% Uncomment the following to compute a bigger grid containing the ball of same volume
% as the initial grid  
dom = F1Lines.squareDomain;
domainVolume = (dom(2)-dom(1))*(dom(4)-dom(3));
radiusSharp = sqrt(domainVolume/pi);
x=linspace(-radiusSharp, radiusSharp,nCells);
y=linspace(-radiusSharp, radiusSharp,nCells);
[X, Y]= meshgrid(x,y);


% Colors of the plot   
colorMapLength = 100;
green = [45, 210, 97]/255*1.1; %Color in the upper part
purple = [111, 83, 171]/255*1.1; %Color in the lower part
% pink = [234, 71, 122]/255*1.08; %Color in the upper part
% lBlue = [7, 202, 210]/255*1.08; %Color in the lower part
customColorMap = [linspace(purple(1),green(1),colorMapLength)', linspace(purple(2),green(2),colorMapLength)', linspace(purple(3),green(3),colorMapLength)']; 


% Plot the rearrangement of F1 along F2
mm = min(min(peaks));
G = @(x,y) F1Lines.Schwarz(x,y);
Z=max(mm,arrayfun(G,X,Y));
squareVolume = (x2-x1)*(y2-y1);
S2=surf(X,Y,Z,'EdgeAlpha','.3');
colormap(customColorMap);
% S2.EdgeColor = "none";
% lightangle(-45,45);
% lighting gouraud;
% nexttile;

% % Plot F2
% Z = arrayfun(F2,X,Y);
% S3=surf(X,Y,Z,'EdgeAlpha','.3');
