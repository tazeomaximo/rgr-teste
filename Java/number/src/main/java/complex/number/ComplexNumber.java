package complex.number;

public class ComplexNumber {

	private Integer numeroReal;
	
	private Integer numeroImaginario;
	
	public ComplexNumber() {
		this.numeroReal = 0;
		this.numeroImaginario = 0;
	}
	
	/**
	 * numeroReal -> Número Real
	 * numeroImaginario -> Número Imaginario
	 * @param numeroReal
	 * @param numeroImaginario
	 */
	public ComplexNumber(Integer numeroReal, Integer numeroImaginario) {
		this.numeroReal = numeroReal;
		this.numeroImaginario = numeroImaginario;
	}

	public Integer getNumeroReal() {
		return numeroReal;
	}

	public ComplexNumber setNumeroReal(Integer numeroReal) {
		this.numeroReal = numeroReal;
		return this;
	}

	public Integer getNumeroImaginario() {
		return numeroImaginario;
	}

	public ComplexNumber setNumeroImaginario(Integer numeroImaginario) {
		this.numeroImaginario = numeroImaginario;
		return this;
	}
	
	public ComplexNumber somar(ComplexNumber complexNumber) {
		this.numeroImaginario += complexNumber.getNumeroImaginario();
		this.numeroReal += complexNumber.getNumeroReal();
		
		return this;
	}
	
	
	@Override
	public String toString() {
		return "numeroReal = "+this.numeroReal +", numeroImaginario = " +this.numeroImaginario;
	}
}
