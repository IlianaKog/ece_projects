function [a_table, b_table, counter_n, x_star] = Golden(lamda,f)
    %lamda = 0.0001;
    g = 0.618;
    a1 = -1;
    b1 = 3;
    counter_n =1;
    
    %syms x
    %f(x) = (x-2)^2 + x*log(x+3);
    %f(x) = 5^x + (2-cos(x))^2;
    %f(x) = exp(x)*(x^3-1) + (x-1)*sin(x);

    a = zeros(1,100);
    b = zeros(1,100);

    x_star = zeros(1,2);
    x1 = zeros(1,100);
    x2 = zeros(1,100);
    
    k=1;
    a(1,k) = a1;
    b(1,k) = b1;
    x1(1) = a(1)+(1-g)*(b(1,1)-a(1,1));
    x2(1) = a(1) + g*(b(1,1)-a(1,1));
    
    while 1
        if b(k)-a(k)<lamda
            x_star(1,:) = [a(k) b(k)];
            break
        end
        if f(x1(k)) > f(x2(k))
             a(k+1) = x1(k);
             b(k+1) = b(k);
             x1(k+1) = x2(k);
             x2(k+1) = a(k+1)+g*(b(k+1)-a(k+1));
             counter_n = counter_n+1;
         else
             a(k+1) = a(k);
             b(k+1) = x2(k);
             x2(k+1) = x1(k);
             x1(k+1) = a(k+1)+(1-g)*(b(k+1)-a(k+1));
             counter_n = counter_n+1;
        end
        k = k+1;
    end
   a_table = a(1,[1:k]);
   b_table = b(1,[1:k]);
end