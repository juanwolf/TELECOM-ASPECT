package telecom.v2.trace;

import java.lang.reflect.Field;

import org.aspectj.lang.JoinPoint;

public privileged aspect SimulationTracing {
	
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
	
	before(Object x):  customerCall() && target(x) {
		JoinPoint jp = thisJoinPoint;
		String methName = jp.getSignature().getName();
		SimulationMessages sm = SimulationMessages.get(x.getClass(), methName);
		Tracer.makeCallLog(sm.format(jp));
		Tracer.INDENTATIONS++;
	}
	
	after(Object x) : customerCall() && target(x) {
		Tracer.INDENTATIONS--;
		JoinPoint jp = thisJoinPoint;
		SimulationMessages sm = SimulationMessages.get(x.getClass(), "final");
		Tracer.makeCallLog(sm.format(jp));
	}
	
	before(Object x) : customerHangUp() && target(x) {
		JoinPoint jp = thisJoinPoint;
		String methName = jp.getSignature().getName();
		SimulationMessages sm = SimulationMessages.get(x.getClass(), methName);
		Tracer.makeCallLog(sm.format(jp));
		Tracer.INDENTATIONS++;
	}
	
	after(Object x) : customerHangUp() && target(x) {
		Tracer.INDENTATIONS--;
		JoinPoint jp = thisJoinPoint;
		SimulationMessages sm = SimulationMessages.get(x.getClass(), "final");
		Tracer.makeCallLog(sm.format(jp));
	}
	
	before(Object x) : customerPickUp() && target(x) {
		JoinPoint jp = thisJoinPoint;
		String methName = jp.getSignature().getName();
		SimulationMessages sm = SimulationMessages.get(x.getClass(), methName);
		Tracer.makeCallLog(sm.format(jp));
		Tracer.INDENTATIONS++;
	}
	
	after(Object x) : customerPickUp() && target(x) {
		Tracer.INDENTATIONS--;
		JoinPoint jp = thisJoinPoint;
		SimulationMessages sm = SimulationMessages.get(x.getClass(), "final");
		Tracer.makeCallLog(sm.format(jp));
	}
	
	before(Object x) : callInvite() && target(x) {
		JoinPoint jp = thisJoinPoint;
		String methName = jp.getSignature().getName();
		SimulationMessages sm = SimulationMessages.get(x.getClass(), methName);
		Tracer.makeCallLog(sm.format(jp));
		Tracer.INDENTATIONS++;
	}
	
	after(Object x) : callInvite() && target(x) {
		Tracer.INDENTATIONS--;
		JoinPoint jp = thisJoinPoint;
		SimulationMessages sm = SimulationMessages.get(x.getClass(), "final");
		Tracer.makeCallLog(sm.format(jp));
	}
	
	before(Object x, Object o) : connectionChangedState() && target(x) && args(o) {
		try {
			Field field = x.getClass().getDeclaredField("state");
			field.setAccessible(true);
			String value = "null";
			if (field.get(x) != null) {
				value = field.get(x).toString();
			}
			Tracer.makeConnectionLog(x + "(" + value);
		} catch (IllegalAccessException | NoSuchFieldException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Tracer.INDENTATIONS++;
	}
	
	after(Object o) : connectionChangedState() && args(o) {
		Tracer.INDENTATIONS--;
		Tracer.makeAfterConnectionLog(o.toString());
	}
}
