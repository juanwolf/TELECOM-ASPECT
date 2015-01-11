package telecom.v2.unicity;

import telecom.v2.common.Pointcuts;
import telecom.v2.util.NotUniqueException;

public aspect EnforceUnicity {
	
	declare error : Pointcuts.uniqueIdTypeError() : "Authorize to use @UniqueId on String fields only";
		
	declare error : Pointcuts.uniqueIdFinalError() : "This attribute should be final";
	
	after(String arg) : Pointcuts.uniqueIdset() && args(arg) {
		if (Unicity.id_used(arg)) {
			throw new NotUniqueException();
		}
		Unicity.addId(arg);
	}

}
