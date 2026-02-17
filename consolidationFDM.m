clc
clear
close all

L  = 3;              
n  = 3;             
Cv = 1e-6;           

dz = L/n;            
dt = 1e5;            
nt = 20;             

u0 = 100;            

z = linspace(0,L,n+1);

r = Cv*dt/(dz^2);

if r > 0.5
    error('Time step too large! Reduce dt for stability.')
end

u = u0*ones(n+1,1);
u(1) = 0;             

for t = 1:nt
    
    u_old = u;
    
    for i = 2:n      
        u(i) = u_old(i) + r*(u_old(i+1) - 2*u_old(i) + u_old(i-1));
    end
    
    u(1) = 0;                        % Top drained
    u(n+1) = u(n);                   % Bottom impermeable
    
end

disp('Final pore pressure distribution:')
disp(u)

figure
plot(u,z,'-o','LineWidth',2)
set(gca,'YDir','reverse')
xlabel('Excess Pore Pressure (kPa)')
ylabel('Depth (m)')
title('1D Consolidation using FDM')
grid on