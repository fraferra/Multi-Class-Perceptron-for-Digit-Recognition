% Research Method / CW5 - F. Ferrari and B. Daullxhiu
clear all
%train= load('../ziptrain.dat'); 
%test= load('../ziptest.dat'); 
train = load('../dtrain123.dat');
test = load('../dtest123.dat');


dd=[1:4];
tableError=zeros(length(dd),1);
sigma=[500, 50, 5, 0.5];

for d=dd
    mistakes=0;
    %call multiclass svm
    output=multisvm(train(:,2:end),train(:,1),test(:,2:end),sigma(d));
    %calculate mistakes
    for i=1:length(output)
        if output(i)~=test(i,1)
            mistakes=mistakes+1;
        end
    end
    mistakes
    tableError(d)=(mistakes/length(test))*100;
end

tableError
figure(1)
cc=[-3 -2 -1 0]
plot(cc,tableError,'--o')
title('Test Error vs c')
xlabel('Log10(c)')
ylabel('Test Error (%)')
grid on

