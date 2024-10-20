clc
clear

x1=-2;
x2=2;
y1=-2;
y2=2;
gridCoordinates = [x1, x2, y1, y2];
x=linspace(x1,x2,100);
y=linspace(y1,y2,100);

[X,Y]=meshgrid(x,y);
function z=f(u,v)
    z=-inf;
    % Z=max([u,-u,v,-v]);
    % if (Z<1/2)
    %     z= 1;
    % end
    % if (1/2<Z && Z<3/2)
    %     z=3/2-Z;
    % end
    % Z=u^2+v^2;
    if (max([u,-u,v,-v])<2)
        z=peaks(u,v);
    end
end
F=@f;
Z=arrayfun(F,X,Y);
% Z=(X.^2+Y.^2);
% Z=peaks(X,Y);
numberOfLevels=150;
C= contourc(x,y,Z,numberOfLevels);
FG=figure('Name','Schwarz Rearrangement','NumberTitle','off');
FG.Position= [350 150 900 450];
tiledlayout(1,2);
nexttile;
S1=surf(X,Y,Z,'EdgeAlpha','.3');
T=contourMultiLines(C,gridCoordinates);
T.updateAreas;
function Sch = genSchwarz(x,y,T)
    Sch = NaN;
    z=pi*(x^2+y^2);
    dom = T.squareDomain;
    domainVolume = (dom(2)-dom(1))*(dom(4)-dom(3));
    if  (z<domainVolume)
        Sch=T.radDecrRearr(z);
    end
end
Schwarz= @(x,y) genSchwarz(x,y,T);
nexttile;
dom = T.squareDomain;
domainVolume = (dom(2)-dom(1))*(dom(4)-dom(3));
radiusSharp = sqrt(domainVolume/pi);
x=linspace(-radiusSharp, radiusSharp);
y=linspace(-radiusSharp, radiusSharp);
[X, Y]= meshgrid(x,y);
Z=arrayfun(Schwarz,X,Y);
squareVolume = (x2-x1)*(y2-y1);
for z=Z
    if (z<2)

    end
end
S2=surf(X,Y,Z,'EdgeAlpha','.3');
