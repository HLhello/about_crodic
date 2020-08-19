clc
clear
close all
%% settings
%% %%%%%%%%%%%%%%%%%%%%%%%%%%
iter = 16;          % 迭代次数
digits(10);         % 有效数字
tt = -pi/2: pi/100 : pi/2;          % 求解角度
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initial memory
%% %%%%%%%%%%%%%%%%%%%%%%%%%%
xthetax = zeros(iter,1);                 % 每次旋转的角度
Kx = zeros(iter+1, 1); Kx(1,1) = 1;      % 模长补偿因子
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% calculation LUT
%% %%%%%%%%%%%%%%%%%%%%%%%%%
for ii = 1:1:iter
    ind = 2^(-(ii-1));
    xthetax(ii) = atan(ind);
    Kx(ii+1) = Kx(ii) * cos(xthetax(ii));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% calculation cos and sin
%% %%%%%%%%%%%%%%%%%%%%%%%%%
init_x = vpa(Kx(end));  % 初始模长
% cosa = zeros(length(tt),1);
% sina = zeros(length(tt),1);
% za   = zeros(length(tt),1);
% for ii = 1:1:length(tt)
%     [ cosa(ii),sina(ii),za(ii) ] = xcrodic( iter, init_x, tt(ii), xthetax);
% end
% xysqrt = zeros(1001,1);
% err = zeros(1001,1);
% arctanx = zeros(1001,1);
% for ii = -500:1:500
%     [ xysqrt(ii+501),err(ii+501),arctanx(ii+501) ] = ycrodic( iter, 10, ii, init_x, xthetax);
% end
a0 = zcordic(5, 5, 0.3, 0, iter)
a1 = zcordic(5, 2, 5  , 1, iter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% subplot(131), plot(xysqrt), title('xysqrt');
% subplot(132), plot(err), title('err');
% subplot(133), plot(arctanx), title('arctanx');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% end file



