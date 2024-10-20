function [PNewx, PNewy,newPoints] = completePolygon (POldx,POldy,grdCoord)
    % Check if some points of the polygon P=[POldx' POldy'] cross the boundary of the
    % square grid grdCoord. We only look for crossings such that startpoint and
    % endpoint of P are on two different edges of the grid.
    arguments
        POldx(1,:) {mustBeNumeric}
        POldy(1,:) {mustBeNumeric}
        grdCoord(1,4) {mustBeNumeric}
    end
    if (length(POldx)~=length(POldy))
        error('The two coordinates POldx and POldy do not have the same length')
    end
    newPoints = 0;
    PNewx = POldx;
    PNewy = POldy;
    grdX= [grdCoord(1) grdCoord(2) grdCoord(2) grdCoord(1) grdCoord(1)];
    grdY= [grdCoord(3) grdCoord(3) grdCoord(4) grdCoord(4) grdCoord(3)];
    L = length(POldx);
    pStartx = POldx(1);
    pStarty = POldy(1);
    pEndx = POldx(L);
    pEndy = POldy(L);
    edgeStart = findEdge([pStartx pStarty],grdCoord);
    edgeEnd = findEdge([pEndx pEndy],grdCoord);
    if edgeStart ~=0 && edgeEnd ~=0
        while edgeEnd ~= edgeStart
            newPoints =newPoints+1;
            edgeEnd =mod(edgeEnd,4)+1;
            PNewx = [PNewx, grdX(edgeEnd)]; %#ok<AGROW>
            PNewy = [PNewy, grdY(edgeEnd)]; %#ok<AGROW>
        end
        
    end

end