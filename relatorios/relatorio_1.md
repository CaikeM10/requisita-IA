# Relatório — RequisitaIA

## Viabilidade

- Grupo: Dupla 05
- Integrantes: Pedro Caike Marinho Feitosa e João Pedro Mota Saldanha de Freitas
- Repositório: https://github.com/CaikeM10/requisita-IA
- Stack: TypeScript, Next.js, React, CSS e uma API de modelo ainda sem provedor.
- Veredito: Viável

Cabe no prazo se a saída da IA for um documento estruturado e a pessoa revisar antes de exportar Markdown. 

## SWOT

### Forças

Problema, usuário e resultado estão alinhados com o SDD da disciplina. Uma linguagem, um projeto e revisão humana obrigatória. O escopo funcional tem seis passos e para na exportação.

### Fraquezas

O provedor do modelo não foi escolhido. Sem um schema (requisito, critério, pergunta e origem), a edição vira texto solto.

### Oportunidades

Travar provedor, modelo e JSON na constitution. Uma chamada gera as três listas; Markdown é só a exportação. Chave da API fica no servidor do Next.js.

### Ameaças

Sugestão apresentada como requisito aprovado. Uma segunda rodada de IA para cada esclarecimento estoura custo e escopo. 

## Stack técnica

**Parecer: Adequada.** Next.js com TypeScript e React é a stack certa; o que falta é escolher um provedor com saída estruturada, não trocar o framework.

Interface e chamada ao modelo no mesmo projeto é o desenho certo para este produto. TypeScript ajuda a descrever requisito, critério e pergunta como dados. CSS é suficiente. Git e GitHub já são o versionamento da disciplina. A stack não precisa ser substituída.

O ponto em aberto é o provedor. A constitution deve nomear um serviço com saída em JSON, por exemplo OpenAI ou Anthropic, e um modelo específico. A chave fica em variável de ambiente no servidor do Next.js. Sem esse nome, a spec não tem como fixar o formato da resposta. Trocar Next.js por outra ferramenta não resolve isso.

## Recomendação

**Fechem o provedor do modelo e façam a IA devolver requisitos, critérios e perguntas em campos editáveis, com o Markdown só na exportação.**

O RequisitaIA cabe bem na disciplina porque o produto já é uma especificação revisada por uma pessoa. A constitution precisa fechar o que o PDF deixou em aberto. A dupla escolhe o provedor e o modelo, e define que a resposta da chamada chega como dados estruturados: cada requisito, cada critério de aceite e cada pergunta de esclarecimento, com um campo dizendo se aquilo foi tirado do relato ou inferido. Com isso, a tela edita campos e o Markdown é apenas o arquivo gerado no final. Se a edição acontecer direto no texto livre, a ligação entre requisito e critério se perde. Uma chamada basta para gerar as três listas. A chave da API fica no servidor do Next.js, nunca no navegador. 
