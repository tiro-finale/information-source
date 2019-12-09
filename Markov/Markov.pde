import java.util.Map;
import java.util.LinkedHashMap;

class State {

  public String name;
  public LinkedHashMap<State, Float> nexts;

  public State(String n) {
    nexts = new LinkedHashMap<State, Float>();
    name = n;
  }

  public void addNextState(State s, float p) {
    nexts.put(s, p);
  }

  public void removeNextState(State s){
    nexts.remove(s);
  }

  public void printState() {
    println(name);
    for (Map.Entry<State, Float> entry : nexts.entrySet()) {
      println("-> " + entry.getKey().name, entry.getValue());
    }
  }

  public State getNextState() {
    float r = random(0.0, 1.0);
    float plower = 0.0, pupper = 0.0;

    for (Map.Entry<State, Float> entry : nexts.entrySet()) {
      pupper += entry.getValue();
      if (plower < r && r <= pupper) {
        return entry.getKey();
      }
      plower += entry.getValue();
    }
    print("Error");
    return new State("None");
  }
}

class SimpleMarkovProcess {
  public ArrayList<State> states;
  public State current;

  public SimpleMarkovProcess(ArrayList<State> s) {
    states = s;
    current = states.get(0);
  }

  public void setCurrentState(State s) {
    current = s;
  }

  public void transition() {
    current = current.getNextState();
  }

  public void simulation(int num, boolean resultOnly) {

    LinkedHashMap<State, Long> percentage = new LinkedHashMap<State, Long>();
    for (State s : states) {
      percentage.put(s, 0L); // percentage init
    }
    for (int i = 1; i <= num; i++) {

      // Percentage
      for (State s : states) {
        if (s.equals(current)) {
          percentage.put(s, percentage.get(s) + 1);
        }
      }

      if (!resultOnly) {
        current.printState();
      }
      transition();
    }
    // Display
    for (Map.Entry<State, Long> entry : percentage.entrySet()) {
      println(entry.getKey().name + " = " + entry.getValue() * 100.0 / num + "[%]");
    }
  }
}

void setup() {
  // Create some States.
  State A = new State("A");
  State B = new State("B");
  State C = new State("C");

  // Define some transitions.
  A.addNextState(A, 0.5);
  A.addNextState(B, 0.3);
  A.addNextState(C, 0.2);
  B.addNextState(A, 0.3);
  B.addNextState(B, 0.5);
  B.addNextState(C, 0.2);
  C.addNextState(A, 0.1);
  C.addNextState(B, 0.2);
  C.addNextState(C, 0.7);

  // Crate list of states.
  ArrayList<State> states = new ArrayList<State>();
  states.add(A);
  states.add(B);
  states.add(C);

  // Simulator
  SimpleMarkovProcess smp = new SimpleMarkovProcess(states);
  smp.simulation(50000, true);
}
