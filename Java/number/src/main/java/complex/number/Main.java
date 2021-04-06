package complex.number;

/**
 * Hello world!
 *
 */
public class Main {
	
	public static void main(String[] args) {
		
		ComplexNumber z = new ComplexNumber(6, 5);
		ComplexNumber y = new ComplexNumber(2, -1);
		
		System.out.println(somar(z, y));
	}
	
	public static ComplexNumber somar(ComplexNumber z, ComplexNumber y) {
		
		ComplexNumber novo = new ComplexNumber(z.getNumeroReal(), z.getNumeroImaginario());
		
		return novo.somar(y);
	}
}
