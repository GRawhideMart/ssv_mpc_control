model SSVModelWithFL
  SSVKinematic kinematicModel;
  SSVFeedbackLinearization ssvFL;
  
  Real v_xP;
  Real v_yP;
  
  parameter Real A = 1.0;
  parameter Real B = 1.0;
  parameter Real ome = 3.14;
  
equation
  v_xP = A*ome*cos(ome*time);
  v_yP = B*2*ome*cos(2*ome*time);
  
  // Feed the setpoint velocities to DDV Feedback Linearization
  ssvFL.vx_P = v_xP;
  ssvFL.vy_P = v_yP;
  
  // Connect the outputs of DDV Feedback Linearization with the inputs of the kinematic model
  kinematicModel.v_long = ssvFL.v_long;
  kinematicModel.omega = ssvFL.omega;
  
  // Ensure theta is consistent between models
  ssvFL.theta = kinematicModel.theta;
  ssvFL.slip_R = kinematicModel.s_R;
  ssvFL.slip_L = kinematicModel.s_L;

end SSVModelWithFL;
