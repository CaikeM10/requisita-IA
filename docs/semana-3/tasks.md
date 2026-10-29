# Tasks - IA, campos editáveis e exportação

Projeto: RequisitaIA. Referências: [Specify](specify.md), [Plan](plan.md), [Constitution](../CONSTITUTION.md).
Status: todas as tarefas pendentes. Responsáveis propostos; nenhuma aprovação, implementação ou execução de teste presumida.

| ID | Tarefa e entrega | Requisitos | Depende de | Responsável proposto | Evidência |
| --- | --- | --- | --- | --- | --- |
| T01 | Revisar documentos e registrar aprovação de ambos, provedor/modelo, dados enviados e orçamento. | Governança | - | Dupla | Aceites reais e orçamento; nenhuma contratação pelo agente. |
| T02 | Configurar execução de testes e tipos do contrato/editor com fixtures fictícias. | RF04-RF05 | T01 | Caike | Comando de teste funcional e eventual dependência revisada. |
| T03 | Escrever JSON Schema estrito das três listas e validador de integridade/limites. | RF02, RF04 | T02 | Caike | Casos válidos; IDs duplicados, vínculo órfão, enum/campo/limite inválidos rejeitados. |
| T04 | Criar adaptador do provedor com cliente injetável, modelo fixo, timeout, saída limitada e zero retries. | RF03, RF08-RF10 | T03 | Caike | Testes sem rede contam uma chamada e cobrem recusa, truncamento e erro. |
| T05 | Criar POST autenticado, método/origem/corpo/consentimento validados. | RF01-RF02 | T03-T04 | Caike | Pedidos bloqueados fazem zero chamadas; erros sanitizados. |
| T06 | Adicionar controle local por usuário: concorrência e três tentativas/minuto. | RF03, RF10 | T05 | Caike | Testes de bloqueio e janela; limitação de processo único documentada. |
| T07 | Criar rota /levantamento protegida e link da área autenticada. | RF01 | T01 | João | Acesso antes/depois de login e logout verificado. |
| T08 | Criar título/relato com validação, aviso de envio/perda e confirmação de anonimização. | RF02, RF08 | T03, T07 | João | Erros preservam entrada; teclado, rótulos e foco conferidos. |
| T09 | Integrar gerar/enviando/erro/sucesso, envio único e descarte de resposta tardia. | RF03, RF06, RF09-RF10 | T06, T08 | João | Cliques repetidos não duplicam envio; falha sem retry; entrada alterada invalida resultado. |
| T10 | Construir editor de requisitos e critérios vinculados com origem e indicador de edição. | RF04-RF05 | T09 | João | Adicionar/editar/remover, limites, IDs e exclusão em cascata conferidos. |
| T11 | Construir editor de perguntas com origem, indicador de edição e estado vazio. | RF04-RF05 | T09 | João | Limites, CRUD e origem usuario para novos itens verificados. |
| T12 | Implementar serializador Markdown com vínculos, origens e testes. | RF07 | T03 | Caike | Conteúdo esperado, acentos, HTML inerte, numeração e lista vazia. |
| T13 | Integrar resumo estruturado e revisão explícita invalidada por toda edição, sem prévia Markdown. | RF06-RF07 | T10-T12 | João | Todos os campos, origens e vínculos invalidam confirmação; download bloqueado quando necessário. |
| T14 | Implementar download UTF-8 e liberação da URL temporária. | RF07 | T13 | João | Arquivo corresponde aos campos revisados; nome fixo e acentos. |
| T15 | Executar regressões, testes de endpoint, privacidade, erros e teclado. | RF01-RF10 | T14 | Dupla | Resultados reais e pendências registrados; npm run check aprovado. |
| T16 | Após autorização de uso, testar provedor real com relato completo e incompleto fictícios. | RF03-RF04, RF08-RF10 | T15 e custo autorizado | Dupla | Modelo, resultado, revisão de origem/hipóteses; sem simular sucesso. |
| T17 | Atualizar execução/limitações e abrir PR para revisão humana e merge humano. | Pronto | T15-T16 | Autor e outro integrante | Diff sem segredos, evidências, revisão e aceite reais. |

Cada tarefa técnica deve caber em commit ou PR pequeno; não agrupar toda a implementação em uma única entrega. T01 é a aprovação anterior ao desenvolvimento. T16 exige autorização adicional de gasto se ainda não registrada. Sem acesso ao provedor, é possível concluir testes com cliente falso, mas T16 continua pendente e a integração real não é declarada pronta.

Fora do backlog: chat, rodadas automáticas por esclarecimento, banco/histórico, telefone do laboratório, colaboração, novos formatos e implantação pública.

## Precisões propostas de rastreabilidade
- T01: aprovação conjunta da spec e adendo das duas Constitutions antes de desenvolver. Orçamento não definido; registrar conta responsável, dados e meios de acompanhamento/bloqueio antes de uso real. Publicação depende de autorização própria e PR específico da Constitution.
- T02-T03: schema fechado/campos obrigatórios e validação de negócio após trim; IDs globais, cardinalidade por requisito, vínculos e recusa de conteúdo insuficiente sem fabricação. Schema documental não equivale a aceitação real pelo provedor.
- T04-T06: testar timeout, saldo/limite, chave ausente, recusa, incompleta, rede e saída inválida; zero retry e nenhuma troca de modelo. Pedidos barrados fazem zero chamadas. Testar identidade estável, reserva atômica, liberação em finally, janela móvel, falhas contadas e rascunho novo sem reset da quota. Limite local não é orçamento.
- T10-T11: origemGeracao imutável, origem atual corrigível, novos itens usuario, editado cumulativo, edição de vínculo e exclusão em cascata confirmada; toda mudança invalida revisão.
- T12-T14: Markdown somente ao exportar; testar fidelidade aos campos, origens e edição, escape literal de HTML/marcação e numeração dos vínculos.
- T15-T16: distinguir fixtures de testes reais. Todos esses testes permanecem pendentes; API somente com aprovação e custo autorizado. Sem acesso/orçamento/teste real, integração real permanece pendente.
