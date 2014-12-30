package telecom.v2.unicity;

import telecom.v2.util.NotUniqueException;
import telecom.v2.common.*;

public aspect EnforceUnicity {
	
	private pointcut uniqueIdTypeError() :
		set(@UniqueId (boolean||char||byte||short||int||long||float||double) *.*)  && Pointcuts.inDomain();
	
	private pointcut uniqueIdFinalError() :
		set(@UniqueId !final * *) && Pointcuts.inDomain();
	
	private pointcut uniqueIdArgs(String arg):
		set(@UniqueId * *) && args(arg);
	
	declare error : uniqueIdTypeError() : "Authorize to use @UniqueId on String fields only";
		
	declare error : uniqueIdFinalError() : "This attribute should be final";
	
	after(String arg) : uniqueIdArgs(arg) {
		if (Unicity.id_used(arg)) {
			throw new NotUniqueException();
		}
		Unicity.addId(arg);
	}

}
