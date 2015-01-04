package telecom.v2.trace;

import java.util.HashSet;
import java.util.Set;

import telecom.v2.common.Pointcuts;
import telecom.v2.connect.Call;
import telecom.v2.connect.ICustomer;

public privileged aspect TracingManagement {
	
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
	
	after(ICustomer customer, Call ca) : Pointcuts.callStateChangedInDropped() && args(customer) && this(ca) {
		ca.dropped.add(customer);
	}

}
