function z=squareTest(u,v)
    z=-inf;
    Z=max([u,-u,v,-v]);
    if (Z<1/2)
        z= 1;
    end
    if (1/2<Z && Z<3/2)
        z=3/2-Z;
    end
end