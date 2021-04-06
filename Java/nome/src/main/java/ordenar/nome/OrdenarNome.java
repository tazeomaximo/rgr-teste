package ordenar.nome;

import java.text.Normalizer;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

public class OrdenarNome {


	public LinkedHashMap<String, Integer> contarOrdenar(List<String> nomes) {

		nomes = ordernar(nomes);
		
		LinkedHashMap<String, Integer> nomeQtd = new LinkedHashMap<String, Integer>();
		
		for (String nome : nomes) {
			Integer qtd = nomeQtd.get(nome);

			if (qtd == null)
				nomeQtd.put(nome, 1);
			else
				nomeQtd.replace(nome, qtd + 1);
		}
		
		return nomeQtd;
	}
	

	private List<String> ordernar(List<String> nomes) {
		List<String> list;
		if (nomes.size() == 1) {
			list = new ArrayList<String>();
			list.add(removerCaracterEspcial(nomes.get(0)));
			return list;
		}
		
		
		List<String> nomesLeft = nomes.subList(0, nomes.size() / 2);

		List<String> nomesRight = nomes.subList(nomes.size() / 2, nomes.size());

		return merge(ordernar(nomesLeft), ordernar(nomesRight));
	}

	//Merge Sort
	private List<String> merge(List<String> nomesLeft, List<String> nomesRight) {
		List<String> novaList = new ArrayList<String>();

		int indexLeft = 0;
		int indexRight = 0;

		while (indexLeft < nomesLeft.size() && indexRight < nomesRight.size()) {
			String palavra;
			if (nomesLeft.get(indexLeft).compareToIgnoreCase(nomesRight.get(indexRight)) >= 0) {
				palavra = removerCaracterEspcial(nomesRight.get(indexRight));
				indexRight++;
			} else {
				palavra = removerCaracterEspcial(nomesLeft.get(indexLeft));
				indexLeft++;
			}
			novaList.add(palavra);
		}

		novaList.addAll(nomesRight.subList(indexRight, nomesRight.size()));

		novaList.addAll(nomesLeft.subList(indexLeft, nomesLeft.size()));

		return novaList;
	}

	private String removerCaracterEspcial(String palavra) {
		return Normalizer.normalize(palavra, Normalizer.Form.NFD).replaceAll("[^\\p{ASCII}]", "").toUpperCase();
	}

}
