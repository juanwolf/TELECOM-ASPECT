package telecom.v2.unicity;

import java.util.HashSet;

public class Unicity {
	
	private static final HashSet<String> UNIQUE_IDS = new HashSet<String>();
	
	public static boolean id_used(String name) {
		return UNIQUE_IDS.contains(name);
	}
	
	public static void addId(String name) {
		UNIQUE_IDS.add(name);
	}
}
