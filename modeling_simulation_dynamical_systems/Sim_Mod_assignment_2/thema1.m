close all;
clear all;
    
a = 3;
b = 0.5;

%set am and gama
am = 3;
g = 200;

tspan = 0:0.01:30;
v0 = [0; 0; 0; 0; 0];

[t, vsol] = ode45(@(t,y)system(t,y,am,g),tspan, v0);

%solutions
x = vsol(:,1);
ph1 = vsol(:,2);
ph2 = vsol(:,3);
th1_est = vsol(:,4);
th2_est = vsol(:,5);


%param a
a_est = am * ones(length(tspan),1) - th1_est;
ea = a_est - a * ones(length(tspan),1) ; 

%param b
b_est = th2_est;
eb = b_est - b * ones(length(tspan),1) ;

%x
x_est = th1_est .* ph1 + th2_est .* ph2;
ex = x - x_est;

set(groot,'defaultAxesXGrid','on');
set(groot,'defaultAxesYGrid','on');

figure();
plot(t, x);
hold on;
plot(t, x_est)
hold on;
plot(t, ex);
hold on;
legend("x", "x_{est}", "e");
title([ 'am = ', num2str(am), ',  g = ', num2str(g)]);
xlabel("t (s)");

figure();
yline(a, 'r');
hold on;
plot(t, a_est);
legend("a", "a_{est}");
title([ 'am = ', num2str(am), ',  g = ', num2str(g)]);
xlabel("t (s)");

figure();
plot(t, ea);
hold on;
legend("(a_{est} - a)");
title([ 'am = ', num2str(am), ',  g = ', num2str(g)]);
xlabel("t (s)");

figure();
yline(b, 'r');
hold on;
plot(t, b_est);
legend("b", "b_{est}");
title([ 'am = ', num2str(am), ',  g = ', num2str(g)]);
xlabel("t (s)");

figure();
plot(t, eb);
hold on;
legend("(b_{est} - b)");
title([ 'am = ', num2str(am), ',  g = ', num2str(g)]);
xlabel("t (s)");

function dvdt =  system(t, vsol, am, g)

%select input
    %u = 10;
    u = 10*sin(3*t);
    
    a = 3;
    b = 0.5;
    
    x = vsol(1);
    ph1 = vsol(2);
    ph2 = vsol(3);
    th1_est = vsol(4);
    th2_est = vsol(5);
    
    e = x - th1_est*ph1 - th2_est* ph2;
    
    dvdt = [- a * x + b * u; %xdot
            - am * ph1 + x; %phi1dot
            - am * ph2 + u; %ph2dot
             g * e * ph1; %th1^dot
             g * e * ph2 %th2^dot
            ];
end

