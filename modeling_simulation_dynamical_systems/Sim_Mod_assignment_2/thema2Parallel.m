close all;
clear all;
    
a = 3;
b = 0.5;

%set g1, g2
g1 = 6;
g2 = 2;

tspan = 0:0.01:40;
v0 = [0; 0; 0; 0];

%select from 2 noisefree/noise:
[t, vsol] = ode45(@(t,y)PsystemNOISEfree(t,y, g1, g2),tspan, v0);
%[t, vsol] = ode45(@(t,y)PsystemNOISE(t,y, g1, g2),tspan, v0);

x = vsol(:,1);
th1_est = vsol(:,2);
th2_est = vsol(:,3);
x_est = vsol(:,4);

ex = x - x_est;

a_est = th1_est;
ea = a_est - a * ones(length(tspan),1); 

b_est = th2_est;
eb = b_est -  b * ones(length(tspan),1);

set(groot,'defaultAxesXGrid','on');
set(groot,'defaultAxesYGrid','on');

figure();
plot(t, x);
hold on;
plot(t, x_est)
hold on;
legend("x", "x_{est}");
title("x, x_{est}");
xlabel("t (sec)");

figure();
plot(t, ex);
hold on;
legend("(x - x_{est})");
title([' g1 = ', num2str(g1), ',  g2 = ', num2str(g2)]);
xlabel("t (sec)");

figure();
yline(a, 'm');
hold on;
plot(t, a_est)
hold on;
legend("a", "a_{est}");
title([' g1 = ', num2str(g1), ',  g2 = ', num2str(g2)]);
xlabel("t (sec)");

figure();
plot(t, ea);
hold on;
legend("(a_{est} - a)");
title([' g1 = ', num2str(g1), ',  g2 = ', num2str(g2)]);
xlabel("t (sec)");

figure();
yline(b, 'm');
hold on;
plot(t, b_est)
hold on;
legend("b", "b_{est}");
title([' g1 = ', num2str(g1), ',  g2 = ', num2str(g2)]);
xlabel("t (sec)");

figure();
plot(t, eb);
hold on;
legend("(b_{est} - b)");
title([' g1 = ', num2str(g1), ',  g2 = ', num2str(g2)]);
xlabel("t (sec)");
