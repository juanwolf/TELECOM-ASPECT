package telecom.v2.trace;

import telecom.v2.connect.Call;
import telecom.v2.connect.ICustomer;

public aspect BillTracing {
	
	private pointcut customerHangUp() :
		call(void telecom.v2.connect.IC*.hangUp(..));
	
	
	after(ICustomer x, Call c) : customerHangUp() && args(x) && target(c)  {
		
		if (c.getCaller() == x) {
			Tracer.addEmptyLine();
			int callerTime = 0;
			for(ICustomer cus : c.getDropped()) {
				Tracer.logPrintln(cus.getName() + "[" + cus.getAreaCode() + "] a été connecté " + c.getTimer(cus).getTime() + " pour un montant de 0" );
				callerTime += c.getTimer(cus).getTime();
			}
			Tracer.logPrintln(x.getName() + "[" + x.getAreaCode() + "] a été connecté " + callerTime + " pour un montant de " + c.getPrice() );
			Tracer.logPrintln("---------------------------------------------------------");
		} else {
			Tracer.logPrint("montant de la connexion ");
			if (c.getCaller().getAreaCode() == x.getAreaCode()) {
				Tracer.logInlineMessage("locale ");
			} else {
				Tracer.logInlineMessage("longue distance ");
			}
			Tracer.logInlineMessage(": " +  c.getPriceForCustomer(x));
			Tracer.addEmptyLine();
		}
	}
}
