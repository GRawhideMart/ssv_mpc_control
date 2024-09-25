model SSVDDVFeedbackLinearization
  SSVKinematic kinematicModel;
  DDVFeedbackLinearization ddvFL;
  
  //parameter Real v_xP = 1.0;
  //parameter Real v_yP = 0.0;
  Real v_xP;
  Real v_yP;
  
  parameter Real A = 1.0;
  parameter Real B = 1.0;
  parameter Real ome = 3.14;
  
equation
  v_xP = A*ome*cos(ome*time);
  v_yP = B*2*ome*cos(2*ome*time);
  
  // Feed the setpoint velocities to DDV Feedback Linearization
  ddvFL.vx_P = v_xP;
  ddvFL.vy_P = v_yP;
 
  // Connect the outputs of DDV Feedback Linearization with the inputs of the kinematic model
  kinematicModel.v_long = ddvFL.v_long;
  kinematicModel.omega = ddvFL.omega;
  
  // Ensure theta is consistent between models
  ddvFL.theta = kinematicModel.theta;

end SSVDDVFeedbackLinearization;
