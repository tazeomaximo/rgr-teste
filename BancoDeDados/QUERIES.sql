/*

	As queries aqui desenvolvidas forma baseadas em um banco de dados Oracle. Se for outro banco a ser utilizado, apenas a parte de 
definição de incremento de chave primaria irá alterar.
	O sql extraído do modelo de dados foi gerado automaticamente pela feramenta. O objetivo dele é apenas de demonstrar como está sendo 
feita a relação das tabelas.

=========================================================================================================================================

Considere um sistema que tem os seguintes requisitos:
	• Como usuário, quando seleciono "Cidades" quero ver a lista de cidades.
	• Como usuário, quando seleciono uma cidade quero ver a lista de filmes.
	• Como usuário, quando seleciono um filme quero ver a lista de cinemas.
	• Como usuário, quando seleciono um cinema quero ver a lista de horários.
	• Como usuário, quando seleciono um horário e informo o número de assentos quero ver os assentos disponíveis.
	• Como usuário, quando seleciono o(s) assento(s) quero ver o preço total.
	• Como usuário, quando seleciono "Concluir Compra" quero ser redirecionado a um gateway de pagamento.
	• Como usuário, quando realizo o pagamento quero receber o(s) ingresso(s) por e-mail.
	
a) Crie um modelo de banco de dados (entidade relacionamento) de forma a atender aos requisitos deste sistema.
b) Escreva as queries em SQL para responder aos requisitos colocados acima.
*/

-- • Como usuário, quando seleciono "Cidades" quero ver a lista de cidades.
-- # Recuperando apenas cidades que tenha cinema e com filme em cartaz
	SELECT distinct C.* FROM CIDADE C 
		INNER JOIN CINEMA CI ON
			CI.ID_CIDADE = C.ID_CIDADE;
		INNER JOIN HORARIO H ON
			H.ID_CINEMA = CI.ID_CINEMA
		WHERE
			SYSDATE BETWEEN H.DT_INICIO_EXIBICAO AND H.DT_FIM_EXIBICAO;
		
-- • Como usuário, quando seleciono uma cidade quero ver a lista de filmes.
-- # Recuperando todos filmes que estão em exibição naquela cidade.
-- # OBS.: :P_CIDADE é a cidade escolhida na query anterior
-- # O filtro de exibição é necessário porque o cinema pode ter mais de um horário de exibição e durante o tempo
-- um dos horário pode ter saído de cartaz 
	SELECT DISTINCT F.* FROM FILME F
		INNER JOIN HORARIO H ON
			H.ID_FILME = F.ID_FILME
		INNER JOIN CINEMA CI ON
			CI.ID_CINEMA = H.ID_CINEMA
		WHERE
			SYSDATE BETWEEN H.DT_INICIO_EXIBICAO AND H.DT_FIM_EXIBICAO
			AND CI.ID_CIDADE = :P_CIDADE;

-- • Como usuário, quando seleciono um filme quero ver a lista de cinemas.
-- # Recuperando todos os cinemas que tem o filme em exibição.
-- # O filtro de exibição é necessário porque o cinema pode ter mais de um horário de exibição e durante o tempo
-- um dos horário pode ter saído de cartaz 
	SELECT DISTINCT CI.* FROM CINEMA CI
		INNER JOIN HORARIO H ON
			H.ID_CINEMA = CI.ID_CINEMA
		WHERE
			SYSDATE BETWEEN H.DT_INICIO_EXIBICAO AND H.DT_FIM_EXIBICAO
			AND CI.ID_CIDADE = :P_CIDADE
			AND H.ID_FILME = :P_FILME;
			
-- • Como usuário, quando seleciono um cinema quero ver a lista de horários.
-- # O filtro de exibição é necessário porque o cinema pode ter mais de um horário de exibição e durante o tempo
-- um dos horário pode ter saído de cartaz 
	SELECT H.* FROM HORARIO H
		WHERE SYSDATE BETWEEN H.DT_INICIO_EXIBICAO AND H.DT_FIM_EXIBICAO
			AND H.ID_CINEMA = :P_CINEMA
			AND H.ID_FILME = :P_FILME;

-- • Como usuário, quando seleciono um horário e informo o número de assentos quero ver os assentos disponíveis.
-- # A quantidade de acentos disponíveis pode ser recuperada na mesma query que trás o horário. Entretando, tanto na query acima quando a à seguir, quando for
-- salvar é preciso pesquisar novamente para para saber se ele(s) ainda está(ão) disponíveis dentro de uma transação.
-- # A quantidade de acentos disponíveis é atualizada em todos momentos que a venda de ingressos são concluídas com sucesso.
-- Então para essa query apenas precisamos recuperar a quantidade de acentos disponíveis para aquele horário.
-- Nesse momento tenho duas abordagem aqui:
--	1-) Como já sei a quantidade de acentos que o cliente quer posso fazer a reserva dos acentos para que ninguém pegue esses acentos 
--	2-) Deixar para verificar novamente se os acentos ainda estão disponíveis quando o cliente clicar em fechar compra
-- Vou a pela primeira opção.
-- # Filtros utilizado nessa query :P_HORARIO e :P_QTD_ACENTOS
	SELECT H.QTD_ACENTO_DISPONIVEL, H.PRECO FROM HORARIO H
		WHERE  H.ID_HORARIO = :P_HORARIO
		AND H.QTD_ACENTO_DISPONIVEL >= :P_QTD_ACENTOS;
	-- se a query retornar, quer dizer que tem acentos disponives, então vamos reservar esses acentos.
	
	UPDATE HORARIO H SET H.QTD_ACENTO_DISPONIVEL =  H.QTD_ACENTO_DISPONIVEL - :P_QTD_ACENTOS WHERE  H.ID_HORARIO = :P_HORARIO;
	
	-- e já vamos inserir na tabela de vendas:
	INSERT INTO VENDA (ID_VENDA, ID_HORARIO, QTD_INGRESSO, PRECO, STATUS, DT_VENDA) VALUES (SEQ_VENDA.NEXTVAL, :P_HORARIO, :P_QTD_ACENTOS, :P_PRECO, 'RESERVADO', SYSDATE);
	-- Aqui vamos guardar o valor da venda, pois o cinema pode alterar o valor do ingresso. Assim não perdemos o valor da venda.
	-- Se após o tempo limite para concretizar a compra o usuário não fez o pagamento, o sistema devolve a quantidade de acentos disponivel para o harário e coloca a venda como cancelada.
		
		
-- • Como usuário, quando seleciono o(s) assento(s) quero ver o preço total.
-- # Nesse momento apenas vamos multiplicar o preço pela quantidade de ingressos
	SELECT PRECO * QTD_INGRESSO FROM VENDA V WHERE V.ID_VENDA = :P_VENDA;

-- • Como usuário, quando seleciono "Concluir Compra" quero ser redirecionado a um gateway de pagamento.
-- # Esse item vejo que é uma funcionalidade de tela, o que podemos fazer no banco de dados é apenas definir uma tabela de parametos
-- que guardara a url do gateway.
-- Eu não lembro quais são os parâmetros comuns para os gateway então ou assumir que será definco feito via tela.
	SELECT * FROM PARAM P WHERE P.CHAVE = UPPER('GATEWAY')

-- • Como usuário, quando realizo o pagamento quero receber o(s) ingresso(s) por e-mail.
-- # Temos duas abordagem aqui. Assim que o gateway retornar que acompra foi aceita, atualizamos a venda para concluída:
--	1-)  E enviamos o email via aplicação.
--	2-)  Ou colocamos em uma fila, para que outro sistema faça o envio do email.
-- Nos dois casos vamos recuperar do banco qual o servidor de email.
	UPDATE VENDA SET STATUS = 'CONCLUIDO' WHERE ID_VENDA = :P_VENDA;
	SELECT * FROM PARAM P WHERE P.CHAVE = UPPER('SERVER_EMAIL')	