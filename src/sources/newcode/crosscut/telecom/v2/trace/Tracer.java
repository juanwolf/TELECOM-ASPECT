package telecom.v2.trace;

import java.util.logging.Logger;

public class Tracer {
	
	private static Logger LOGGER = Logger.getLogger(SimulationFormatter.class.getName());

	public static int INDENTATIONS = 0;
	
	private static String message;
	
	public static String makeIndentation() {
		String result = "";
		for (int i = 0; i < INDENTATIONS; i++) {
			result += "|  ";
		}
		return result;
	}
	
	public static void addEmptyLine() {
		message += "\n";
	}

	public static void makeCallLog(String text) {
		message += makeIndentation() + text;
		addEmptyLine();
	}
	
	public static void makeConnectionLog(String text) {
		message += (makeIndentation() + text);
	}
	
	public static void makeAfterConnectionLog(String text) {
		message += "-> " + text +")";
		addEmptyLine();
	}
	
	public static void writeLog() {
		LOGGER.info(message);
	}
}
