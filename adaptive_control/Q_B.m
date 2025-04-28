%Iliana Kogia 10090

close all;
clear all;

set(groot,'defaultAxesXGrid','on');
set(groot,'defaultAxesYGrid','on');

%calculate the second order referense system
w_n = 1; 
z = 0.7; 
Aref = [0, 1; -w_n^2, -2*z*w_n];
Bref = [0; w_n^2];

tspan = [0:0.01:25];
init_x = [0; 0];

gamma = 200; %select
v= [gamma gamma gamma gamma];
gamma = diag(v);

po = 0.2; %select
g = 1;
lamda = 0.2; %select
F = - lamda;
init_v = zeros(14,1);
[t, vsol] = ode45(@(t,vsol)AdaptiveControllerB(t, vsol, Aref, Bref, F, po, gamma, g), tspan, init_v) ;

xref = vsol(:,1:2);
x = vsol(:,3:4);
w1 = vsol(:,5); 
w2 = vsol(:,6);
phi = vsol(:,7:10);
theta = vsol(:,11:14);
e = x(:,1) - xref(:,1);

figure();
plot(t,e)
title('ε = y - y_m');
xlabel('t(sec)');

figure();
plot(t,xref(:,1),t,xref(:,2))
title('Model Reference System');
xlabel('t(sec)');legend('x_1ref','x_2ref')
figure();
plot(t,x(:,1),t,x(:,2))
title('System');
xlabel('t(sec)');
legend('x_1','x_2')

figure();
plot(t,xref(:,1),t,x(:,1))
title('y = q');
xlabel('t(sec)');
legend('x_1ref','x_1')
figure();
plot(t,xref(:,2),t,x(:,2))
title('qdot');
xlabel('t(sec)');
legend('x_2ref','x_2')


function dvdt = AdaptiveControllerB(t, vsol, Aref, Bref,F, po, gamma, g)
    M = 1;
    G = 10;
    C = 1;

    xref = vsol(1:2);
    x = vsol(3:4);
    w1 = vsol(5); 
    w2 = vsol(6);
    phi = vsol(7:10);
    theta = vsol(11:14);

    %Control
    %r = 5*sin(0.6981*t) + 10*sin(1.22*t);
    %r = 10;
    %r = 5*sin(3*t) + 10*sin(7*t);
    r = 100*sin(3*t);
    %r = 5*sin(0.5*t) + 10*sin(1*t);
    %r = 5*sin(0.5*t) + 7*sin(1.5*t);

    y = x(1);
    ym = xref(1);
    e = y - ym;
    w = [w1; w2; y; r];
    %u = theta(1) * w1 + theta(2) * w2 + theta(3) * y + theta(4) * r - phi.' * gamma * e * phi;
    u = theta.' * w - phi.' * gamma * e * phi;

    ts = 6;
    duration = 5;
    if t>=ts && t<= (ts + duration)
        d = 0;
        u = u + d;
    end

    dxref = Aref * xref + Bref * r ;
    dx =   [x(2) ; (+ (1/M) * u - (C/M) * x(2) -(G/M) * sin(x(1)) )] ;
    dw1 =   F * w1 + g * u ;
    dw2 =    F * w2 + g * y ; 
    dphi =    - po * phi + w ;
    dtheta =    - gamma * e * phi;

    dvdt = [dxref; dx; dw1; dw2; dphi; dtheta] ;
end