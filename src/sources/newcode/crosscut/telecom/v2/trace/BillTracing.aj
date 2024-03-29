package telecom.v2.trace;

import telecom.v2.common.Pointcuts;
import telecom.v2.connect.Call;
import telecom.v2.connect.ICall;
import telecom.v2.connect.ICustomer;

public privileged aspect BillTracing {
	
	private Call callDuringTest;
	
	private String resultMessage;
	
	after(ICustomer x, Call c): Pointcuts.customerHangUp() && args(x) && target(c)  {
		if (!(c.getCaller() == x)) {
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
	
	after() returning(ICall c): Pointcuts.getCall() && Pointcuts.inTestsFunctions() {
		callDuringTest = (Call) c;
	}
	
	after() : Pointcuts.testsCall() {
		resultMessage = "";
		Tracer.addEmptyLine();
		int callerTime = 0;
		for(ICustomer cus : callDuringTest.getDropped()) {
			resultMessage += cus.getName() + "[" + cus.getAreaCode() + "] a �t� connect� " + callDuringTest.getTimer(cus).getTime() + " s pour un montant de 0\n" ;
			callerTime += callDuringTest.getTimer(cus).getTime();
		}
		resultMessage += callDuringTest.getCaller().getName() + "[" + callDuringTest.getCaller().getAreaCode() + "] ";
		if (callDuringTest.noCalleePending()) {
			resultMessage += "a �t� connect� " + callerTime + " s pour un montant de " + callDuringTest.getPrice() + "\n";
		} else {
			resultMessage += "est en attente de ";
			for (ICustomer c : callDuringTest.getPendingCustomers()) {
				resultMessage += c.getName() + " ";
			}
			resultMessage += "et son montant sera sup�rieur � " + callDuringTest.getPrice() + "\n"  ;
		}
		resultMessage += "-------------------------------------------------------------------------------------\n";
		Tracer.logPrintln(resultMessage);
	}
}
