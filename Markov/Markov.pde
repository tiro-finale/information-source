import java.util.Map;
class State {

  public String name;
  public ArrayList<State> nexts;
  public ArrayList<Float> probabilities;

  public State(String n) {
    nexts = new ArrayList<State>();
    probabilities = new ArrayList<Float>();
    name = n;
  }

  public void addNextState(State s, float p) {
    nexts.add(s);
    probabilities.add(p);
  }

  public void printState() {
    println(name);
    for (int i = 0; i < nexts.size(); i++) {
      println("-> " + nexts.get(i).name, probabilities.get(i));
    }
  }

  public State getNextState() {
    float r = random(0.0, 1.0);
    float plower = 0.0, pupper = 0.0;

    for (int i = 0; i < nexts.size(); i++) {
      pupper += probabilities.get(i);
      if (plower < r && r <= pupper) {
        return nexts.get(i);
      }
      plower += probabilities.get(i);
    }
    print("Error");
    return nexts.get(0);
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

  public void transition(){
    current = current.getNextState();
  }

  public void simulation(int num) {

    HashMap<State, Long> percentage = new HashMap<State, Long>();
    for(State s: states){
      percentage.put(s, 0L); // percentage init
    }
    for (int i = 1; i <= num; i++) {

      // Percentage
      for(State s: states){
        if(s.equals(current)){
          percentage.put(s, percentage.get(s) + 1);
        }
      }
      current.printState();
      transition();
    }
    // Display
    for(Map.Entry<State, Long> entry: percentage.entrySet()){
      println(entry.getKey().name + " = " + entry.getValue() * 100.0 / num + "[%]");
    }
  }
}

void setup() {
  State A = new State("A");
  State B = new State("B");
  State C = new State("C");
  A.addNextState(A, 0.5);
  A.addNextState(B, 0.3);
  A.addNextState(C, 0.2);
  B.addNextState(A, 0.3);
  B.addNextState(B, 0.5);
  B.addNextState(C, 0.2);
  C.addNextState(A, 0.1);
  C.addNextState(B, 0.2);
  C.addNextState(C, 0.7);
  ArrayList<State> states = new ArrayList<State>();
  states.add(A);
  states.add(B);
  states.add(C);

  SimpleMarkovProcess smp = new SimpleMarkovProcess(states);
  smp.simulation(10000);
}
