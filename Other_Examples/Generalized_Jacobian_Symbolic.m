% Create the jacobian

syms x1 x2 x3 x4 x5 x6 x7 x8
syms y1 y2 y3 y4 y5 y6 y7 y8
syms z1 z2 z3 z4 z5 z6 z7 z8
syms t1 t2 t3 t4 t5 t6 t7 t8
syms r k 

Theta = [t1, t2, t3, t4, t5, t6, t7, t8];


x1 = sym(1/sqrt(3)*[1;1;1]   );
x2 = sym(1/sqrt(3)*[-1;1;1]  );
x3 = sym(1/sqrt(3)*[-1;-1;1] );
x4 = sym(1/sqrt(3)*[1;-1;1]  );
x5 = sym(1/sqrt(3)*[1;1;-1]  );
x6 = sym(1/sqrt(3)*[-1;1;-1] );
x7 = sym(1/sqrt(3)*[-1;-1;-1]);
x8 = sym(1/sqrt(3)*[1;-1;-1] );

y1 = sym(1/sqrt(6)*[-1;-1;2]  ); % define 8 body frames attached to actuators
y2 = sym(1/sqrt(6)*[1;-1;2]   );
y3 = sym(1/sqrt(6)*[1;1;2]    );
y4 = sym(1/sqrt(6)*[-1;1;2]   );
y5 = sym(1/sqrt(6)*[-1;-1;-2] );
y6 = sym(1/sqrt(6)*[1;-1;-2]  );
y7 = sym(1/sqrt(6)*[1;1;-2]   );
y8 = sym(1/sqrt(6)*[-1;1;-2]  );

z1 = cross(x1,y1);
z2 = cross(x2,y2);
z3 = cross(x3,y3);
z4 = cross(x4,y4);
z5 = cross(x5,y5);
z6 = cross(x6,y6);
z7 = cross(x7,y7);
z8 = cross(x8,y8);

I_R_B1 = [x1 y1 z1]; %any vecotor in actuator body frame if you post multiplied you get its expression inertial frame
I_R_B2 = [x2 y2 z2];
I_R_B3 = [x3 y3 z3];
I_R_B4 = [x4 y4 z4];
I_R_B5 = [x5 y5 z5];
I_R_B6 = [x6 y6 z6];
I_R_B7 = [x7 y7 z7];
I_R_B8 = [x8 y8 z8];

Fp1 = I_R_B1 * [1 0 0; 0 cos(Theta(1)) -sin(Theta(1)); 0 sin(Theta(1)) cos(Theta(1))] * [0;1;0]; %Fp1 are the epxression of the prop forces in the inertial frame
Fp2 = I_R_B2 * [1 0 0; 0 cos(Theta(2)) -sin(Theta(2)); 0 sin(Theta(2)) cos(Theta(2))] * [0;1;0];
Fp3 = I_R_B3 * [1 0 0; 0 cos(Theta(3)) -sin(Theta(3)); 0 sin(Theta(3)) cos(Theta(3))] * [0;1;0];
Fp4 = I_R_B4 * [1 0 0; 0 cos(Theta(4)) -sin(Theta(4)); 0 sin(Theta(4)) cos(Theta(4))] * [0;1;0];
Fp5 = I_R_B5 * [1 0 0; 0 cos(Theta(5)) -sin(Theta(5)); 0 sin(Theta(5)) cos(Theta(5))] * [0;1;0];
Fp6 = I_R_B6 * [1 0 0; 0 cos(Theta(6)) -sin(Theta(6)); 0 sin(Theta(6)) cos(Theta(6))] * [0;1;0];
Fp7 = I_R_B7 * [1 0 0; 0 cos(Theta(7)) -sin(Theta(7)); 0 sin(Theta(7)) cos(Theta(7))] * [0;1;0];
Fp8 = I_R_B8 * [1 0 0; 0 cos(Theta(8)) -sin(Theta(8)); 0 sin(Theta(8)) cos(Theta(8))] * [0;1;0];

F_t = [Fp1 Fp2 Fp3 Fp4 Fp5 Fp6 Fp7 Fp8]; % 3 by 8 matrix

K = sym(1*[1,1,1,1,-1,-1,-1,-1]*k);
R = sym(r/sqrt(3)*[ 1,1,1; -1,1,1; -1,-1,1; 1,-1,1; 1,1,-1; -1,1,-1; -1,-1,-1; 1,-1,-1]);
for i=1:8
    M_t(:,i) = K(i)*F_t(:,i) + (cross(R(i,:), F_t(:,i))).';
end
Jac = [F_t; M_t]; % 6 by 8 matrix

disp(Jac);