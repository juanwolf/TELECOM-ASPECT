package telecom.v2.common;

import telecom.v2.unicity.UniqueId;

public aspect Pointcuts {
	
	// LOCALISATION ----------------------------------------------------------------------
	/**
     * Indique que l'action se d�roule dans le paquetage connect ou simulate
     */
    public pointcut inDomain() :
        within(telecom.v2.connect.*) || within(telecom.v2.simulate.*);
    /**
     * Indique que l'action se d�roule dans le paquetage trace
     */
    public pointcut inTracing() :
    	within(telecom.v2.trace.*);
    
    /**
     * Indique que l'action se d�roule dans une fonction runTest de la classe Simulation
     */
    public pointcut inTestsFunctions() :
    	withincode(void telecom.v2.simulate.Simulation.runTest*(..));
    
    //  APPELS -------------------------------------------------------------------------
    /**
     * Rep�re les changements d'�tat en 'dropped' d'une connexion
     */
    public pointcut callStateChangedInDropped() :
    	withincode(* telecom.v2.connect.Call.hangUp(..)) && (call(* *.get(..)) || call(* *.remove(..))); 
    
    /**
     * Rep�re le changement d'�tat en 'completed' d'un appel.
     */
    public pointcut callStateChangedInCompleted() :
    	withincode(* telecom.v2.connect.Call.pickUp(..)) && call(* *.remove(..));
   /**
    * R�p�re l'execution du lancement des simulations
    */
    public pointcut simulationExecution() :
    		execution(void telecom.v2.simulate.Simulation.run(..));
    
    /**
     * Rep�re l'appel d'un fonction de simulation
     */
    public pointcut testsCall() :
    	call(void telecom.v2.simulate.Simulation.runTest*(..)); 
    
    /**
     * Rep�re l'appel � la fonction d'appel d'un ICustomer
     */
    public pointcut customerCall() : 
		call(* telecom.v2.connect.ICustomer.call(..));
    
    /**
     * Rep�re l'appel � la fonction 
     */
    public pointcut customerHangUp() :
		call(void telecom.v2.connect.IC*.hangUp(..));
	
    /**
     * Rep�re l'appel � la fonction d'un ICustomer quand il d�croche � un appel
     */
	public pointcut customerPickUp() :
		call(void telecom.v2.connect.IC*.pickUp(..));
	
	/**
	 * Rep�re l'appel de la fonction d'invitation d'un ICustomer � un appel
	 */
	public pointcut callInvite() :
		call(void telecom.v2.connect.IC*.invite(..));
	
	/**
	 * Rep�re l'appel de la fonction getCall()
	 */
	public pointcut getCall() :
		call(* *.getCall(..));
	
	// SET -------------------------------------------------------------------------------
	/**
	 * Rep�re quand l'annotation @UniqueId est utilis�e sur un mauvais type
	 */
	public pointcut uniqueIdTypeError() :
		set(@UniqueId (boolean || char || byte || short || int || long || float || double) *.*) && inDomain();
	
	/**
	 *  Rep�re quand l'annotation @UniqueId est utilis�e sur un attribut non final
	 */
	public pointcut uniqueIdFinalError() :
		set(@UniqueId !final * *) && inDomain();
		
	/**
	 * R�p�re quand une valeur est attribu� � un attribut annot� de @UniqueId
	 */
	public pointcut uniqueIdset() :
		set(@UniqueId * *); 
	
	/**
	 * Rep�re le changement d'�tat d'une connection
	 */
	public pointcut connectionChangedState() :
		set(* telecom.v2.connect.Connection.state);
	
	// INITIALISATION --------------------------------------------------------------------
	/**
	 * Rep�re l'instanciation d'un nouvel object Call
	 */
	public pointcut callinitialization() :
    	initialization(telecom.v2.connect.Call.new(..));
	
	

	
}
