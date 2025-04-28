close all;
clear all;

carfis = newfis('carfis','mamdani');

% add the 3 inputs
carfis = addvar(carfis,'input','dV',[0 1]);
carfis=addmf(carfis,'input',1,'VS','trimf',[-0.25 0 0.25]);
carfis=addmf(carfis,'input',1,'S','trimf',[0 0.25 0.5]);
carfis=addmf(carfis,'input',1,'M','trimf',[0.25 0.5 0.75]);
carfis=addmf(carfis,'input',1,'L','trimf',[0.5 0.75 1]);
carfis=addmf(carfis,'input',1,'VL','trimf',[0.75 1 1.25]);

carfis=addvar(carfis,'input','dH', [0 1]);
carfis=addmf(carfis,'input',2, 'VS','trimf',[-0.25 0 0.25]);
carfis=addmf(carfis,'input',2,'S','trimf',[0 0.25 0.5]);
carfis=addmf(carfis,'input',2,'M','trimf',[0.25 0.5 0.75]);
carfis=addmf(carfis,'input',2,'L','trimf',[0.5 0.75 1]);
carfis=addmf(carfis,'input',2,'VL','trimf',[0.75 1 1.25]);

carfis=addvar(carfis,'input','theta', [-180 180]);
carfis=addmf(carfis,'input',3,'NL','trimf',[-270 -180 -90]);
carfis=addmf(carfis,'input',3,'NS','trimf',[-180 -90 0]);
carfis=addmf(carfis,'input',3,'ZE','trimf',[-90 0 90]);
carfis=addmf(carfis,'input',3,'PS','trimf',[0 90 180]);
carfis=addmf(carfis,'input',3,'PL','trimf',[90 180 270]);

% add the one output
carfis=addvar(carfis,'output','dtheta',[-130 130]);
carfis=addmf(carfis,'output',1,'NL','trimf',[-195 -130 -65]);
carfis=addmf(carfis,'output',1,'NS','trimf',[-130 -65 0]);
carfis=addmf(carfis,'output',1,'ZE','trimf',[-65 0 65]);
carfis=addmf(carfis,'output',1,'PS','trimf',[0 65 130]);
carfis=addmf(carfis,'output',1,'PL','trimf',[65 130 195]);

%% Add Fuzzy Rule Base

ruleList=[
0 5 3 3 1 1;
0 5 4 2 1 1;
0 5 5 1 1 1;
0 5 1 5 1 1;
0 5 2 4 1 1;
0 1 3 4 1 1;
0 1 4 3 1 1; 
0 2 4 3 1 1;
0 2 2 3 1 1;

1 5 3 4 1 1;
2 5 3 3 1 1;
3 5 3 3 1 1;
4 5 3 3 1 1;
5 5 3 5 1 1;

1 4 3 4 1 1;
2 4 3 3 1 1;
3 4 3 3 1 1;
4 4 3 3 1 1;
5 4 3 5 1 1;

];

carfis = addrule(carfis, ruleList);

writefis(carfis, 'car.fis');
fis = readfis('car.fis');

k = 1;
x(1) = 3.8;
y(1) = 0.5;
theta(1) = 0; %select 0, +45, -45
u = 0.05;

x_desired = 10;
y_desired = 3.2;

while(abs(x(k) - x_desired) > 0.05)
    % measurements
    dH(k) = sensor_measure_H(x(k), y(k));
    dV(k) = sensor_measure_V(x(k), y(k)); 

    %find current error
    error_x(k) = x(k) - x_desired;
    error_y(k) = y(k) - y_desired;

    % take output of FLC
    dtheta(k) = evalfis([dV(k), dH(k), theta(k)], fis);

    %calc new theta
    theta(k + 1) = theta(k) + dtheta(k);

    %calc next position (x,y)
    x(k + 1) = x(k) + u * cosd(theta(k+1));
    y(k + 1) = y(k) + u * sind(theta(k+1));
    
    k = k + 1;
end

% figure();
% plot(1:k, theta);
% figure();
% plot(1:k-1, dtheta);
% figure();
% plot(1:k-1, dV);
% figure();
% plot(1:k-1, dH);

figure();
obstacles = [5,0; 5,1; 6,1; 6,2 ; 7,2; 7,3; 10,3];
plot(obstacles(:,1), obstacles(:,2), 'red');
hold on;
plot(x,y,'blue');
hold on;
xlabel("x");
ylabel("y");
titlos = "theta(0): " + theta(1);
title(titlos);


function dH = sensor_measure_H(x, y)
    if y <= 1
        dH = 5 - x;

    elseif y <= 2
        dH = 6 - x;

    elseif y <= 3
        dH = 7 - x;

    else
        dH = 1; 
    end
    
    if dH>1
        dH = 1;
    end
    if dH<0
        dH = 0;
    end

end

function dV = sensor_measure_V(x, y)
    if x <= 5
        dV = y - 0;
        
    elseif  x <= 6
        dV = y - 1;
        
    elseif x <= 7
        dV = y - 2 ;
    else
        dV = y - 3; 
    end   

    if dV>1
        dV = 1;
    end
    if dV<0
        dV = 0;
    end
end

