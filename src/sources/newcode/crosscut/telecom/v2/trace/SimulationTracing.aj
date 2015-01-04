package telecom.v2.trace;

import java.lang.reflect.Field;
import java.util.HashSet;
import java.util.Set;

import org.aspectj.lang.JoinPoint;

import telecom.v2.common.Pointcuts;
import telecom.v2.connect.Call;
import telecom.v2.connect.ICustomer;

public privileged aspect SimulationTracing {
	/**
	 * Factorisation du code pour les advices before pour les pointcuts des appels à call(), hangUp(), 
	 * pickUp() et invite()
	 */
	private void addToLogBeforeMessage(JoinPoint jp, Object x) {
 		String methName = jp.getSignature().getName();
 		SimulationMessages sm = SimulationMessages.get(x.getClass(), methName);
 		Tracer.logPrintln(sm.format(jp));
		Tracer.addTabulation();
 	}
	
	/**
	 * Factorisation du code pour les advices after pour les pointcuts des appels à call(), 
	 * hangUp(), pickUp() et invite()
		 */
	private void addToLogAfterMessage(JoinPoint jp, Object x) {
		Tracer.removeTabulation();
	 	SimulationMessages sm = SimulationMessages.get(x.getClass(), "final");
	 	Tracer.logPrintln(sm.format(jp));
		Tracer.addEmptyLineIfNecessary();
	}
	
	private pointcut connectionEventDrop():
		withincode(* telecom.v2.connect.Call.hangUp(..)) && (call(* *.get(..)) || call(* *.remove(..))); 
	
	private pointcut customerCall() : 
		call(* telecom.v2.connect.IC*.call(..));
	
	private pointcut customerHangUp() :
		call(void telecom.v2.connect.IC*.hangUp(..));
	
	private pointcut customerPickUp() :
		call(void telecom.v2.connect.IC*.pickUp(..));
	
	private pointcut callInvite():
		call(void telecom.v2.connect.IC*.invite(..));
	
	private pointcut connectionChangedState() :
		set(* telecom.v2.connect.Connection.state);
	
	private pointcut customerGetCall() :
		call(* telecom.v2.connect.ICustomer.getCall(..)) && Pointcuts.inTracing();
	
	before(Object x):  (customerCall()
			|| customerHangUp()
			|| customerPickUp()
			|| callInvite())
			&& target(x) {
		addToLogBeforeMessage(thisJoinPoint, x);
	}
	
	after(Object x) : (customerCall()
			|| customerHangUp()
			|| customerPickUp()
			|| callInvite()) && target(x) {
		addToLogAfterMessage(thisJoinPoint, x);
	}
	
	before(Object x, Object o) : connectionChangedState() && target(x) && args(o) {
		try {
			Field field = x.getClass().getDeclaredField("state");
			field.setAccessible(true);
			String value = "null";
			if (field.get(x) != null) {
				value = field.get(x).toString();
			}
			Tracer.logPrint(x + "(" + value);
		} catch (IllegalAccessException | NoSuchFieldException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Tracer.addTabulation();
	}
	
	after(Object o) : connectionChangedState() && args(o) {
		Tracer.removeTabulation();
		Tracer.makeAfterConnectionLog(o.toString());
	}
	
	after(ICustomer customer, Call ca) : connectionEventDrop() && args(customer) && this(ca) {
			ca.dropped.add(customer);
	}
	private pointcut executionFinished() :
		call(void telecom.v2.simulate.Simulation.run(..));
	
	before(): executionFinished() {
		Tracer.addEmptyLine();
	}
	
	after() : executionFinished() {
		Tracer.writeLog();
	}
}
