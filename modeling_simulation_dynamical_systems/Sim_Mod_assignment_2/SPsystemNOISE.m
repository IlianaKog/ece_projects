function dvdt =  SPsystemNOISE(t, vsol, g1, g2, thm)
   
    u = 10*sin(3*t);
    
    a = 3;
    b = 0.5;
    
    x = vsol(1);
    %add noise in x
    f = 40;
    h0 = 0.5;
    x = x + h0 * sin(2*pi*f*t);
    
    th1_est = vsol(2);
    th2_est = vsol(3);
    x_est = vsol(4);
    
    e = x - x_est;
    
    dvdt = [ - a * x + b * u;
            - g1 * e * x;
            + g2 * e * u;
            - th1_est * x + th2_est * u + thm * (x - x_est)
        ];
end