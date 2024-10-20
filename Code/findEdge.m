function edge = findEdge (P,grdCoord)
    arguments
        P(1,2) {mustBeNumeric}
        grdCoord(1,4) {mustBeNumeric}
    end
    Px=P(1);
    Py=P(2);
    grdX= [grdCoord(1) grdCoord(2) grdCoord(2) grdCoord(1)];
    grdY= [grdCoord(3) grdCoord(3) grdCoord(4) grdCoord(4)];
    edge = 0;
    for i=1:4
        iSucc = mod(i,4)+1;
        t = (grdX(iSucc)-grdX(i))/(grdY(iSucc)-grdY(i));
        if (Px-grdX(i))/(Py-grdY(i)) == t
          edge = i;
         end
    end
end