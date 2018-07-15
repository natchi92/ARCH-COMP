function [ChillerDist] = ChillerFunction_contr()
% Case Study

% Parameters 
w = 3;     % zone width
l = 3;     % zone length
h = 2;      % zone height
r = 0.01;               % pipeline radius
A = 2 * pi * r * l;     % surface area
h_copp = 13.1;          % overall cooper transfer coefficient [W/m^2K]
V_el = 10*10^-3;   % chilled water volume (10 liters)
V = V_el;

rho_a = 1.2041;   % air density (20�C) [kg/m^3]
rho_w = 999;   % water density (10�C) [kg/m^3] 
cw_a = 1.012e3;     % specifit heat capacity of air [J/kgK]
cw_w = 4.1813e3;    % specifit heat capacity of water [J/kgK]
Cza = (w * l * h) * rho_a * cw_a;     % zone thermal capacity
Ccw = V * rho_w * cw_w;    % chilled water circuit thermal capacity
kcw = A * h_copp;      % chilled water thermal convection coefficient
kout = 0.25;                      % outside thermal convection coefficient
Toa = 30;        % Nominal outside temperature

% Temperature setpoint
Tset=20;

%%%%%%%%%%%%%%%%%%%%%%

% Timing variables
N=3;
T=15*60; % in seconds
dt=T/N;

dim = 2;
dim_u = 1;

% Variance
VarTA=1/65^2;
VarCW=1/65^2;

% Resulting Sigma matrix
Sigma(1,1)=VarTA*dt;
Sigma(2,2)=VarCW*dt;

% Heat extracted by the coolers. This value balances the systems making
% sure that the total energy in the system remains the same.
Q=kout*(Tset-Toa);


%%%%%%%%%%%
% Creation of the symbolic variables
x='';
xbar='';
for i=1:dim
    eval(['syms',' ','x',num2str(i),' ','real']);
    eval(['syms',' ','x',num2str(i),'bar ','real']);
    x=[x,'x',num2str(i),' '];
    xbar=[xbar,'x',num2str(i),'bar '];
end
if x(end)==' '
    x=x(1:end-1);
end
if xbar(end)==' '
    xbar=xbar(1:end-1);
end

u='';
for i=1:dim_u
    eval(['syms',' ','u',num2str(i),' ','real'])
    u=[u,'u',num2str(i),' '];
end
if u(end)==' '
    u=u(1:end-1);
end

% Creation of the vectors of symbolic variables
x_mat=eval(['[',x,']','''']);
xbar_mat=eval(['[',xbar,']','''']);
u_mat=eval(['[',u,']','''']);


%%%%%% Symbolic Density Function of the Case Study %%%%%%%%%%%%%

% Definition of the expected value of the next state
% This is according to the dynamical equations of the room temperature.
E_xbar(1)=x1+(dt/Cza)*u1*kcw*(x2-x1)+(dt/Cza)*kout*(Toa-x1); % Room Temperature
E_xbar(2)=x2+(dt/Ccw)*u1*kcw*(x1-x2)+Q*dt/Ccw; % Chilled Water Temperature

E_xbar=E_xbar';

% Creation of the normal distribution
mat=-0.5*(xbar_mat-E_xbar)'*Sigma^(-1)*(xbar_mat-E_xbar); % Matrix multiplication of the part inside the exponent of the normal distribution
ChillerDist=sqrt((2*pi)^dim*det(Sigma))^-1*exp(mat); % The normal distribution
ChillerDist=eval(['matlabFunction(ChillerDist,''vars'',[',x,' ',xbar,' ',u,'])']); % reordening the variables and creation of the symbolic function.
end

