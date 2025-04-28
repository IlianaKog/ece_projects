function[x_star] = DixotomosDer(ao,bo,f)
    lamda = 10^-2;
    a1 = ao;
    b1 = bo;
    counter_n=0;

    i = 0;
    while (1/2)^i>lamda/(b1-a1)
         i = i+1;
    end
    n = i;

    %syms x
    %f(x) = (x-2)^2 + x*log(x+3);
    %f(x) = 5^x + (2-cos(x))^2;
    %f(x) = exp(x)*(x^3-1) + (x-1)*sin(x);

    a = zeros(1,n+1);
    b = zeros(1,n+1);
    x=zeros(1,n);
    x_star = zeros(1,2);

    k=1;
    a(k) = a1;
    b(k) = b1;

    while 1
        x(k) = (a(k)+b(k))/2;
        Df = diff(f);
        counter_n = counter_n+1;
        if Df(x(k)) == 0
            x_star(1,:) = [x(k) x(k)];
            break;
        elseif Df(x(k))>0
            a(k+1) = a(k);
            b(k+1) = x(k);
            if k==n
                x_star(1,:) = [a(n+1) b(n+1)];
                break;
            else
                k=k+1;
            end   
        else
            a(k+1) = x(k);
            b(k+1) = b(k); 
            if k==n
                x_star(1,:) = [a(n+1) b(n+1)];
                break;
            else
                k=k+1;
            end  
        end
    end
end