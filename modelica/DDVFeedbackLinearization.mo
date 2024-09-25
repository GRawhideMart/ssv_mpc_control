model DDVFeedbackLinearization
  // Parameters
  parameter Real epsilon = 0.5; // Longitudinal distance between point P and robot's frame
  
  // Inputs
  input Real vx_P;
  input Real vy_P;
  input Real theta;
  
  // Outputs
  output Real v_long;
  output Real omega;
  
equation
  v_long = vx_P * cos(theta) + vy_P * sin(theta);
  omega = (-1/epsilon * sin(theta)) * vx_P + (1/epsilon * cos(theta)) * vy_P;

end DDVFeedbackLinearization;
