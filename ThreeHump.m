function fval=ThreeHump(x1,x2)
    fval = 2 * x1.^2 - 1.05 * x1.^4 + x1.^6/6 + x1*x2 + x2.^2; 