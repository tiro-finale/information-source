class InformationSource {
  public String symbol;
  public float  probability;

  public InformationSource(String s, float p) {
    symbol = s;
    probability = p;
  }
}

class InformationSourceCalc {

  private ArrayList<String> symbols;
  private ArrayList<Float>  probabilities;
  private int size;

  public InformationSourceCalc(ArrayList<InformationSource> infos) {
    ArrayList<String> s = new ArrayList<String>();
    ArrayList<Float>  p = new ArrayList<Float>();
    for (int i = 0; i < infos.size(); i++) {
      s.add(infos.get(i).symbol);
      p.add(infos.get(i).probability);
    }
    symbols = s;
    probabilities = p;
    size = infos.size();
  }

  public InformationSourceCalc(ArrayList<String> s, ArrayList<Float> p) {
    if (s.size() != p.size()) {
      println("Error: InformationSourceCalc not initialized.");
      exit();
    }
    size = s.size();
    symbols = s;
    probabilities = p;
  }

  void printInformationSource() {
    for (int i = 0; i < size; i++) {
      print("I" + (i + 1) + " = " + symbols.get(i) + ", ");
      println("P" + (i + 1) + " = " + probabilities.get(i));
    }
  }

  ArrayList<Float> getInfoamtionContents() {
    ArrayList<Float> contents = new ArrayList<Float>();
    for (int i = 0; i < size; i++) {
      contents.add( -log(probabilities.get(i)) / log(2));
    }
    return contents;
  }

  Float getEntropy() {
    Float h = 0.0;
    for (int i = 0; i < size; i++) {
      h += probabilities.get(i) * log(probabilities.get(i)) / log(2);
    }
    return -h;
  }
}

void setup() {

  /*
  ArrayList<String> symbols = new ArrayList<String>();
   ArrayList<Float>  probabilities = new ArrayList<Float>();
   symbols.add("a1");
   probabilities.add(1/8.0);
   symbols.add("a2"); 
   probabilities.add(3/8.0);
   symbols.add("a3"); 
   probabilities.add(3/8.0);
   symbols.add("a4"); 
   probabilities.add(1/8.0);
   InformationSourceCalc calc = new InformationSourceCalc(symbols, probabilities);
   */

  ArrayList<InformationSource> infos = new ArrayList<InformationSource>();
  infos.add(new InformationSource("a1", 1/8.0));
  infos.add(new InformationSource("a2", 3/8.0));
  infos.add(new InformationSource("a3", 3/8.0));
  infos.add(new InformationSource("a4", 1/8.0));

  InformationSourceCalc calc = new InformationSourceCalc(infos);
  calc.printInformationSource();

  ArrayList<Float> contents = calc.getInfoamtionContents();
  for (int i = 0; i < contents.size(); i++) {
    println("I" + (i + 1) + " = " + contents.get(i) + "[bit]");
  }
  println("H=" + calc.getEntropy());
}
