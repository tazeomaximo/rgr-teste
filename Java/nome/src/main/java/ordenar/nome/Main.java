package ordenar.nome;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;

public class Main {

	public static void main(String[] args) {

		List<String> nomes = Arrays.asList("Pedro", "João", "Maria", "JOAO", "Alberto", "João", "MARiA");

		OrdenarNome ordenar = new OrdenarNome();

		LinkedHashMap<String, Integer> resultado = ordenar.contarOrdenar(nomes);

		System.out.println(resultado.toString());

	}

}
