package telecom.v2.trace;

import java.lang.reflect.Field;
import java.util.HashSet;
import java.util.Set;

import org.aspectj.lang.JoinPoint;

import telecom.v2.common.Pointcuts;
import telecom.v2.connect.Call;
import telecom.v2.connect.ICustomer;

public privileged aspect SimulationTracing {
	
	
	
    private final Set<ICustomer> Call.dropped = new HashSet<ICustomer>();
	
	private String Call.setToString(Set<ICustomer> s) {
        String result = "|";
        boolean first = true;
        for (ICustomer x : s) {
            if (first) {
                first = false;
            } else {
                result += " ";
            }
            result += x.getName();
        }
        return result;
    }
	
	public Set<ICustomer> Call.getDropped() {
		return dropped;
	}
	
	public String Call.toString() {
		String result = "<" + caller.getName();
        result += setToString(pending.keySet());
        result += setToString(complete.keySet());
        result += setToString(dropped);
        return result + ">";
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
	
	before(Object x):  customerCall() && target(x) {
		JoinPoint jp = thisJoinPoint;
		String methName = jp.getSignature().getName();
		SimulationMessages sm = SimulationMessages.get(x.getClass(), methName);
		Tracer.logPrintln(sm.format(jp));
		Tracer.INDENTATIONS++;
	}
	
	after(Object x) : customerCall() && target(x) {
		Tracer.INDENTATIONS--;
		JoinPoint jp = thisJoinPoint;
		SimulationMessages sm = SimulationMessages.get(x.getClass(), "final");
		Tracer.logPrintln(sm.format(jp));
		if (Tracer.INDENTATIONS == 0) {
			Tracer.addEmptyLine();
		}
	}
	
	before(Object x) : customerHangUp() && target(x) {
		JoinPoint jp = thisJoinPoint;
		String methName = jp.getSignature().getName();
		SimulationMessages sm = SimulationMessages.get(x.getClass(), methName);
		Tracer.logPrintln(sm.format(jp));
		Tracer.INDENTATIONS++;
	}
	
	after(Object x) : customerHangUp() && target(x) {
		Tracer.INDENTATIONS--;
		JoinPoint jp = thisJoinPoint;
		SimulationMessages sm = SimulationMessages.get(x.getClass(), "final");
		Tracer.logPrintln(sm.format(jp));
		if (Tracer.INDENTATIONS == 0) {
			Tracer.addEmptyLine();
		}
	}
	
	before(Object x) : customerPickUp() && target(x) {
		JoinPoint jp = thisJoinPoint;
		String methName = jp.getSignature().getName();
		SimulationMessages sm = SimulationMessages.get(x.getClass(), methName);
		Tracer.logPrintln(sm.format(jp));
		Tracer.INDENTATIONS++;
	}
	
	after(Object x) : customerPickUp() && target(x) {
		Tracer.INDENTATIONS--;
		JoinPoint jp = thisJoinPoint;
		SimulationMessages sm = SimulationMessages.get(x.getClass(), "final");
		Tracer.logPrintln(sm.format(jp));
		if (Tracer.INDENTATIONS == 0) {
			Tracer.addEmptyLine();
		}
	}
	
	before(Object x) : callInvite() && target(x) {
		JoinPoint jp = thisJoinPoint;
		String methName = jp.getSignature().getName();
		SimulationMessages sm = SimulationMessages.get(x.getClass(), methName);
		Tracer.logPrintln(sm.format(jp));
		Tracer.INDENTATIONS++;
	}
	
	after(Object x) : callInvite() && target(x) {
		Tracer.INDENTATIONS--;
		JoinPoint jp = thisJoinPoint;
		SimulationMessages sm = SimulationMessages.get(x.getClass(), "final");
		Tracer.logPrintln(sm.format(jp));
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
		Tracer.INDENTATIONS++;
	}
	
	after(Object o) : connectionChangedState() && args(o) {
		Tracer.INDENTATIONS--;
		Tracer.makeAfterConnectionLog(o.toString());
	}
	
	after(ICustomer customer, Call ca) : connectionEventDrop() && args(customer) && this(ca) {
			ca.dropped.add(customer);
	}
}
