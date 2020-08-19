% /*
% * @Author: ZLK
% * @Date:   2018-10-30 16:30:42
% * @Last Modified by:   ZLK
% * @Last Modified time: 2018-10-30 16:55:58
% */
function [xn,yn,zn]=cordic_cp_post(x0,y0,z0,xnp,ynp,znp,mode)
% mode : 0 : rotation; else vectoring
theta = 0;
if mode==1
	if x0>=0 && y0>=0
		theta = znp;
	elseif x0<0 && y0>=0
		theta = pi - znp;
	elseif x0<0 && y0<=0
		theta = znp - pi;
	elseif x0>0 && y0<0
		theta = -znp;
	end
		xn = xnp;
		yn = ynp;
		zn = z0 + theta;
else
	xn=xnp;
	yn = ynp;
	zn = znp;
end
