package telecom.v2.trace;

import java.util.logging.Logger;

public class Tracer {
	
	private static Logger LOGGER = Logger.getLogger(SimulationFormatter.class.getName());

	private static int INDENTATIONS = 0;
	
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

	public static void logPrintln(String text) {
		message += makeIndentation() + text;
		addEmptyLine();
	}
	
	public static void logPrint(String text) {
		message += (makeIndentation() + text);
	}
	
	public static void logInlineMessage(String text) {
		message += text;
	}
	public static void makeAfterConnectionLog(String text) {
		message += "-> " + text +")";
		addEmptyLine();
	}
	
	public static void writeLog() {
		LOGGER.info(message);
	}

	public static void addTabulation() {
		INDENTATIONS++;
		
	}

	public static void removeTabulation() {
		INDENTATIONS--;
		
	}

	public static void addEmptyLineIfNecessary() {
		if (INDENTATIONS == 0) {
			addEmptyLine();
		}
		
	}
}
