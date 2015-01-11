package telecom.v2.common;

import telecom.v2.unicity.UniqueId;

public aspect Pointcuts {
	
	// LOCALISATION ----------------------------------------------------------------------
	/**
     * Indique que l'action se déroule dans le paquetage connect ou simulate
     */
    public pointcut inDomain() :
        within(telecom.v2.connect.*) || within(telecom.v2.simulate.*);
    /**
     * Indique que l'action se déroule dans le paquetage trace
     */
    public pointcut inTracing() :
    	within(telecom.v2.trace.*);
    
    /**
     * Indique que l'action se déroule dans une fonction runTest de la classe Simulation
     */
    public pointcut inTestsFunctions() :
    	withincode(void telecom.v2.simulate.Simulation.runTest*(..));
    
    //  APPELS -------------------------------------------------------------------------
    /**
     * Repère les changements d'état en 'dropped' d'une connexion
     */
    public pointcut callStateChangedInDropped() :
    	withincode(* telecom.v2.connect.Call.hangUp(..)) && (call(* *.get(..)) || call(* *.remove(..))); 
    
    /**
     * Repère le changement d'état en 'completed' d'un appel.
     */
    public pointcut callStateChangedInCompleted() :
    	withincode(* telecom.v2.connect.Call.pickUp(..)) && call(* *.remove(..));
   /**
    * Répère l'execution du lancement des simulations
    */
    public pointcut simulationExecution() :
    		execution(void telecom.v2.simulate.Simulation.run(..));
    
    /**
     * Repère l'appel d'un fonction de simulation
     */
    public pointcut testsCall() :
    	call(void telecom.v2.simulate.Simulation.runTest*(..)); 
    
    /**
     * Repère l'appel à la fonction d'appel d'un ICustomer
     */
    public pointcut customerCall() : 
		call(* telecom.v2.connect.ICustomer.call(..));
    
    /**
     * Repère l'appel à la fonction 
     */
    public pointcut customerHangUp() :
		call(void telecom.v2.connect.IC*.hangUp(..));
	
    /**
     * Repère l'appel à la fonction d'un ICustomer quand il décroche à un appel
     */
	public pointcut customerPickUp() :
		call(void telecom.v2.connect.IC*.pickUp(..));
	
	/**
	 * Repère l'appel de la fonction d'invitation d'un ICustomer à un appel
	 */
	public pointcut callInvite() :
		call(void telecom.v2.connect.IC*.invite(..));
	
	/**
	 * Repère l'appel de la fonction getCall()
	 */
	public pointcut getCall() :
		call(* *.getCall(..));
	
	// SET -------------------------------------------------------------------------------
	/**
	 * Repère quand l'annotation @UniqueId est utilisée sur un mauvais type
	 */
	public pointcut uniqueIdTypeError() :
		set(@UniqueId (boolean || char || byte || short || int || long || float || double) *.*) && inDomain();
	
	/**
	 *  Repère quand l'annotation @UniqueId est utilisée sur un attribut non final
	 */
	public pointcut uniqueIdFinalError() :
		set(@UniqueId !final * *) && inDomain();
		
	/**
	 * Répère quand une valeur est attribué à un attribut annoté de @UniqueId
	 */
	public pointcut uniqueIdset() :
		set(@UniqueId * *); 
	
	/**
	 * Repère le changement d'état d'une connection
	 */
	public pointcut connectionChangedState() :
		set(* telecom.v2.connect.Connection.state);
	
	// INITIALISATION --------------------------------------------------------------------
	/**
	 * Repère l'instanciation d'un nouvel object Call
	 */
	public pointcut callinitialization() :
    	initialization(telecom.v2.connect.Call.new(..));
	
	

	
}
