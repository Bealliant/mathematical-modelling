obj = [];
for k=0:100
temp = fun3(k/100,solv(k+1,:)');
obj = [obj,temp];
end
plot(0:0.01:1,obj);
set(gcf,'unit','centimeters','position',[19 -5 50 20]);
xlabel("lambda");
ylabel("目标函数");
title("目标函数值随lambda变化");