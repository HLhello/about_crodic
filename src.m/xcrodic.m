function [ cosa,sina,za ] = xcrodic( iter, init_x, tt, xthetax)
% calculation cos(tt) and sin(tt)
x = zeros(iter+1,1); x(1) = init_x;
y = zeros(iter+1,1);
z = zeros(iter+1,1); z(1) = tt;

for ii = 1:1:iter
    if z(ii) >= 0
        d = 1;
    else
        d = -1;
    end
    x(ii+1) = x(ii) - d*y(ii)*(2^(-(ii-1)));
    y(ii+1) = y(ii) + d*x(ii)*(2^(-(ii-1)));
    z(ii+1) = z(ii) - d*xthetax(ii);
end

cosa = vpa(x(17),10);
sina = vpa(y(17),10);
za = vpa(z(17),10);
end

