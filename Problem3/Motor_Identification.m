dataAvg = load('motor_identification.mat'); %Load data
dataAvg = dataAvg.dataAvg

A = [abs(dataAvg(1:10, 3)) sqrt(abs(dataAvg(1:10, 3))) ones(10,1)];
b = abs(dataAvg(1:10, 15).*dataAvg(1:10,7));

x = pinv(A)*b;

% Plot data
figure;

hold on;
fit_x = 0:0.02:6;
fit_y = (fit_x*x(1) + sqrt(fit_x)*x(2)+x(3)); %Calculate model based on the fitted parameters

plot(abs(dataAvg(1:10, 3)), b, 'or'); %Plot original Data points
plot(fit_x, fit_y); %Plot fitted model

xlabel('Force (N)');
ylabel('Vbat * PWM');
legend('Experimental Data', 'Model');
title('Motor Identification')
hold off;

