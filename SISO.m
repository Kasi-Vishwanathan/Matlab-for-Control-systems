num = 1;
den = [1 3 2];
H = tf(num,den);
disp(H)
figure;
step(H);
title('Step response of H');
figure;
bode(H);
title('Bode plot of H');
figure;
nyquist(H);
title('Nyquist plot of H');
figure;
rlocus(H)
title('Root locus of H')
Kp = 1;
Ki = 1;
Kd = 1;
c = pid(Kp,Ki,Kd);
cl = feedback(c*H,1);
figure;
step(cl)
title('Step response of closed loop system ')
disp(cl);