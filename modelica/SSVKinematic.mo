model SSVKinematic
  // Track width
  parameter Real d = 0.5;
  
  // Inputs
  // The following are all supposed to be injected in the kinematic model by the control system. Skipping it for now
  //input Real v_R;
  //input Real v_L;
  //input Real s_R;
  //input Real s_L;
  
  parameter Real v_R = 0.9;
  parameter Real v_L = 0.1;
  parameter Real s_R = 0;
  parameter Real s_L = 0;
  
  // States
  Real x(start=0);
  Real y(start=0);
  Real theta(start=0);
    
  equation
    der(x) = ((1-s_R)/2 * cos(theta) * v_R) + ((1-s_L)/2 * cos(theta) * v_L);
    der(y) = ((1-s_R)/2 * sin(theta) * v_R) + ((1-s_L)/2 * sin(theta) * v_L);
    der(theta) = (1-s_R)/(2*d)*v_R - (1-s_L)/(2*d)*v_L;
    

end SSVKinematic;
