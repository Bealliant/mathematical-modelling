figure;
subplot(3,1,1);
l =0:0.01:1;
plot(0:0.01:1,solv(:,1));
title("lambda- 第一种证券")
xlabel("lambda");

subplot(3,1,2); 
y2 = solv(:,2);
plot(l,y2);
title("lambda- 第二种证券")
xlabel("lambda");

subplot(3,1,3); 
y3 = solv(:,3);
plot(l,y3)
title("lambda- 第三种证券")
xlabel("lambda");
