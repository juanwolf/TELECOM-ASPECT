package telecom.v2.common;

import telecom.v2.trace.SimulationTracing;
import telecom.v2.trace.TimeTracing;

public aspect Config {
	declare precedence : SimulationTracing, TimeTracing;
}
