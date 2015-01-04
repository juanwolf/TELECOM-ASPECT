package telecom.v2.common;

import telecom.v2.trace.BillTracing;
import telecom.v2.trace.SimulationTracing;
import telecom.v2.trace.TimeTracing;
import telecom.v2.trace.TracingManagement;

public aspect Config {
	declare precedence : TracingManagement, SimulationTracing, TimeTracing, BillTracing;
}
