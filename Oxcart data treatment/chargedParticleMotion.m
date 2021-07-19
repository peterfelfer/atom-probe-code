function [loc, t] = chargedParticleMotion(initialPosition, initialVelocity, electricField, particleMassToChargeState)

% particleMassToChargeState in Da

%@ Initialize variables (e.g., electric and magnetic fields)

magneticField = [0 0 0];       %  no magnetic Field considered

dt = 1e-9;             % Time step (sec)
%mass = 9.10939e-31;     % Mass of electron (kg)
protonMass = 1.660539e-27;    % Da to kg
elementaryCharge = 1.602177e-19;       % elementary charge [C]
particleMassToCharge = elementaryCharge/(particleMassToChargeState * protonMass);

%@ Set up for plotting the electron's motion
clf;  figure(gcf);    % Clear figure window and bring it forward
plot(0,0,'bo');       % Mark the origin with a blue circle
XMax = 1.0e-11;  XMin = -XMax;   % Axis limits
YMin = XMin;     YMax = XMax;       
axis([XMin, XMax, YMin, YMax]);
grid on;              % Place a hash grid on the graph
xlabel('x (m)');      % X-axis label
ylabel('y (m)');      % Y-axis label
title('Computing motion ...');
hold on;              % Hold the graph on the screen as points are added
%@ Loop over time steps to compute the motion


time = 0.0;
nstep = 1000;
for istep=1:nstep
  %@ Compute acceleration on electron as a = q/m (E + v X B)
  v_cross_B = [ (initialVelocity(2)*magneticField(3)-magneticField(2)*initialVelocity(3)) ...
               -(initialVelocity(1)*magneticField(3)-magneticField(1)*initialVelocity(3)) ...
                (initialVelocity(1)*magneticField(2)-magneticField(1)*initialVelocity(2)) ];
  accel = particleMassToCharge * (electricField + v_cross_B);
  
  %@ Calculate new position and velocity using Euler-Cromer
  initialVelocity = initialVelocity + dt*accel;     % Update the velocity
  initialPosition = initialPosition + dt*initialVelocity;         % Update the position
  loc(istep,:) = initialPosition;
  time = time + dt;     % Increment the time
  t(istep) = time;
  
  %@ Add data point to graph; expand axis limits if needed
  plot(initialPosition(1),initialPosition(2),'.','EraseMode','none');
  if( initialPosition(1) > XMax )       % If position is outside axis limits
    XMax = 2*XMax;        % then increase limits
	axis([XMin, XMax, YMin, YMax]);
  elseif( initialPosition(1) < XMin )   % If position is outside axis limits
    XMin = 2*XMin;        % then increase limits
	axis([XMin, XMax, YMin, YMax]);
  elseif( initialPosition(2) > YMax )   % If position is outside axis limits
    YMax = 2*YMax;        % then increase limits
	axis([XMin, XMax, YMin, YMax]);
  elseif( initialPosition(2) < YMin )   % If position is outside axis limits
    YMin = 2*YMin;        % then increase limits
	axis([XMin, XMax, YMin, YMax]);
  end
  drawnow;   % Redraw the graph
   
end
% Write final title to show that calculation is complete
title(sprintf('Motion of an electron for %g seconds',time));
