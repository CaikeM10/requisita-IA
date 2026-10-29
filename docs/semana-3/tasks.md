# Tasks - Backlog da iteração

Projeto: RequisitaIA. Fontes: [Specify](specify.md) e [Plan](plan.md).
Status inicial: todas as tarefas pendentes. Responsáveis abaixo são propostos, sujeitos ao aceite da dupla. Nenhuma implementação foi executada para este planejamento.

| ID | Tarefa pequena / entrega | Spec | Dependência | Responsável proposto | Evidência de conclusão |
| --- | --- | --- | --- | --- | --- |
| T01 | Revisar os três documentos e registrar aprovação conjunta do recorte. | Governança | Nenhuma | João e Caike | Aceites reais no PR; não produzir aceite pelo agente. |
| T02 | Definir tipos do documento e a execução dos testes TypeScript no ambiente existente. | RF02-RF04 | T01 | Caike | Tipos e comando de teste documentados; eventual dependência aprovada. |
| T03 | Implementar validação de título/relato e testes de tamanho e trim. | RF02 | T02 | Caike | Testes nos limites, vazios e espaços aprovados. |
| T04 | Implementar validação de requisitos, critérios e perguntas com testes de limites e erros por item. | RF03-RF04 | T02 | Caike | Casos válidos e inválidos de listas aprovados. |
| T05 | Criar serializador Markdown e testes de conteúdo, acentos, caracteres estruturais e perguntas vazias. | RF06 | T02 | Caike | Texto esperado comparado ao resultado; numeração e critérios corretos. |
| T06 | Criar /levantamento com verificação de sessão no servidor e link na área autenticada. | RF01 | T01 | João | Acesso sem sessão, com sessão e após logout verificados. |
| T07 | Construir campos de título/relato, mensagens acessíveis e aviso de dados temporários. | RF02, RF07 | T03, T06 | João | Entradas preservadas após erro; rótulos, aviso e foco conferidos. |
| T08 | Construir lista editável de requisitos e respectivos critérios com adicionar/remover e limites. | RF03 | T04, T07 | João | Operações e associação dos critérios ao requisito verificadas. |
| T09 | Construir lista editável de perguntas, incluindo estado vazio e limite máximo. | RF04 | T04, T07 | João | Adicionar, editar, remover e lista vazia verificados. |
| T10 | Integrar prévia textual e confirmação de revisão, invalidada por qualquer mudança de conteúdo. | RF05 | T05, T08, T09 | João | Todos os campos/listas invalidam confirmação; exportação permanece bloqueada quando necessário. |
| T11 | Implementar download UTF-8 com nome fixo e liberação da URL temporária. | RF06 | T10 | João | Arquivo aberto com conteúdo igual ao revisado e acentos corretos. |
| T12 | Executar cenários integrados, teclado, ausência de envio/armazenamento e regressão de autenticação. | RF01-RF07 | T11 | João e Caike | Registro com resultados reais e falhas; testes pendentes identificados. |
| T13 | Atualizar instruções, executar testes e npm run check, preparar PR e submeter à revisão do outro integrante. | Pronto | T12 | Autor e revisor humano | Comandos/resultados, diff sem segredos e critérios rastreados; merge exclusivamente humano. |

## Organização dos commits e PRs
T02-T11 podem gerar commits separados com o ID da tarefa na mensagem. Agrupar somente tarefas relacionadas em um PR pequeno, indicando os RF atendidos e os que dependem de outro PR. Não marcar um requisito como pronto antes do fluxo integrado e da revisão. T01 é porta de aprovação anterior ao desenvolvimento.

## Fora do backlog
API/modelo de IA, banco e histórico, campo de telefone do laboratório, colaboração, importação, PDF/Word e implantação. Qualquer entrada dessas atividades exige uma nova spec ou mudança de escopo aprovada pela dupla.
