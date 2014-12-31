package telecom.v2.trace;

public aspect TracingManagement {
	
	private pointcut executionFinished() :
		call(void telecom.v2.simulate.Simulation.run(..));
	
	before(): executionFinished() {
		Tracer.addEmptyLine();
	}
	
	after() : executionFinished() {
		Tracer.writeLog();
	}

}
