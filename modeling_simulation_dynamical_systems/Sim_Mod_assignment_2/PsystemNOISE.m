function dvdt =  PsystemNOISE(t, vsol, g1, g2)
 
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
    
    dvdt = [ - a * x + b * u; %xdot
            - g1 * e * x_est; %th1^dot
            + g2 * e * u; %th2^dot
            - th1_est * x_est + th2_est * u %x^dot
        ];
    
    
end