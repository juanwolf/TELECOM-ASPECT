package telecom.v2.trace;

public class Tracer {
	public static int INDENTATIONS = 0;
	
	public static String makeIndentation() {
		String result = "";
		for (int i = 0; i < INDENTATIONS; i++) {
			result += "|  ";
		}
		return result;
	}

	public static void makeCallLog(String text) {
		System.out.println(makeIndentation() + text);
	}
	
	public static void makeConnectionLog(String text) {
		System.out.print(makeIndentation() + text);
	}
	
	public static void makeAfterConnectionLog(String text) {
		System.out.println("-> " + text +")");
	}
}
