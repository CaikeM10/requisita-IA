# Plan - Geração estruturada e revisão humana

Projeto: RequisitaIA. Fonte: [Specify](specify.md). Backlog: [Tasks](tasks.md).
Status: proposta de 28/10/2026; aprovação da dupla, orçamento e acesso ao modelo pendentes. Nenhuma implementação foi realizada para esta revisão.

## 1. Arquitetura
Preservar Next.js com Pages Router, React, TypeScript, CSS e NextAuth da base consultada. Antes de código, reler AGENTS.md, versões instaladas e guias locais. Criar pages/levantamento.tsx com proteção de sessão no servidor e pages/api/levantamento/gerar.ts com autenticação própria, método POST, validação de corpo e verificação de origem da requisição contra a URL configurada da aplicação. O navegador não acessa o provedor diretamente.

Separar lib/levantamento/types.ts, schema.ts, validation.ts e markdown.ts. Somente o módulo de provedor, em lib/server/, importa chave e cliente OpenAI; nunca é importado por componentes ou módulos compartilhados. Proposta: OpenAI, snapshot gpt-5.4-mini-2026-03-17, Responses API com text.format json_schema e strict=true. Conferir documentação e compatibilidade de SDK na implementação, fixando versão no lockfile somente após revisão da dependência.

Fluxo: validar sessão/corpo/confirmação e limites -> uma chamada -> verificar resposta completa, ausência de recusa, schema e relações -> retornar apenas dados validados -> editor por campos -> confirmação de revisão -> Markdown local. Sem API para exportar. No SDK desativar retries; não usar chamadas auxiliares, ferramentas, busca ou conversação. max_output_tokens=6000, timeout de 30s e store=false na requisição. store=false não elimina todas as hipóteses de retenção pelo provedor; avisar o envio externo e usar dados fictícios ou anonimizados.

O contrato da Specify tem três listas, IDs únicos, critérios com requisitoId e origem por item. Gerar JSON Schema executável e validar também referências, cardinalidades e textos no servidor. O editor acrescenta metadados de edição, mantém a origem das sugestões e atribui usuario a novos itens. A revisão do usuário não converte hipótese em fato confirmado pelo cliente.

## 2. Estado da interface
Estados: vazio, enviando, erro, sugestões em revisão, revisado. Desabilitar envio duplicado e edição da entrada durante chamada. Após sucesso, esconder nova geração para o mesmo rascunho; editar entrada invalida sugestões e exportação, exigindo reinício explícito. Após erro, permitir nova tentativa apenas por clique. Guardar um identificador de requisição e descartar resposta tardia cujo rascunho tenha sido abandonado; não confundir cancelamento no navegador com cancelamento de cobrança no provedor.

Listas usam IDs estáveis. Excluir requisito exclui critérios vinculados. Resumo de revisão usa campos estruturados, sem Markdown; serializador escapa caracteres estruturais e preserva acentos, origens e vínculos. Qualquer mudança invalida revisão. Exportação usa Blob UTF-8 e revoga URL temporária.

## 3. Uso e erros
Laboratório local, processo único: controle por identidade autenticada estável obtida da sessão no servidor, uma requisição em andamento por usuário e três tentativas em janela móvel de 60 segundos por identidade autenticada estável; sem guardar relatos no limitador. Limite em memória não cobre várias instâncias nem é controle financeiro. Ativar uso real apenas após a dupla registrar orçamento, conta responsável e configuração disponível no provedor; não presumir que alertas de orçamento sejam bloqueios rígidos. Sem implantar publicamente.

400: entrada/consentimento inválido; 401: sem sessão; 403: origem da requisição inválida; 405: método; 409: geração em andamento; 413: corpo excedido; 429: limite local ou remoto; 503: integração sem chave ou indisponível; 504: timeout; 502: saída recusada/incompleta/inválida. Padronizar códigos de erro internos seguros e mensagens em português. Não incluir chave, relato, perfil Google ou corpo bruto do provedor em logs/respostas. Não substituir conteúdo existente em falhas.

## 4. Sequência
1. Aprovar Constitution, Specify, Plan e Tasks; registrar escolha de provedor/modelo e orçamento antes de configurar ou chamar API.
2. Definir execução de testes TypeScript compatível com o Node instalado, tipos, schema, validação e fixtures com dados fictícios.
3. Implementar adaptador com cliente injetável e testes de resposta válida, falhas e quantidade de chamadas sem rede real.
4. Implementar endpoint protegido, limites e validação, com testes que comprovem zero chamadas para pedidos bloqueados.
5. Construir editor, origem por item, estados e exportação, com testes de revisão e regressão do login.
6. Após autorização, inserir chave local fora do Git, testar dois relatos no provedor e registrar resultado sanitizado. Executar testes, tipos e build; abrir PR para revisão e merge humano.

## 5. Matriz de verificação planejada
| Requisitos | Evidência exigida |
| --- | --- |
| RF01-RF02 | Página protegida; endpoint sem sessão, método/origem inválidos, corpo excessivo e limites de texto; nenhum pedido inválido chega ao modelo. |
| RF03, RF10 | Cliente falso conta no máximo uma chamada por pedido; sem retries; concorrência e limite por usuário testados; erro não dispara chamada; nova tentativa exige ação. |
| RF04 | Schema rejeita enum inválido, campo extra/ausente, IDs repetidos, relações órfãs, limites e strings vazias. Recusa/incompleta não entra no editor. |
| RF05-RF06 | CRUD mantém vínculos e origem; edição marcada, remoção em cascata; qualquer mudança reseta revisão; editar relato invalida resultado; resposta tardia descartada. |
| RF07 | Conteúdo final, acentos, numeração, origens, edição e lista vazia em Markdown; HTML/script inerte; download corresponde aos campos revisados. |
| RF08-RF09 | Rede somente ao endpoint autorizado e provedor no servidor; chave ausente no bundle; aviso de envio e perda por recarga; erros preservam texto e não expõem segredo. |
| Integração real | Relato completo e incompleto geram as três listas e hipóteses identificadas; humano avalia pertinência/origem; registrar modelo e limitações sem dados sensíveis. |

## 6. Riscos e limites
JSON válido não garante análise correta; a revisão é obrigatória e a origem deve ser conferida. Relato contendo instruções maliciosas não pode alterar contrato ou acessar ferramentas. Falta de saldo, acesso ao snapshot ou retorno truncado gera erro, sem troca silenciosa de modelo. Registrar necessidade de rever modelo se indisponível.

Responsáveis propostos: Caike no contrato/adaptador/testes de servidor; João na interface/revisão/exportação; ambos aprovam documentos e validam integração. Divisão ainda depende de aceite. Não declarar pronto antes de evidências e revisão/merge previstos na Constitution.

## Fontes oficiais consultadas em 28/10/2026
- Modelo e snapshot: https://developers.openai.com/api/docs/models/gpt-5.4-mini
- Structured Outputs: https://developers.openai.com/api/docs/guides/structured-outputs?api-mode=responses
As fontes documentam capacidades; não comprovam acesso da conta, crédito, custo autorizado ou resultado funcional do RequisitaIA.

## 7. Revisão documental e divergências
Base remota conferida: origin/docs/semana-3-spec-plan-tasks em 1be06f3bbc1682969ff6d5617cea8fbbd1d2e385. Fonte importada: pasta extraída RequisitaIA-Revisao-IA-Proposta na Área de Trabalho; ZIP não encontrado em Downloads. Origem preservada.

Ajustes sobre o pacote: retirar prévia Markdown para cumprir Markdown somente na exportação; fornecer schema documental; preservar origemGeracao separada da origem corrigida; precisar quota, concorrência e invalidação. Essas precisões são propostas sujeitas à aprovação conjunta.

As fontes oficiais abaixo confirmam o snapshot gpt-5.4-mini-2026-03-17 e suporte a Structured Outputs: nenhuma divergência encontrada no nome do modelo. O guia exige objetos fechados e campos obrigatórios; recusa e resposta incompleta são tratadas antes de usar o conteúdo. Schema não resolve relações entre listas ou análise semântica. Não substituir o modelo pelos modelos dos exemplos genéricos da documentação.

Testes adicionais planejados: origemGeracao imutável, correção da origem atual, edição de vínculo, exclusão em cascata confirmada, janela exata de 60s, falhas contadas, reserva atômica/liberação em finally e rascunho novo sem reset da quota. Cobrir recusa/incompleta sem uso parcial nem retry. Testar exportação fiel aos campos e escape literal de HTML/marcação, sem promessa sobre renderizadores externos. Timeout/tokens insuficientes geram falha, não aumento de limites.

Orçamento ainda não definido. Aprovação conjunta da spec e do adendo da Constitution precede desenvolvimento; dependências e diffs sensíveis exigem revisão antes da aplicação. Esta proposta não autoriza configurar chave, acessar conta ou gastar. Publicação exige autorização separada. Preservar a seção 6 da Constitution: decidir na revisão humana a separação em PR específico da alteração de governança; esta branch conjunta é apenas diff de preparação. Não extrair credenciais do Git para APIs; diante de 403, fornecer alternativa de publicação/revisão pela interface do GitHub.

Nesta etapa houve somente revisão documental; sem instalação, chamada à API, validação real do schema pelo provedor, testes funcionais, build ou alteração de banco.
