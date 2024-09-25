model DDVFeedbackLinearization
  // Parameters
  parameter Real epsilon = 0.25; // Longitudinal distance between point P and robot's frame
  
  // Inputs
  input Real vx_P;
  input Real vy_P;
  input Real theta;
  
  // Outputs
  output Real v_long;
  output Real omega;
  
equation
  v_long = vx_P * cos(theta) + vy_P * sin(theta);
  // This sets a problem: if theta is 0, omega here will always be 0 if the velocity is (1,0). Due to nonholonomic constraint, vy_P is supposed to be 0 at startup, so if theta is also 0 in the kinematic model, this model will not move at all.
  // Possible solution: bias to omega if vy_P = 0?
  omega = (-1/epsilon * sin(theta)) * vx_P + (1/epsilon * cos(theta)) * vy_P;

end DDVFeedbackLinearization;
