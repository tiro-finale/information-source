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

void setup(){
}
