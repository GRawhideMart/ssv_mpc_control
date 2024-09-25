model SSVFeedbackLinearization
// Parameters
  parameter Real epsilon = 0.25; // Longitudinal distance between point P and robot's frame
  parameter Real d = 0.5;
  
  // Inputs
  input Real vx_P;
  input Real vy_P;
  input Real theta;
  input Real slip_R;
  input Real slip_L;
  
  // Outputs
  output Real v_long;
  output Real omega;
  
  Real eta_R;
  Real eta_L;
  Real gamma_11;
  Real gamma_12;
  Real gamma_21;
  Real gamma_22;
  
equation
  eta_R = 1-slip_R;
  eta_L = 1-slip_L;
  gamma_11 = (eta_L + eta_R) / 2;
  gamma_12 = (eta_L - eta_R) / 2;
  gamma_21 = (eta_L + eta_R) / d;
  gamma_22 = (eta_L - eta_R) / d;
  
  v_long = 1 / (epsilon*eta_L*eta_R) * ((epsilon*gamma_11*cos(theta)-d*gamma_12*sin(theta)) * vx_P + (epsilon*gamma_11*sin(theta)+d*gamma_12*cos(theta)) * vy_P);
  omega = 1 / (epsilon*eta_L*eta_R) * ((epsilon*gamma_22*cos(theta)-d*gamma_21*sin(theta)) * vx_P + (epsilon*gamma_22*sin(theta)+d*gamma_21*cos(theta)) * vy_P);
  
  
end SSVFeedbackLinearization;
