function dvdt =  PsystemNOISEfree(t, vsol, g1, g2)
 
    u = 10*sin(3*t);
    
    a = 3;
    b = 0.5;
    
    x = vsol(1);    
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