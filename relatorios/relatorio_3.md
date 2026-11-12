# Relatório — RequisitaIA — semana 3

## Viabilidade

- Grupo: Dupla 05
- Integrantes: João Pedro Mota Saldanha de Freitas e Pedro Caike Marinho Feitosa
- Specify: https://github.com/CaikeM10/requisita-IA/blob/docs/semana-3-spec-plan-tasks/docs/semana-3/specify.md
- Plan: https://github.com/CaikeM10/requisita-IA/blob/docs/semana-3-spec-plan-tasks/docs/semana-3/plan.md
- Tasks: https://github.com/CaikeM10/requisita-IA/blob/docs/semana-3-spec-plan-tasks/docs/semana-3/tasks.md
- Constitution ligada pela spec: https://github.com/CaikeM10/requisita-IA/blob/docs/semana-3-spec-plan-tasks/docs/CONSTITUTION.md
- Veredito: Atende o recorte

Os três arquivos abrem na branch `docs/semana-3-spec-plan-tasks`, e o link da constitution também. A spec é um fluxo manual: sessão em `/levantamento`, título e relato com limites, até 20 requisitos com critérios, até 10 perguntas, prévia em texto, confirmação de revisão e download `requisitaia-requisitos.md`. Geração por IA, persistência, colaboração e outros formatos ficam fora. O plano não chama modelo. As tarefas T01 a T13 estão pendentes, e o próprio texto diz que nada foi implementado nesta semana.

## SWOT

### Forças

Cada requisito tem critério verificável, de RF01 a RF07. A spec, o plano e as tarefas apontam uns para os outros. T02 a T11 podem virar commits com o id na mensagem. T01 é a aprovação dos dois antes do código. A constitution, aberta no mesmo branch, exige aceite conjunto da spec, merge só humano e exportação só depois da revisão de quem usa. Esta iteração obedece a isso: sem modelo, sem banco, prévia que não vira HTML.

### Fraquezas

O status dos três arquivos ainda é proposta. O aceite dos dois não está registrado. Sem esse aceite, T01 não fechou, e o plano não autoriza começar a tela. A divisão João Pedro na interface e Caike na validação também está proposta, não aceita.

### Oportunidades

A semana 4 pode seguir a tabela como está: tipos e testes, rota protegida, listas, prévia, download, `npm run check`, pull request do outro integrante. O que ficar de fora já está escrito no fim das tarefas.

### Ameaças

Antecipar chamada de modelo, `localStorage` ou banco desfaz RF07 e a regra da constitution sobre revisão antes de exportar. Marcar requisito como pronto antes do fluxo integrado e da revisão humana é o que a própria lista de tarefas proíbe.

## Stack técnica

**Parecer: Adequada para o recorte manual.** O plano confirma a base já na `main` em 27/10/2026: Next.js com Pages Router, React, TypeScript, NextAuth e `npm run check`. Não há troca de roteador nem dependência nova sem revisão.

O provedor de modelo não entra. O Markdown é texto gerado no navegador. Banco fica fora. A constitution segue valendo para a próxima etapa.

## Recomendação

**Registrem o aceite dos dois no recorte e implementem só RF01 a RF07, sem chamada de modelo.**

Entra título, relato, edição das listas, prévia e Markdown, com os dados só na memória da página. Fica fora IA, persistência, colaboração e outro formato. Tarefa que não servir a esse caminho não é desta semana. O merge continua com uma pessoa, depois da revisão da outra.
