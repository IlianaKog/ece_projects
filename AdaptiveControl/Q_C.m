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

tspan = [0:0.01:20];

g1 = 100
g2 = 100
g3 = 100

Q = [10,0; 0,10];
P = lyap(Aref.', Q);
B = [0; 1];

init_v = [0;0;0;0;0;0;0;0];
%d = @(x) 10*square(4*x);
[t, vsol] = ode45(@(t,vsol)AdaptiveControllerC(t, vsol, Aref, Bref,B, P, g1, g2, g3), tspan, init_v) ;

xref = vsol(:,1:2);
x = vsol(:,3:4);
K_est = vsol(:,5:6).'; %transpose the solution of K 
L_est = vsol(:,7);
M_est = vsol(:,8);

e = x - xref;

figure();
plot(t,e(:,1))
title('e_1 = x_1 - x_1ref');
xlabel('t(sec)');
figure();
plot(t,e(:,2))
title('e_2 = x_2 - x_2ref');
xlabel('t(sec)');

% figure();
% plot(t,K_est)
% title('K');
% xlabel('t(sec)');
% 
% figure();
% plot(t,L_est)
% title('L');
% xlabel('t(sec)');
% 
% figure();
% plot(t,M_est)
% title('M');
% xlabel('t(sec)');

figure();
plot(t,xref(:,1),t,xref(:,2))
title('Model Reference System');
xlabel('t(sec)');
legend('x_1ref','x_2ref')

figure();
plot(t,x(:,1),t,x(:,2))
title('System');
xlabel('t(sec)');
legend('x_1','x_2')

figure();
plot(t,xref(:,1),t,x(:,1))
title('q');
xlabel('t(sec)');
legend('x_1ref','x_1')

figure();
plot(t,xref(:,2),t,x(:,2))
title('qdot');
xlabel('t(sec)');
legend('x_2ref','x_2')

function dvdt = AdaptiveControllerC(t, vsol, Aref, Bref, B, P, g1, g2, g3)
    M = 1;
    G = 10;
    C = 1;

    xref = vsol(1:2);
    x = vsol(3:4);
    K_est = vsol(5:6).'; %transpose the solution of K to be 1x2, not 2x1
    L_est = vsol(7);
    M_est = vsol(8);

    %Control
    %r = 5*sin(0.5*t) + 10*sin(1*t);
    %r = 50/2*sin(0.8727*t) + 70/2*sin(1.2217*t) ;
    %r = 10;
    r = 100*sin(3*t);
    %r = 10*sin(3*t);
    %r = 5*sin(3*t) + 10*sin(7*t);

    u = -K_est * x - L_est * r - M_est * sin(x(1));

    ts = 5;
    duration = 5;
    if t>=ts && t<= (ts + duration)
        d = 0;
        u = u + d;
    end
   
    e = x - xref;

    dxref = Aref * xref + Bref * r ;
    dx =   [x(2) ; ((1/M) * u - (C/M) * x(2) -(G/M) * sin(x(1)))] ;
    dK =    g1 * B.' * P * e * x ; % here without transpose x 
    dL =    g2 * B.' * P * e * r ;
    dM =    g3 * B.' * P * e * sin(x(1)) ;
    dvdt = [dxref; dx; dK; dL; dM] ;

end