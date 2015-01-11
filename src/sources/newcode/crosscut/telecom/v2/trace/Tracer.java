package telecom.v2.trace;

import java.util.logging.Logger;

public class Tracer {
	
	/**
	 * Instance de logger
	 */
	private static Logger LOGGER = Logger.getLogger(SimulationFormatter.class.getName());
	
	/**
	 * Nombre de tabulation à ajouter au message
	 */
	private static int INDENTATIONS = 0;
	
	/**
	 * Message final de l'execution de la simulation 
	 */
	private static String message;
	
	/**
	 * Formate l'indentation
	 */
	public static String makeIndentation() {
		String result = "";
		for (int i = 0; i < INDENTATIONS; i++) {
			result += "|  ";
		}
		return result;
	}
	
	/**
	 * Augmente la valeur de l'indentation
	 */
	public static void addTabulation() {
		INDENTATIONS++;
	}
	
	/**
	 * Diminue la valeur de l'indentation
	 */
	public static void removeTabulation() {
		INDENTATIONS--;
	}
	
	/**
	 * Ajoute un saut de ligne quand Indentaiton vaut 0.
	 */
	public static void addEmptyLineIfNecessary() {
		if (INDENTATIONS == 0) {
			addEmptyLine();
		}
	}
	
	/**
	 * Ajoute un saut de ligne au message 
	 */
	public static void addEmptyLine() {
		message += "\n";
	}

	/**
	 * Créé l'indentation nécessaire, ajoute text au message avec un saut de ligne.
	 */
	public static void logPrintln(String text) {
		message += makeIndentation() + text;
		addEmptyLine();
	}
	/**
	 * Ajoute text au message et créé l'indentation nécessaire.
	 */
	public static void logPrint(String text) {
		message += (makeIndentation() + text);
	}
	
	/**
	 * Ajoute text à la suite du message (sans indentation et sans saut de ligne)
	 */
	public static void logInlineMessage(String text) {
		message += text;
	}
	/**
	 * Formate la seconde partie du message pour le changement d'êtat 
	 * d'une connection d'un appel
	 * Partie : "-> PENDING)"
	 */
	public static void makeAfterConnectionLog(String text) {
		message += "-> " + text +")";
		addEmptyLine();
	}
	
	/**
	 * Ecrit le log.
	 */
	public static void writeLog() {
		LOGGER.info(message);
	}

}
