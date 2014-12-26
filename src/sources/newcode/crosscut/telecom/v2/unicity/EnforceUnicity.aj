package telecom.v2.unicity;

import telecom.v2.util.NotUniqueException;

public aspect EnforceUnicity {
	
	pointcut uniqueIdUse() : 
		set(final String telecom.v2.unicity.UniqueId);
	
	public pointcut uniqueIdUseNotAccepted() :
		set(@UniqueId * *) && set(!final !String *);
	
	public pointcut uniqueIdArgs(String arg):
		set(@UniqueId * *) && args(arg);
	
	declare error : uniqueIdUseNotAccepted() : "Not authorize to use @UniqueId on not final or not string fields";
	
	after(String arg) : uniqueIdArgs(arg) {
		if (Unicity.id_used(arg)) {
			throw new NotUniqueException();
		}
		Unicity.addId(arg);
	}

}
