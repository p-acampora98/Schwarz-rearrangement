% This class is used to compute distribution function and radially decreasing rearrangement.
classdef contourLines < handle
    properties
        matrix(2,:) {mustBeNumeric} % This is the contour matrix M that MATLAB gives with M=contour(-,-)
        numberOfLines {mustBeNumeric} % How many lines are stored (more lines could be part of one contour)
        numberOfLevels {mustBeNumeric} % How many levels (contours) are stored
        index(2,:) {mustBeNumeric} % Contains the indices to read the contourMatrix 
        % for every index(j), we have obj.matrix(:,index(j))=[levels(j), index(j+1)-index(j)-1 ])
        levels(1,:) {mustBeNumeric} % levels(j) represents the height at which the function is cut with the j-th level
        areas(1,:) {mustBeNumeric} % area of j-th level
        squareDomain(1,4) {mustBeNumeric} % [x1 x2 y1 y2] coordinates of the square grid
    end
    methods
        function obj = contourLines (fun, gridCoordinates,numberOfCells,numberOfLevels)
            switch nargin
                case 1
                    gridCoordinates = [0 1 0 1];
                    numberOfCells = 20;
                    numberOfLevels = 100;
                case 2
                    numberOfCells = 20;
                    numberOfLevels = 100;
                case 3
                    numberOfLevels =100;
                case 4
                otherwise
                    errore('At least one argument and no more than four.')
            end
            % Initialize to -inf the values of the contour on the external domain (square)
            x1=gridCoordinates(1);
            x2=gridCoordinates(2);
            y1=gridCoordinates(3);
            y2=gridCoordinates(4);
            % Put to -inf the function fun outside of the grid
            function z = newfun (x,y)
                z=-inf;
                if x1<x && x<x2 && y1<y && y<y2
                    z=fun(x,y);
                end
            end
            % Save contour matrix
            xx=linspace(x1,x2,numberOfCells);
            yy=linspace(y1,y2,numberOfCells);
            [X Y]=meshgrid(xx,yy);
            Z=arrayfun(@newfun,X,Y);
            mat = contourc(xx,yy,Z,numberOfLevels);
            % Compute number of different level sets contained in contourMatrix
            obj.matrix = mat;
            L=length(obj.matrix);
            i=1;
            number =0;         
            while (i<L)
                number = number +1;
                i=i+1+obj.matrix(2,i);
            end
            obj.numberOfLines=number;
            obj.index=zeros(2,number+1);
            obj.updateLevels;    
            obj.numberOfLevels=obj.index(1,number);  
            obj.areas=zeros(1,obj.numberOfLevels);
            obj.squareDomain=gridCoordinates;
        end

        function obj = updateLevels (obj)
        % Update the arrays index and levels
            mat = obj.matrix;
            j=1;
            obj.index(1,1)=j;
            obj.index(2,1)=1;
            tmp1=mat(1,obj.index(2,1));
            obj.levels(j)=tmp1;
            for i=1:obj.numberOfLines
                tmp=tmp1;
                obj.index(2,i+1)=obj.index(2,i)+1+mat(2,obj.index(2,i));
                tmp1=mat(1,obj.index(2,i));          
                if (tmp~=tmp1)
                    j=j+1;
                    obj.levels(j)=tmp1;
                end
                obj.index(1,i)=j;
            end
        end
         
        function [x,y] = getLevel(obj,i)
        % Extract coordinates of i-th level (separating every line of the contour with NaN)
            if (~(0<i && i<obj.numberOfLines+1))
                error('There is no such level')
            end
            ind=obj.index;
            [jStart, jEnd] = levelToIndex(ind,i);
            % Remember that ind(2,j) represents the index of the first coordinate
            % of the j-th line. The last coordinate of the (j-1)-th line is determined as
            % ind(2,j)-2. For every line we have to ignore 1 index, but it will be 
            % replaced by a NaN to give polyshape the possibility to split the lines 
            % when drawing.
            x=zeros(1,ind(2,jEnd+1)-ind(2,jStart)-1+3*(jEnd-jStart));
            y=zeros(1,ind(2,jEnd+1)-ind(2,jStart)-1+3*(jEnd-jStart));
            J0=1;
            for j=jStart:jEnd
                J1=ind(2,j)+1;
                J2=ind(2,j+1)-1;
                tmpx = obj.matrix(1,J1:J2);
                tmpy = obj.matrix(2,J1:J2);
                newPoints=0;
                % The following command should be integrated to complete lines that should
                % take the square into account. The alternative that works is the following:
                % when generating the contour matrix, pass to the function contour a function
                % which is equal to -inf on the edges of the domain.
                % [tmpx, tmpy,newPoints] = completePolygon(tmpx,tmpy,obj.squareDomain);
                if j == jStart
                    x(J0:J0+(J2-J1)+newPoints)=tmpx;
                    y(J0:J0+(J2-J1)+newPoints)=tmpy;
                    J0=J0+(J2-J1)+newPoints+1;
                else 
                    x(J0:J0+(J2-J1)+1+newPoints)=[NaN, tmpx];
                    y(J0:J0+(J2-J1)+1+newPoints)=[NaN, tmpy];
                    J0=J0+(J2-J1)+newPoints+2;
                end
            end 
            x = x(1:J0-1);
            y = y(1:J0-1);
        end
        


        function obj = updateAreas (obj)
            % Store areas of every level set
                
            % We save all the areas in obj.areas
                for i = 1:obj.numberOfLevels
                    [pgonx, pgony] = obj.getLevel(i);
                    pgonLevel = polyshape([pgonx' pgony'],"KeepCollinearPoints",true);
                    obj.areas(i)=area(pgonLevel);
                end

            % We have to check the monotonicity of the areas. For any given area(i), if the
            % successive element area(i+1) is higher, then we have to replace area(i) with
            % its complementary.
                dom = obj.squareDomain;
                domainArea = (dom(2)-dom(1))*(dom(4)-dom(3));
                for i=1:(obj.numberOfLevels-1)
                    if (obj.areas(i)<obj.areas(i+1))
                        obj.areas(i)=domainArea-obj.areas(i);
                    end
                end
        end
    
        function mi = distributionFunction(obj,t)
        % Compute for every level t the area of the level set closest to t (among the stored ones)
            mi=0;
            if t<obj.levels(obj.numberOfLevels)
                lvls=obj.levels;
                [~,closestLevelIndex] = binaryClosest(lvls, t);
                mi = obj.areas(closestLevelIndex);
            end
        end

        function t = radDecrRearr (obj, mi)
            t=obj.levels(1);
            if mi<=obj.areas(1)
                Areas=obj.areas;
                % areas is sorted decreasingly, we need to revert the ordering
                reverseAreas = flip(Areas);
                [~,revClosestAreaIndex] = binaryClosest(reverseAreas,mi);
                closestAreaIndex = obj.numberOfLevels - revClosestAreaIndex +1;
                t = obj.levels(closestAreaIndex);
            end
        end

        function plotLevel (obj,i)
            [x, y]=obj.getLevel(i);
            grd = obj.squareDomain;
            x = [grd(1), grd(2), grd(2), grd(1), NaN, x, NaN, grd(1), grd(2), grd(2), grd(1)];
            y = [grd(3), grd(3), grd(4), grd(4), NaN, y, NaN, grd(3), grd(3), grd(4), grd(4)];
            P=polyshape([x', y']);
            plot(P);
        end
    end
end