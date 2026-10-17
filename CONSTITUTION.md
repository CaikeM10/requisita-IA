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
