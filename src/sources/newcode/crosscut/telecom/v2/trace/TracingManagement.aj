package telecom.v2.trace;

import java.util.HashSet;
import java.util.Set;

import telecom.v2.common.Pointcuts;
import telecom.v2.connect.Call;
import telecom.v2.connect.ICustomer;

public privileged aspect TracingManagement {
	
	/**
	 * Utilisateur dont la connection est pass� � l'�tat DROPPED
	 */
	private final Set<ICustomer> Call.dropped = new HashSet<ICustomer>();
	
	/**
	 * Formate l'affichage d'un ensemble de ICustomer en cha�ne de caract�res.
	 */
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
	
	/**
	 * Retourne les utilisateurs avec une connection ayant pour �tat DROPPED
	 */
	public Set<ICustomer> Call.getDropped() {
		return dropped;
	}
	
	/**
	 * Formate l'affichage de l'instance de Call en cha�ne de caract�res.
	 */
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
