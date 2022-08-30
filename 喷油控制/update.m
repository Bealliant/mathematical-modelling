
%% function update
% 用于根据上一个时刻的m来计算此时的m,并对于rho和p进行一次更新
% 注意m rho p为全局变量
function [] = update(step,inPeriod)
   global rho p m V t;
   t2 = mod(t,inPeriod+10);
   temp_in_m = integral(@(x)in_Flow(x,inPeriod),t,t+step,'ArrayValued',true) .* p2rho(160);
   temp_out_m = integral(@out_Flow,t,t+step,'ArrayValued',true).*rho;
   m = m + temp_in_m - temp_out_m;
   rho = m./V;
   p = rho2p(rho);
   t = t + step;
end

%% function rho2p.m
% 用于从已知的rho(mg mm^-3)倒推出tank之中的液压力(Mpa)
function y = rho2p(rho)
    load fittedmodel;
    y = fittedmodel(rho);
end
%% function p2rho.m
% 根据拟合之后的结果（参数），用于实现从p(Mpa)到rho(mg mm^-3)的转换
function y = p2rho(p)
    w = 8.511e-4;
    a1 = 1.766;
    b1 = 0.6126;
    c = -0.9617;
    y = a1.*cos(w*p)+b1.*sin(w*p)+c;
end
%% function in_Flow.m
% 计算输入t ms时刻时候的输入水流量
function y=in_Flow(t,in_time)
    global  p p_out C s_in;
    Period = in_time + 10;
    temp_t = mod(t,Period);
    if temp_t < in_time
        y = C*s_in *sqrt(2*(p_out-p)/p2rho(p_out));
    else
        y = 0;
   end
end
%% function out_Flow
% 计算输出 t ms时刻的输出水流量
function y = out_Flow(l)
    T_out = 100;
    temp_t = mod(l,T_out);
    y = max(-50*abs(temp_t-0.2)-50*abs(temp_t-2.2)+120,0);
end