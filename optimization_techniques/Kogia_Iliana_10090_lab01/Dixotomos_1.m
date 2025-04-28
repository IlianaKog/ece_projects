function [a_table,b_table,counter_n,x_star] = Dixotomos_1(epsilon,lamda,f)
%epsilon = 0.001;
%lamda = 0.01;

a1 = -1;
b1 = 3;
counter_n = 0;

a = zeros(1,100);
b = zeros(1,100);
x1=zeros(1,100);
x2=zeros(1,100);
x_star = zeros(1,2);

k=1;
a(k) = a1;
b(k) = b1;
x1(k) = ((a(k)+b(k))/2)-epsilon;
x2(k) = ((a(k)+b(k))/2)+epsilon;

while 1
    if b(k)-a(k) <= lamda
        x_star(1,:) = [a(k) b(k)];
        break;
    else 
        x1(k) = ((a(k)+b(k))/2)-epsilon;
        x2(k) = ((a(k)+b(k))/2)+epsilon;
        if f(x1(k))<= f(x2(k))
            a(k+1) = a(k);
            b(k+1) = x2(k);
            counter_n = counter_n+2;
        else
            a(k+1) = x1(k);
            b(k+1) = b(k);
            counter_n = counter_n+2;
        end
    end
      k=k+1;
end
a_table = a(1,[1:k]);
b_table = b(1,[1:k]);
end
