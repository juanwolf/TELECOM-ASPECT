package telecom.v2.billing;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import telecom.v2.connect.Call;
import telecom.v2.connect.ICustomer;

public privileged aspect BillingAspect {
	
	/**
	 * Prix de l'appel
	 */
	int Call.price;
	
	/**
	 * Contient les diff�rents prix en fonctions des Appel�s (ICustomer).
	 */
	Map<ICustomer, Integer> Call.prices = new HashMap<ICustomer, Integer>();
	
	/**
	 * Renvoie le prix de l'appel.
	 */
	public int Call.getPrice() {
		return price;
	}
	
	/**
	 * Renvoie les ICustomer en attentes
	 */
	public Set<ICustomer> Call.getPendingCustomers() {
		return pending.keySet();
	}
	
	/**
	 * Renvoie le prix de la communication en fonction de l'ICustomer
	 */
	public int Call.getPriceForCustomer(ICustomer c) {
		return prices.get(c);
	}
	 	
	/**
	 * Ajoute le prix de la communication pour l'ICustomer c.
	 */
	public void Call.addPriceForCustomer(ICustomer c, int price) {
		prices.put(c, price);
	}
	
	
	private pointcut updatePrice():
		 withincode(* telecom.v2.connect.Call.hangUp(..)) && (call(* *.get(..)) || call(* *.remove(..)));
	
	after(Call c, ICustomer x, Object map) : updatePrice()  && this(c) && args(x) && target(map) {
		try {
			Field f = c.getClass().getDeclaredField("complete");
			f.setAccessible(true);
			if (f.get(c) == map) {
				if (c.getCaller().getAreaCode() == x.getAreaCode()) {
					int price = getPrice(c.getTimer(x).getTime(), Type.LOCAL);
					c.addPriceForCustomer(x, price);
					c.price += price;
				} else {
					int price = getPrice(c.getTimer(x).getTime(), Type.NATIONAL);
					c.addPriceForCustomer(x, price);
					c.price += price;	
				}
			}
		} catch (NoSuchFieldException | SecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
	// OUTILS 
	
	enum Type {
        LOCAL(3),
        NATIONAL(10);
        private int rate;
        Type(int r) {
            rate = r;
        }
        @Override
        public String toString() {
            return name().toLowerCase();
        }
    }
	
    int getPrice(int duration, Type type) {
        return duration * type.rate;
    }

}
