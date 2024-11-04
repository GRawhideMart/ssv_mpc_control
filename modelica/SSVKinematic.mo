model SSVKinematic
  // Track width
  parameter Real d = 0.5;
  
  // The following are all supposed to be injected in the kinematic model by the control system. Skipping it for now
  //input Real s_R;
  //input Real s_L;
  Real s_R = 0.25;
  Real s_L = 0.25;
  
  // An important remark is that typically in a model we don't have the side velocities, but the longitudinal velocity of the vehicle and the angular velocity of it, with respect to its frame.
  
  // In general, v_R = v_long + d*omega, v_L = v_long - d*omega. This is tricky because I need to calculate omega, to calculate the input.
  
  // Inputs
  input Real v_long; // Longitudinal velocity
  input Real omega; // Angular velocity
  
  // Wheel velocities
  Real v_R;
  Real v_L;
  
  // States
  Real x(start=0);
  Real y(start=0);
  Real theta(start=0);
    
  equation
    // Calculate wheel velocities based on feedback linearization inputs
    v_R = v_long + d*omega;
    v_L = v_long - d*omega;
    
    // Kinematic equations for an SSV
    der(x) = ((1-s_R)/2 * cos(theta) * v_R) + ((1-s_L)/2 * cos(theta) * v_L);
    der(y) = ((1-s_R)/2 * sin(theta) * v_R) + ((1-s_L)/2 * sin(theta) * v_L);
    der(theta) = (1-s_R)/(2*d)*v_R - (1-s_L)/(2*d)*v_L;
    
end SSVKinematic;
