function [ xysqrt,err,arctanx ] = ycrodic( iter, init_x, init_y, kn, xthetax)
% calculation arctan(init_y/init_x) and sqrt(init_x^2 + init_y^2)
x = zeros(iter+1,1); x(1) = init_x;
y = zeros(iter+1,1); y(1) = init_y;
z = zeros(iter+1,1); z(1) = 0;

for ii = 1:1:iter
    if y(ii) >= 0
        d = -1;
    else
        d = 1;
    end
    x(ii+1) = x(ii) - d*y(ii)*(2^(-(ii-1)));
    y(ii+1) = y(ii) + d*x(ii)*(2^(-(ii-1)));
    z(ii+1) = z(ii) - d*xthetax(ii);
end

xysqrt = vpa(x(17)*kn, 10);
err = vpa(y(17), 10);
arctanx = vpa(z(17), 10);




end

