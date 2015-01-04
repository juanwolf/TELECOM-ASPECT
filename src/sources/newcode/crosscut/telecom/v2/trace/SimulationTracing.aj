package telecom.v2.trace;

import java.lang.reflect.Field;

import org.aspectj.lang.JoinPoint;

import telecom.v2.common.Pointcuts;

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
	
	before(Object x):  (Pointcuts.customerCall()
			|| Pointcuts.customerHangUp()
			|| Pointcuts.customerPickUp()
			|| Pointcuts.callInvite())
			&& target(x) {
		addToLogBeforeMessage(thisJoinPoint, x);
	}
	
	after(Object x) : (Pointcuts.customerCall()
			|| Pointcuts.customerHangUp()
			|| Pointcuts.customerPickUp()
			|| Pointcuts.callInvite()) && target(x) {

		addToLogAfterMessage(thisJoinPoint, x);
	}
	
	before(Object x, Object o) : Pointcuts.connectionChangedState() && target(x) && args(o) {
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
	
	after(Object o) : Pointcuts.connectionChangedState() && args(o) {
		Tracer.removeTabulation();
		Tracer.makeAfterConnectionLog(o.toString());
	}
	
	before(): Pointcuts.simulationExecution() {
		Tracer.addEmptyLine();
	}
	
	after() : Pointcuts.simulationExecution() {
		Tracer.writeLog();
	}
}
