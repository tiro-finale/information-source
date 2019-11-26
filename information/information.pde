class InformationSource {

  public String symbol;
  public float  probability;

  public InformationSource(String s, float p) {
    symbol = s;
    probability = p;
  }

  public void printInformationSource() {
    println(symbol + ", " + probability);
  }
}

class InformationSourceCalc {

  public ArrayList<InformationSource> sources;

  public InformationSourceCalc(ArrayList<InformationSource> s) {
    sources = s;
  }

  public InformationSourceCalc(InformationSource s) {
    sources = new ArrayList<InformationSource>();
    sources.add(s);
  }

  public InformationSourceCalc() {
    sources = new ArrayList<InformationSource>();
  }

  public InformationSourceCalc(ArrayList<String> s, ArrayList<Float> p) {
    if (s.size() != p.size()) {
      String msg = "The length of the source symbol and the probability must match.";
      throw new ArrayIndexOutOfBoundsException(msg);
    }
    for (int i = 0; i < s.size(); i++) {
      sources.add(new InformationSource(s.get(i), p.get(i)));
    }
  }

  public void add(InformationSource s) {
    sources.add(s);
  }

  public void add(String s, float p) {
    sources.add(new InformationSource(s, p));
  }

  public void printInformationSources() {
    for (InformationSource s : sources) {
      s.printInformationSource();
    }
  }

  public ArrayList<Float> getInfoamtionContents() {
    ArrayList<Float> contents = new ArrayList<Float>();
    for (InformationSource s : sources) {
      contents.add(-log(s.probability) / log(2));
    }
    return contents;
  }

  public float getEntropy() {
    float h = 0.0;
    for (InformationSource s : sources) {
      h += s.probability * log(s.probability) / log(2);
    }
    return -h;
  }

  public String getSymbolByProbability() {
    float r = random(0.0, 1.0);
    float plower = 0.0, pupper = 0.0;

    for (InformationSource s : sources) {
      pupper += s.probability;
      if (plower < r && r <= pupper) {
        return s.symbol;
      }
      plower += s.probability;
    }
    println("Warning: Sum of probabilities is not \"1\".");
    println("Return symbol in information sources.");
    return sources.get(0).symbol;
  }

  public ArrayList<String> getSymbolsByProbability(int n) {

    ArrayList<String> symbols = new ArrayList<String>();
    for (int i = 1; i <= n; i++) {
      symbols.add(getSymbolByProbability());
    }
    return symbols;
  }
}

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

  // 情報源の基本的な計算
  ArrayList<InformationSource> sources = new ArrayList<InformationSource>();
  sources.add(new InformationSource("a1", 1/8.0));
  sources.add(new InformationSource("a2", 3/8.0));
  sources.add(new InformationSource("a3", 3/8.0));
  sources.add(new InformationSource("a4", 1/8.0));

  InformationSourceCalc calc = new InformationSourceCalc(sources);
  calc.printInformationSources();

  ArrayList<Float> contents = calc.getInfoamtionContents();
  for (int i = 0; i < contents.size(); i++) {
    println("I" + (i + 1) + " = " + contents.get(i) + " [bit]");
  }
  println("H = " + calc.getEntropy());

  // 情報源記号を確率を用いて算出するテスト
  sources = new ArrayList<InformationSource>();
  sources.add(new InformationSource("A", 1/8.0));
  sources.add(new InformationSource("B", 7/8.0));
  calc = new InformationSourceCalc(sources);
  int a = 0, b = 0;
  for (int i = 1; i <= 10000; i++) {
    if (calc.getSymbolByProbability() == "A")
      a++;
    else
      b++;
  }
  println("A=" + nf(a *100.0 / 10000, 2, 4) + "%, B=" +  nf(b * 100.0 / 10000, 2, 4) + "%");

  // 単純マルコフ過程
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
