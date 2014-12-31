package telecom.v2.common;

import java.util.Set;

import telecom.v2.connect.Call;
import telecom.v2.connect.Customer;
import telecom.v2.connect.ICall;
import telecom.v2.connect.ICustomer;
import telecom.v2.simulate.Simulation;
import telecom.v2.time.Timer;

public aspect Pointcuts {
	
    public pointcut inDomain() :
        within(telecom.v2.connect.*) || within(telecom.v2.simulate.*);
    
    public pointcut inTracing() :
    	within(telecom.v2.trace.*);

    pointcut duringSimulation() :
        cflowbelow(call(void Simulation.run()));
    
    pointcut unicity() :
        get(static Set<String>+ Customer.UNIQUE_IDS)
        || set(static Set<String>+ Customer.UNIQUE_IDS);
    
    pointcut tracing() :
        call(void java.io.PrintStream.print*(..))
        || call(void say(..))
        || call(void report(..))
        || call(String toString())
        || call(String setToString(..));
    
    pointcut timing() :
        call(* Timer.*(..))
        || call(Timer.new(..))

        || get(Timer telecom.v2.connect.Connection.*)
        || set(Timer telecom.v2.connect.Connection.*)
        || call(int telecom.v2.connect.Connection.getDuration())

        || call(int ICall.getElapsedTimeFor(..))

        || get(int Customer.totalTime)
        || set(int Customer.totalTime)
        || call(int ICustomer.getTotalConnectedTime());
    
    pointcut billing() :
        get(telecom.v2.connect.Connection.Type telecom.v2..Connection.*)
        || set(telecom.v2.connect.Connection.Type telecom.v2..Connection.*)
        || call(int telecom.v2.connect.Connection.getRate())
        || call(int telecom.v2.connect.Connection.getPrice())
        || get(int telecom.v2.connect.Connection.Type.rate)
        || set(int telecom.v2.connect.Connection.Type.rate)

        || get(int Call.price)
        || set(int Call.price)
        || call(int ICall.getTotalPrice())

        || get(int Customer.charge)
        || set(int Customer.charge)
        || call(int ICustomer.getCharge());
	
	
}
