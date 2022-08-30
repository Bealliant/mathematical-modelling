x = load("prob2.txt");
price = x(:,2);
volume = x(:,1);

select = intlinprog(-1*price,[1:100],volume',3000,[],[],zeros(100,1),ones(100,1))

