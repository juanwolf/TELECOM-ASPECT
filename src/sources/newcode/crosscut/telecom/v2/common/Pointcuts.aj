package telecom.v2.common;

public aspect Pointcuts {
	
    public pointcut inDomain() :
        within(telecom.v2.connect.*) || within(telecom.v2.simulate.*);
    
    public pointcut inTracing() :
    	within(telecom.v2.trace.*);
    
    public pointcut inTestsFunctions() :
    	withincode(void telecom.v2.simulate.Simulation.runTest*(..));
    
    /**
     * TODO
     */
    public pointcut callStateChangedInDropped() :
    	withincode(* telecom.v2.connect.Call.hangUp(..)) && (call(* *.get(..)) || call(* *.remove(..))); 
    
    /**
     * TODO
     */
    public pointcut callStateChangedInCompleted() :
    	withincode(* telecom.v2.connect.Call.pickUp(..)) && call(* *.remove(..));
   
    public pointcut simulationExecution() :
    		execution(void telecom.v2.simulate.Simulation.run(..));
    
    public pointcut testsCall() :
    	call(void telecom.v2.simulate.Simulation.runTest*(..)); 
    
    public pointcut customerCall() : 
		call(* telecom.v2.connect.ICustomer.call(..));
    
    public pointcut customerHangUp() :
		call(void telecom.v2.connect.IC*.hangUp(..));
	
	public pointcut customerPickUp() :
		call(void telecom.v2.connect.IC*.pickUp(..));
	
	public pointcut callInvite():
		call(void telecom.v2.connect.IC*.invite(..));
	
	public pointcut connectionChangedState() :
		set(* telecom.v2.connect.Connection.state);
	
	public pointcut getCall() :
		call(* *.getCall(..));

	
}
