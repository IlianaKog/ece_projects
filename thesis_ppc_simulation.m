close all;
clear all;

%% initialize leader

x01_init = [0.35; -0.2];
x02_init = [0; 0.33];
x03_init = [-0.2; 0];

%% initialize agents

x1bar_init = [-0.1;-0.2; 0.15;0.1; 0;0; 0.1;-0.3]; %[x11,x11, x21,x21, x31,x31, x41,x41];
agents_12_init = [-0.1;-0.2; 0;0; 0.15;0.1; 0;0];
agent_3 = [0;0;0;0;];
agent_4 = [0.1;-0.3; 0;0;];

%% initialize ode

init_v = [agents_12_init; agent_3; agent_4];

%% Communication Graph
N = 4;
A = zeros(N,N);
A(1,2) = 1;
A(3,2) = 1;
A(4,1) = 1;
A(4,3) = 1;

D = diag([1,0,1,2]);
L = D - A;

B = diag([0,1,0,0]); % only agent-2 receives info directly from leader

Tmati = 0.01;
tstop = 30; 
k_total = round(tstop/Tmati);
tspan = linspace(0,tstop, k_total);
options = odeset("RelTol",1e-11,"AbsTol", 1e-6, Stats="on");  

[t, vsol] = ode15s(@(t,vsol)masPPC(t, vsol, L, B, Tmati), tspan, init_v, options);

%% PLOTS

x11 = vsol(:,1:2);
x12 = vsol(:,3:4);
x21 = vsol(:,5:6);
x22 = vsol(:,7:8);
x31 = vsol(:,9:10);
x32 = vsol(:,11:12);
x41 = vsol(:,13:14);
x42 = vsol(:,15:16);


delta11 = zeros(2,size(t,1));
delta21 = zeros(2,size(t,1));
delta31 = zeros(2,size(t,1));
delta41 = zeros(2,size(t,1));
u1 = zeros(2,size(t,1));
u2 = zeros(2,size(t,1));
u3 = zeros(2,size(t,1));
u4 = zeros(2,size(t,1));

xi_11 = zeros(2,size(t,1));
xi_21 = zeros(2,size(t,1));
xi_31 = zeros(2,size(t,1));
xi_41 = zeros(2,size(t,1));

%% calculate signals of the closed loop

for i = 1:size(t,1)
    [~, delta11(:,i), delta21(:,i), delta31(:,i), delta41(:,i), u1(:,i), u2(:,i), u3(:,i), u4(:,i), xi_11(:,i), xi_21(:,i), xi_31(:,i), xi_41(:,i)] = masPPC(t(i), vsol(i,:).' ,L,B, Tmati);
end

p11(1,:) = (0.8 - 1*10^-2) * exp(-t) + 1*10^-2;
p11(2,:) = (0.8 - 1*10^-2) * exp(-t) + 1*10^-2;

x01(1,:) = 0.2*cos(0.4*pi*t);
x01(2,:) = 0.2*sin(0.4*pi*t);
x01 = x01.';

%% signal u
figure()
subplot(2,1,1);
plot(t, u1(1,:));
title("u1, p=1");
%figure()
subplot(2,1,2);
plot(t, u1(2,:));
title("u1, p=2");

figure()
subplot(2,1,1);
plot(t, u2(1,:));
title("u2, p=1");
%figure()
subplot(2,1,2);
plot(t, u2(2,:));
title("u2, p=2");

figure()
subplot(2,1,1);
plot(t, u3(1,:));
title("u3, p=1");
%figure()
subplot(2,1,2);
plot(t, u3(2,:));
title("u3, p=2");

figure()
subplot(2,1,1);
plot(t, u4(1,:));
title("u4, p=1");
%figure()
subplot(2,1,2);
plot(t, u4(2,:));
title("u4, p=2");

%% xi
figure()
subplot(2,1,1);
plot(t, xi_11(1,:));
title("xi_11, p=1");
%figure()
subplot(2,1,2);
plot(t, xi_11(2,:));
title("xi_11, p=2");

figure()
subplot(2,1,1);
plot(t, xi_21(1,:));
title("xi_21, p=1");
%figure()
subplot(2,1,2);
plot(t, xi_21(2,:));
title("xi_21, p=2");

figure()
subplot(2,1,1);
plot(t, xi_31(1,:));
title("xi_31, p=1");
%figure()
subplot(2,1,2);
plot(t, xi_31(2,:));
title("xi_31, p=2");

figure()
subplot(2,1,1);
plot(t, xi_41(1,:));
title("xi_41, p=1");
%figure()
subplot(2,1,2);
plot(t, xi_41(2,:));
title("xi_41, p=2");
%% delta with 0.004

figure()
subplot(2,1,1);
plot(t, delta11(1,:));
hold on;
yline(0.004);
hold on;
yline(-0.004);
title("δ1,1, p=1");
%figure()
subplot(2,1,2);
plot(t, delta11(2,:));
hold on;
yline(0.004);
hold on;
yline(-0.004);
title("δ1,1, p=2");

figure()
subplot(2,1,1);
plot(t, delta21(1,:));
hold on;
yline(0.004);
hold on;
yline(-0.004);
title("δ2,1, p=1");
%figure()
subplot(2,1,2);
plot(t, delta21(2,:));
hold on;
yline(0.004);
hold on;
yline(-0.004);
title("δ2,1, p=2");

figure()
subplot(2,1,1);
plot(t, delta31(1,:));
hold on;
yline(0.004);
hold on;
yline(-0.004);
title("δ3,1, p=1");
%figure()
subplot(2,1,2);
plot(t, delta31(2,:));
hold on;
yline(0.004);
hold on;
yline(-0.004);
title("δ3,1, p=2");

figure()
subplot(2,1,1);
plot(t, delta41(1,:));
hold on;
yline(0.004);
hold on;
yline(-0.004);
title("δ4,1, p=1");
%figure()
subplot(2,1,2);
plot(t, delta41(2,:));
hold on;
yline(0.004);
hold on;
yline(-0.004);
title("δ4,1, p=2");

%% delta 
figure()
subplot(2,1,1);
plot(t, delta11(1,:));
hold on;
plot(t, p11(1,:));
hold on;
plot(t, -p11(1,:));
title("δ1,1, p=1");
%figure()
subplot(2,1,2);
plot(t, delta11(2,:));
hold on;
plot(t, p11(1,:));
hold on;
plot(t, -p11(1,:));
title("δ1,1, p=2");

figure()
subplot(2,1,1);
plot(t, delta21(1,:));
hold on;
plot(t, p11(1,:));
hold on;
plot(t, -p11(1,:));
title("δ2,1, p=1");
%figure()
subplot(2,1,2);
plot(t, delta21(2,:));
hold on;
plot(t, p11(1,:));
hold on;
plot(t, -p11(1,:));
title("δ2,1, p=2");

figure()
subplot(2,1,1);
plot(t, delta31(1,:));
hold on;
plot(t, p11(1,:));
hold on;
plot(t, -p11(1,:));
title("δ3,1, p=1");
%figure()
subplot(2,1,2);
plot(t, delta31(2,:));
hold on;
plot(t, p11(1,:));
hold on;
plot(t, -p11(1,:));
title("δ3,1, p=2");

figure()
subplot(2,1,1);
plot(t, delta41(1,:));
hold on;
plot(t, p11(1,:));
hold on;
plot(t, -p11(1,:));
title("δ4,1, p=1");
%figure()
subplot(2,1,2);
plot(t, delta41(2,:));
hold on;
plot(t, p11(1,:));
hold on;
plot(t, -p11(1,:));
title("δ4,1, p=2");

%% x01
figure()
subplot(2,1,1);
p = 1;
plot(t,x01(:,p), 'blue');
hold on;
plot(t, x11(:,p), 'red');
hold on;
plot(t, x21(:,p), 'green');
hold on;
plot(t, x31(:,p), 'black');
hold on;
plot(t, x41(:,p));
legend("x01", "x11", "x21", "x31", "x41");
%figure()
subplot(2,1,2);
p = 2;
plot(t,x01(:,p),'blue');
hold on;
plot(t, x11(:,p),'red');
hold on;
plot(t, x21(:,p), 'green');
hold on;
plot(t, x31(:,p), 'black');
hold on;
plot(t, x41(:,p));
legend("x01", "x11", "x21", "x31", "x41");


%% x02
figure()
subplot(2,1,1);
p = 1;
% plot(t,x02(:,p),'blue');
% hold on;
plot(t, x12(:,p),'red');
hold on;
plot(t, x22(:,p), 'green');
hold on;
plot(t, x32(:,p), 'black');
hold on;
plot(t, x42(:,p));
legend("x12", "x22", "x32", "x42");
%figure()
subplot(2,1,2);
p = 2;
% plot(t,x02(:,p),'blue');
% hold on;
plot(t, x12(:,p),'red');
hold on;
plot(t, x22(:,p), 'green');
hold on;
plot(t, x32(:,p), 'black');
hold on;
plot(t, x42(:,p));
legend("x12", "x22", "x32", "x42");


%% function

function [dvdt, delta11, delta21, delta31, delta41, u1, u2, u3, u4, xi_11, xi_21, xi_31, xi_41] = masPPC(t, vsol, L, B, Tmati)
    
    T = @(x) (0.5*pi).*sec(pi.*x./2).^2;

    persistent x11_hold x21_hold x31_hold x41_hold last_update_time x01 k
    A = 0.2;
    w = 0.4;
    
    if t == 0 % t == 0 is safe, tspan includes 0 explicitly
        % for the first time
        x11_hold = vsol(1:2);
        x21_hold = vsol(5:6);
        x31_hold = vsol(9:10);
        x41_hold = vsol(13:14); 
        last_update_time = 0;
        x01(1,1) = A*cos(w*pi*t);
        x01(2,1) = A*sin(w*pi*t);
        k = 0;
    end
    if t >= (last_update_time + Tmati)
       % update the discrete states at tk+1, t = k*Tmati 
        x11_hold = vsol(1:2);
        x21_hold = vsol(5:6);
        x31_hold = vsol(9:10);
        x41_hold = vsol(13:14);
      
        k = k + 1;
        last_update_time = k * Tmati;
        x01(1,1) = A*cos(w*pi*t);
        x01(2,1) = A*sin(w*pi*t);

    end

    x11 = vsol(1:2);
    x12 = vsol(3:4);
    x21 = vsol(5:6);
    x22 = vsol(7:8);
    x31 = vsol(9:10);
    x32 = vsol(11:12);
    x41 = vsol(13:14);
    x42 = vsol(15:16);
  

    %% diataraxi
    z = [0.3*cos(3*pi*t)*cos(2*pi*t)*0.2*sin(1.5*pi*t) - 0.1*sin(pi*t)*0.4*cos(2*pi*t);
    0.5*cos(3*pi*t)*0.3*sin(2*pi*t) - 0.3*sin(1.5*pi*t)];

    %% p
    p11(1,1) = (0.8 - 4*10^-2) * exp(-t) + 4*10^-2; 
    p11(2,1) = (0.8 - 4*10^-2) * exp(-t) + 4*10^-2; 
    p21 = p11;

    p12(1,1) = (3 - 0.8) * exp(-t) + 0.8;
    p12(2,1) = (3 - 0.8) * exp(-t) + 0.8;
    p22 = p12;

    %% gains
    K11 = [2; 2];
    K12 = [85; 85];

    K21 = [2; 2];
    K22 = [85; 85];

    %% agent 1 

    % e11 = e1_bar(1:2);
    e11(1,1) = x11(1) - x21_hold(1);
    e11(2,1) = x11(2) - x21_hold(2);
    
    delta11(1,1) = x11(1) - x01(1);
    delta11(2,1) = x11(2) - x01(2);

    error = e11 ./ p11;
    xi_11 = error;

    psy_11 = - K11 .* tan(error.*(pi/2));
    
    error = (x12 - psy_11) ./ p12;
    xi_12 = error;

    psy_12 = - K12 .* tan(error.*(pi/2)) ./ (p12 ).* (T(error));

    u1 = psy_12;

    G1 = [x11(1)^2 + 1, cos(x11(2)) ; sin(x12(1)), x12(2)^2 + 4 ];

    f11 = [sin(x11(1)) ; cos(x11(2))];

    f12 = [-2*x12(1) - x12(2); x11(1)^2]; %???
    
    dx11 = x12 + f11;
    dx12 = f12 + G1 * u1 + z;


    %% agent 2
    
    % e21 = e1_bar(3:4);
    e21(1,1) = x21(1) - x01(1);
    e21(2,1) = x21(2) - x01(2);
    
    % delta21 = delta1_bar(3:4); 
    delta21 = e21;

    error = e21 ./ p21;
    xi_21 = error;
    
    psy_21 = - K21 .* tan(error.*(pi/2));
    
    error = (x22 - psy_21) ./ p22;
    xi_22 = error;

    psy_22 = - K22 .* tan(error.*(pi/2)) ./ (p22 ).* (T(error));

    u2 = psy_22;

    G2 = [x21(1)^2 + 1, sin(x21(2)) ; cos(x22(2)), x22(2)^2 + 1];

    f21 = [+2*x21(1); x21(2)^3];

    f22 = [x21(1)^2; x22(2)^2 - x21(1)^5]; 
    
    dx21 = x22 + f21;
    dx22 = f22 + G2 * u2 + z;


    %% agent 3

    p31 = p11;
    p32(1,1) = (3 - 0.8) * exp( - t) + 0.8;
    p32(2,1) = (3 - 0.8) * exp( - t) + 0.8;

    p33(1,1) = (3 - 0.8) * exp( - t) + 0.8;  
    p33(2,1) = (3 - 0.8) * exp( - t) + 0.8; 

    K31 = [2; 2];
    K32 = [80; 80];

    % e31 = e1_bar(5:6);
    e31(1,1) = x31(1) - x21_hold(1);
    e31(2,1) = x31(2) - x21_hold(2);
    delta31 = x31 - x01; 

    error = e31 ./ p31;
    xi_31 = error;
    
    psy_31 = - K31.* tan(error.*(pi/2));
    xi_32 = error;

    error = (x32 - psy_31) ./ p32;
    
    psy_32 = - K32 .* tan(error.*(pi/2)) ./ (p32 ) .* (T(error));
    
    u3 = psy_32;

    G3 = [x31(1)^2 + 1, cos(x31(1)) ; sin(x31(2)), x31(1)^2 + 3];

    f31 = [cos(x31(1))^2 ; x31(1)^2];

    f32 = [sin(x32(2)) + x32(1) ; 5*x32(1)^3];

    dx31 = x32 + f31;
    dx32 = f32 + G3 * u3 + z;


    %% agent 4

    p41 = p11;
    p42(1,1) = (3 - 0.8) * exp( - t) + 0.8;
    p42(2,1) = (3 - 0.8) * exp( -  t) + 0.8; 
    p43(1,1) = (3 - 0.8) * exp(-  t) + 0.8;
    p43(2,1) = p43(1,1);

    K41 = [2; 2];
    K42 = [70; 30];

    % e41 = e1_bar(7:8);
    e41(1,1) = (x41(1) - x11_hold(1)) + (x41(1) - x31_hold(1));
    e41(2,1) = (x41(2) - x11_hold(2)) + (x41(2) - x31_hold(2));
    delta41 = x41 - x01;

    error = e41 ./ p41;
    xi_41 = error;

    psy_41 = - K41 .* tan(error.*(pi/2));

    error = (x42 - psy_41) ./ p42;
    xi_42 = error;

    psy_42 = - K42 .* tan(error.*(pi/2)) ./ (p42 ).* (T(error));

    u4 = psy_42;

    f41 = [sin(x41(1))^2 ; x41(1)^2];

    f42 = [cos(x42(2)) + x42(1) ; 5*x42(1)^2];

    G4 = [x41(1)^2 + 2, cos(x41(1)) ; sin(x41(2)), x41(1)^2 + 3];
    
    dx41 = x42 + f41;
    dx42 = f42 + G4 * u4 + z;

    dvdt = [dx11; dx12; dx21; dx22; dx31; dx32; dx41; dx42;];
    
end
