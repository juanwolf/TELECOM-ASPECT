package telecom.v2.trace;

import java.util.HashMap;
import java.util.Map;

import telecom.v2.connect.Call;
import telecom.v2.connect.ICustomer;
import telecom.v2.time.Timer;

public aspect TimeTracing {
    
    private Map<ICustomer, Timer> Call.timers = new HashMap<ICustomer, Timer>();
    
    public Timer Call.getTimer(ICustomer c) {
    	return timers.get(c);
    }
    
    public void Call.addTimer(ICustomer c, Timer t) {
    	timers.put(c, t);
    }
    
    private pointcut callinitialization() :
    	initialization(telecom.v2.connect.Call.new(..));
    
    after(Call c) : callinitialization() && this(c) {
    	c.timers = new HashMap<ICustomer, Timer>();
    }
    
    private pointcut dropCall() :
    	withincode(* telecom.v2.connect.Call.hangUp(..)) && (call(* *.get(..)) || call(* *.remove(..))); 
    
    private pointcut completecall() :
    	withincode(* telecom.v2.connect.Call.pickUp(..)) && call(* *.remove(..));
   
    
    after(Call ca, ICustomer c) : completecall() && this(ca) && args(c){
    	ca.addTimer(c, new Timer());
    	ca.getTimer(c).start();
    }
    
    after(Call ca, ICustomer c) : dropCall() && this(ca) && args(c) {
    	ca.getTimer(c).stop();
    	Tracer.logPrintln("Temps de connexion : " + ca.getTimer(c).getTime() + " s");
    }

}
