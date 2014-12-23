package telecom.v2;

import telecom.v2.simulate.Simulation;

public final class Telecom {
    public static void main(String[] args) {
        Simulation simulation = new Simulation();
        System.out.println("\n... Simulation ...\n");
        simulation.run();
    }
}
