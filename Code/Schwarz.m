function Sch = Schwarz(x,y,T)
    arguments
        x {mustBeNumeric}
        y {mustBeNumeric}
        T {mustBeA(T, 'contourLines')}
    end
    Sch = NaN;
    z=pi*(x^2+y^2);
    dom = T.squareDomain;
    domainVolume = (dom(2)-dom(1))*(dom(4)-dom(3));
    if  (z<domainVolume)
        Sch=T.radDecrRearr(z);
    end
end