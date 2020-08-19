function a = zcordic(init_x,init_y,init_z,mode,iter)
% calculation xz(mode = 0 ) or y/x(mode = 1)

x = zeros(iter+1,1); x(1) = init_x;
y = zeros(iter+1,1); y(1) = init_y;
z = zeros(iter+1,1); z(1) = init_z;
di = 0;
for k=1:iter
	if mode==0
		di = sign(z(k));
	else
		di = sign(-y(k));
	end
	x(k+1)= x(k);
	y(k+1)= y(k)+x(k)*di*2^(-k);
	z(k+1)= z(k)-di*2^(-k);
end
xn = x(iter+1);
yn = y(iter+1);
zn = z(iter+1);
if mode==0
	xt = init_x;
	yt = init_y+init_x*init_z;
	zt = 0;
else
	xt = init_x;
	yt = 0;
	zt = init_z+init_y/init_x;
end
a =[xn,xt,yn,yt,zn,zt];
