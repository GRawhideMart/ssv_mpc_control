model SSVDDVFeedbackLinearization
  SSVKinematic kinematicModel;
  DDVFeedbackLinearization ddvFL;
  
  parameter Real v_xP = 1.0;
  parameter Real v_yP = 0.0;
  
equation
  // Feed the setpoint velocities to DDV Feedback Linearization
  ddvFL.vx_P = v_xP;
  ddvFL.vy_P = v_yP;
  
  // Connect the outputs of DDV Feedback Linearization with the inputs of the kinematic model
  kinematicModel.v_long = ddvFL.v_long;
  kinematicModel.omega = ddvFL.omega;
  
  // Ensure theta is consistent between models
  ddvFL.theta = kinematicModel.theta;

end SSVDDVFeedbackLinearization;
