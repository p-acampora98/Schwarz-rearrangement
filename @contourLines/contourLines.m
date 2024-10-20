% This class is used to compute distribution function and radially decreasing rearrangement. Up to now, it only works when level sets are CONNECTED and WITHOUT HOLES.
classdef contourLines 
    properties
        matrix(2,:) {mustBeNumeric} % This is the contour matrix M that MATLAB gives with M=contour(-,-)
        numberOfLines {mustBeNumeric} % How many contours are stored
        index(1,:) {mustBeNumeric} % Contains the indices to read the contourMatrix 
        % for every index(j), we have obj.matrix(:,index(j))=[levels(j), index(j+1)-index(j)-1 ])
        levels(1,:) {mustBeNumeric} % levels(j) represents the height at which the function is cut with the j-th level
        areas(1,:) {mustBeNumeric} % area of j-th level
    end
    methods
        function obj = contourLines (mat)
            % Compute number of different level sets contained in contourMatrix
            obj.matrix = mat;
            L=length(obj.matrix);
            i=1;
            number =0;
            temp = obj.matrix(1,1)-1;
            while (i<L)
                if (obj.matrix(1,i)~=temp)
                    number = number +1;
                end
                temp=obj.matrix(1,i); 
                i=i+1+obj.matrix(2,i);
            end
            obj.numberOfLines=number;
            obj.index=zeros(1,number+1);
            obj.levels=zeros(1,number);
            obj.areas=zeros(1,number);
            obj = obj.updateLevels;      
        end
        function obj = updateLevels (obj)
        % Update the arrays index and levels
            obj.index(1)=1;
            for i=1:obj.numberOfLines
                obj.levels(i)=obj.matrix(1,obj.index(i));
                obj.index(i+1)=obj.index(i)+1+obj.matrix(2,obj.index(i));
            end
        end
        function obj = updateAreas (obj)
        % Store areas of every level set
            for i = 1:obj.numberOfLines
                obj.matrix(1,obj.index(i):obj.index(i+1)-1);
                obj.areas(i)=polyarea(obj.matrix(1,obj.index(i):obj.index(i+1)-1),obj.matrix(2,obj.index(i):obj.index(i+1)-1));
            end
        end
        % Extract i-th level
        function [x,y] = getLevel(obj,i)
            if (~(0<i && i<obj.numberOfLines+1))
                error('There is no such level')
            end
            x=obj.matrix(1,obj.index(i)+1:obj.index(i+1)-1);
            y=obj.matrix(2,obj.index(i)+1:obj.index(i+1)-1); 
        end
        
        function mi = distributionFunction(obj,t)
        % Compute for every level t the area of the level set closest to t (among the stored ones)
            lvls=obj.levels;
            [~,closestLevelIndex] = binaryClosest(lvls, t);
            mi = obj.areas(closestLevelIndex);
        end

        function t = radDecrRearr (obj, mi)
            [~,closestAreaIndex] = binaryClosest(obj.areas,mi);
            t = obj.levels(closestAreaIndex);
        end
    end
end