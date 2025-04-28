close all;
clear all;

syms x
f(x) = (x-2)^2 + x*log(x+3);
%f(x) = 5^x + (2-cos(x))^2;
%f(x) = exp(x)*(x^3-1) + (x-1)*sin(x);
x_star = zeros(4,2);
sxima =1;
i=1;
for lamda = [0.1 0.01 0.003 0.0023]
    epsilon =0.001;
    [Ak Bk n x_star(i,:)] = Dixotomos_1(epsilon,lamda,f);
    i=i+1;
    figure(sxima);
    title(['epsilon = ',num2str(epsilon),',  l = ',num2str(lamda)]);
    xlabel('k');
    hold on;
    ylabel('a_k');
    hold on;
    plot(Ak,'-o','Color','r');

    figure(sxima+1);
    title(['epsilon = ',num2str(epsilon),',  l = ',num2str(lamda)]);
    xlabel('k');
    hold on;
    ylabel('b_k');
    hold on;
    plot(Bk,'-o');
    sxima = sxima+2;
end
N = zeros(1,8);
l = zeros(1,8);
j=1;
for lamda = [0.1 0.07 0.05 0.01 0.007 0.005 0.003 0.0023]
    epsilon = 0.001;
    [Ak Bk n] = Dixotomos_1(epsilon,lamda,f);
    N(j) = n;
    l(j) = lamda;
    j=j+1;
end
figure(sxima);
plot(l,N,'-o');
xlabel('lamda');
ylabel('f calls');

sxima = sxima+1;
C = zeros(1,5);
e = zeros(1,5);
j=1;
for epsilon = [10^-3 5*10^-4 10^-4 10^-5 10^-6]
    lamda = 0.01;
    [Ak Bk n] = Dixotomos_1(epsilon,lamda,f);
    C(j) = n;
    e(j) = epsilon;
    j=j+1;
end
figure(sxima);
plot(e,C,'-o');
xlabel('epsilon');
ylabel('f calls');

