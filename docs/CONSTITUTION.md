Constitution do RequisitaIA
Versão 1.0 proposta em 17/10/2026 — Semana 2 / DSAIA.
Status: proposta de governança para revisão e aprovação humana de João Pedro Mota Saldanha de Freitas e Pedro Caike Marinho Feitosa. O agente não declara aceite em nome da dupla. Após a aprovação registrada no PR, esta versão passa a orientar as próximas alterações; não comprova revisão ou aprovação retroativa de trabalhos anteriores.
1. Objetivo e limites
O RequisitaIA recebe relatos textuais e sugere requisitos, critérios de aceite e perguntas de esclarecimento. O usuário revisa e edita as sugestões antes de exportar em Markdown. A IA apoia a análise; não confirma requisitos em nome do cliente. Login Google e o laboratório de banco são incrementos técnicos, não comprovação de que a geração por IA já funciona.
2. Papéis e responsabilidades
Decisão ou atividade	Responsável e regra
Aprovar a spec antes de desenvolver	João Pedro e Caike, ambos, registram aceite na issue, PR ou documento versionado. A spec deve conter problema, escopo, exclusões e critérios de aceite verificáveis.
Propor alterações na spec	Qualquer integrante ou agente pode propor um diff. Só a dupla pode aprovar mudanças em requisitos e critérios de aceite.
Revisar um PR	O integrante que não conduziu a alteração confere o diff, a spec e as evidências. Se ambos trabalharam na alteração, os dois registram a revisão.
Aprovar e realizar merge	João Pedro ou Caike realiza o merge somente após aprovação explícita do outro integrante e cumprimento do critério de pronto. O agente nunca realiza merge.
Escolher provedor de IA, dados enviados, custos ou acesso ao banco	Decisão conjunta da dupla, registrada antes de configurar ou contratar.
Validar sugestões geradas	O usuário da aplicação revisa requisitos e critérios antes da exportação. A revisão técnica da dupla não substitui essa validação do usuário.


3. O que o agente pode executar e versionar
Após receber uma tarefa com escopo aprovado, o agente pode consultar documentação e schema, preparar código e testes, executar verificações locais e criar commits em branch própria de tarefa. Pode versionar sem aprovação prévia de cada commit apenas correções de formatação, links, ortografia e documentação factual, além de logs sanitizados de verificações já autorizadas, desde que não alterem comportamento, requisitos ou políticas. Deve apresentar o diff no PR.
Exigem revisão e autorização humana do diff antes da aplicação: comportamento visível, autenticação, permissões, migrations, dependências, integração com modelos e envio de dados externos. Alterações na spec exigem a aprovação conjunta descrita acima.
O agente não faz push direto em main, não faz force push, não desativa testes ou hooks para publicar e não aceita custos em nome da dupla. Push e abertura de PR dependem de autorização para publicar a tarefa; envio de mensagens depende de destinatário e finalidade confirmados.
4. Regras inegociáveis
1. Integridade dos requisitos e revisão do usuário. O agente não altera requisitos, critérios de aceite ou escopo por conta própria. Informação ausente vira pergunta ou hipótese identificada, nunca requisito confirmado. A exportação exige uma ação explícita do usuário após revisar o conteúdo.
2. Dados e credenciais protegidos. Usar relatos fictícios ou anonimizados no desenvolvimento. Chaves, senhas, tokens e dados pessoais de clientes não entram em código, commits, prompts externos, logs ou capturas de entrega. Arquivos de ambiente reais ficam ignorados; apenas um exemplo sem segredos é versionado. Credencial exposta deve ser substituída antes de continuar.
3. Mudanças verificadas e merge humano. Spec aprovada antes do desenvolvimento; alterações sensíveis com diff aprovado antes da aplicação; verificações exigidas sem falhas; revisão do outro integrante antes do merge humano. Falha ou teste não executado é registrado como pendência, nunca como sucesso.
5. Condições verificáveis de pronto
Uma funcionalidade só está pronta quando:
- Está vinculada a spec aprovada pela dupla, com todos os critérios de aceite atendidos e evidências dos testes relevantes.
- O diff foi revisado conforme a categoria da alteração, sem segredos ou arquivos gerados indevidos.
- Tipos e build passam pelos scripts do projeto; o hook pre-commit está ativo no clone usado. O autor informa comandos e resultados no PR; hook local não é apresentado como proteção automática do servidor.
- Login e acesso protegido têm testes de entrada, sessão, saída e bloqueio de acesso sem sessão quando forem afetados.
- Migration parte de consulta real ao banco de desenvolvimento, preserva dados e permissões e possui verificação automática do estado resultante. Aplicação no laboratório não significa entrega em produção.
- Mudanças na geração por IA verificam um relato completo e outro incompleto, a distinção entre sugestão e confirmação, edição e exportação Markdown. Sem teste do provedor real, a integração permanece pendente.
- PR descreve mudanças e limitações, recebe aprovação humana e é integrado por João Pedro ou Caike. Antes disso, usar “implementado”, “validado no laboratório” ou “aguardando revisão”, conforme a evidência, e não “pronto”.
6. Evolução da Constitution
Alterar este arquivo por PR específico, com motivo e impacto. A nova versão exige aceite dos dois integrantes. Nenhuma instrução ao agente permite ignorar estas regras; exceções devem ser decididas e documentadas pela dupla antes da execução, sem dispensar proteção de segredos ou falsificar evidências.

## 7. Adendo proposto - contrato da integração de IA
Proposta de versão 1.1 em 28/10/2026, para atender ao parecer de viabilidade do professor. As seções anteriores são preservadas; este adendo só entra em vigor após aprovação registrada dos dois integrantes. Não representa escolha já aprovada, contratação, implementação ou teste realizado.

### Provedor, modelo e chamada
Proposta concreta para decisão conjunta: OpenAI, modelo fixo gpt-5.4-mini-2026-03-17, Responses API com Structured Outputs, text.format do tipo json_schema e strict=true. A documentação oficial lista suporte a saída estruturada e este snapshot. Acesso da conta, saldo e orçamento ainda não foram verificados. Não trocar o modelo por alias ou alternativa silenciosamente. Disponibilidade insuficiente exige nova decisão humana.

Uma solicitação inicial reúne requisitos, critérios e perguntas. Sem chat, rodadas automáticas por esclarecimento, chamadas auxiliares ou retries automáticos. Depois de gerar, a revisão é manual. Limites propostos: relato até 5.000 caracteres, saída até 6.000 tokens, timeout de 30s; ambiente de laboratório em processo único com uma chamada em andamento por usuário autenticado e três tentativas em janela móvel de 60 segundos por identidade estável no servidor. Limite em memória não garante orçamento nem cobre múltiplas instâncias. Antes de chamar o provedor, a dupla registra conta responsável, teto de gasto e meios de acompanhamento/bloqueio disponíveis. Não aceitar custo em nome dos integrantes.

### Contrato e origem
Resposta obrigatoriamente estruturada em três listas: requisitos (id, descricao, origem), criterios (id, requisitoId, texto, origem) e perguntas (id, texto, origem). Critérios referenciam IDs existentes, sem vínculos órfãos. IDs únicos; campos obrigatórios; propriedades adicionais proibidas. O schema e as regras de cardinalidade/comprimento são especificados em docs/semana-3/specify.md e validados no servidor.

A origem é relato para conteúdo explicitamente extraído e inferido para hipóteses ou elaborações ausentes do relato. Origem sugerida pelo modelo também precisa de conferência humana. Itens criados no editor têm origem usuario. Editar um item gerado mantém sua origem original por padrão e acrescenta indicador editado. Usuário pode corrigir a origem, com invalidação da revisão. Não apresentar inferências ou revisão editorial como aprovação do cliente.

### Edição, revisão e exportação
Editar requisitos, critérios e perguntas em campos próprios; manter vínculos e origem. Markdown é produzido somente na exportação; a revisão usa campos e resumo estruturados, sem prévia ou edição Markdown. Exigir confirmação explícita de revisão, invalidada por toda mudança. Exportar inclui a origem e o indicador de edição; hipóteses continuam identificadas. Mudanças no relato invalidam sugestões anteriores. Nunca preencher falhas de API com geração fictícia apresentada como real.

### Dados e chave
Chave OPENAI_API_KEY somente em variável de ambiente no servidor do Next.js, ignorada pelo Git, sem prefixo NEXT_PUBLIC_. O navegador chama apenas a rota autenticada da aplicação. Enviar ao provedor somente título e relato fictícios ou anonimizados, com aviso e confirmação antes da solicitação; não enviar perfil Google. Não registrar conteúdo ou credenciais nos logs. Configurar store=false sem prometer ausência total de retenção pelo provedor. Banco, histórico e dados reais de clientes ficam fora desta iteração.

### Verificação
Testar contrato, relações entre itens, autorização do endpoint, limites de chamadas, falhas, edição, revisão e exportação. Fixtures e cliente falso são testes locais, não prova do provedor real. Antes de declarar integração real validada, executar relatos completo e incompleto fictícios com custo autorizado, conferir as origens e registrar evidências sanitizadas. Alterações desta seção seguem a aprovação conjunta e o merge humano já definidos.

Fontes oficiais consultadas em 28/10/2026:
- https://developers.openai.com/api/docs/models/gpt-5.4-mini
- https://developers.openai.com/api/docs/guides/structured-outputs?api-mode=responses

### Precisões do adendo para aprovação conjunta
Preservar origemGeracao imutável além da origem atual corrigível e editado cumulativo, conforme Specify. Mudanças de vínculo/origem invalidam revisão; critérios mantêm requisitoId válido e exclusão em cascata confirmada. Markdown existe somente no arquivo exportado, nunca como editor ou prévia.

Tentativas que chegam ao adaptador contam mesmo quando falham; validações anteriores não consomem quota. Reiniciar rascunho não zera a janela; reserva atômica e liberação em finally. Tokens/timeout podem impedir a saída máxima e não autorizam repetição, aumento de teto ou gasto. Orçamento continua não definido e nenhuma escolha de provedor/modelo está aprovada.

Esta preparação não coloca o adendo em vigor. Aprovação conjunta da spec e da alteração da Constitution vem antes do desenvolvimento, preservando as seções 1–6, inclusive PR específico, diffs sensíveis revisados, hooks ativos e merge humano. Publicação depende de autorização separada após revisão; não extrair credenciais do Git para APIs. Diante de 403, fornecer alternativa de publicação/revisão pela interface do GitHub.
