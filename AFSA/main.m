X = load("cities.txt");
pos = fmincon('Distance',[104,30],[],[]);
plot(X(:,1),X(:,2),'ro');
grid on;
hold on;
plot(pos(1),pos(2),'b+');