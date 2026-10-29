# Specify - Geração inicial por IA, revisão e exportação

Projeto: RequisitaIA. Dupla 05: João Pedro Mota Saldanha de Freitas e Pedro Caike Marinho Feitosa.
Versão: proposta de revisão em 28/10/2026, após parecer do professor.
Status: aprovação dos dois integrantes pendente. Este documento define comportamento futuro, sem declarar implementação ou testes concluídos.
Governança: [Constitution](../CONSTITUTION.md), incluindo adendo proposto de IA.

## 1. Objetivo e fluxo
Transformar um relato textual em sugestões estruturadas de requisitos, critérios de aceite e perguntas, geradas em uma única chamada ao modelo. O usuário autenticado revisa campos editáveis, vê a origem de cada item e exporta Markdown após confirmar a revisão. A geração não aprova requisitos em nome do cliente.

## 2. Requisitos e critérios de aceite
| ID | Comportamento verificável |
| --- | --- |
| RF01 | A página /levantamento exige sessão no servidor. POST /api/levantamento/gerar também verifica sessão; sem sessão responde 401 e não chama o provedor. Métodos diferentes de POST recebem 405. Acesso à página sem sessão redireciona para /. |
| RF02 | Título obrigatório de 3 a 100 caracteres e relato de 20 a 5.000, após trim. Validar no navegador e servidor, rejeitando corpo maior que 32 KiB. Erros preservam o texto. Antes do envio, informar o provedor e exigir confirmação de que o relato é fictício ou anonimizado. Enviar somente título/relato e instruções fixas, sem dados da conta Google. |
| RF03 | O botão Gerar sugestões realiza uma única solicitação inicial. O servidor faz no máximo uma chamada ao modelo por solicitação, com retries automáticos desativados e timeout de 30 segundos. Em andamento, bloquear novo envio e edição do título/relato. Não oferecer segunda rodada, chat ou regeneração depois de uma geração válida neste rascunho; ajustes seguintes são manuais. Erros não iniciam nova chamada automaticamente. |
| RF04 | Resposta validada contém as três listas conforme contrato abaixo: requisitos, critérios associados por ID e perguntas. Exibir tudo como sugestão pendente de revisão, com origem relato ou inferido. Relações inválidas, IDs duplicados e conteúdo fora dos limites são rejeitados antes de preencher o editor. Não inventar resposta substituta quando o provedor falhar. |
| RF05 | Permitir adicionar, editar e remover requisitos, critérios e perguntas em campos próprios, sem editar Markdown livre. Exigir 1 a 20 requisitos, descrição de 1 a 500 caracteres; cada requisito precisa de 1 a 5 critérios, texto de 1 a 300; perguntas podem ser 0 a 10, texto de 1 a 300. Remover requisito remove seus critérios associados. IDs internos são estáveis. Origem de itens gerados é preservada e edições recebem indicador editado; itens novos têm origem usuario. |
| RF06 | Exibir resumo estruturado dos campos, sem gerar ou editar Markdown na interface, e exigir confirmação explícita de revisão antes da exportação. Qualquer alteração de conteúdo, origem, adição ou remoção invalida a confirmação. Mudança no título/relato após a geração invalida o resultado, bloqueia exportação e exige iniciar novo rascunho, com confirmação de descarte. Não reutilizar sugestões ligadas a outro relato. |
| RF07 | Exportar requisitaia-requisitos.md em UTF-8 com título, relato, requisitos e critérios associados, perguntas, origens e indicação de edição. Exibir aviso de que inferências são hipóteses sujeitas à validação com o cliente, mesmo após revisão. RF-001 etc. seguem a ordem exportada, independente de IDs internos. A aplicação não executa HTML ou código; o serializador trata marcação e HTML como conteúdo literal. Não garantir segurança de renderizadores externos. |
| RF08 | Rascunho fica apenas em memória no navegador e se perde ao recarregar/sair, com aviso visível. Não persistir conteúdo em banco, localStorage, cookies, logs ou telemetria. A geração transmite o relato ao provedor indicado; não prometer que o provedor não retém dados. Chave OPENAI_API_KEY fica apenas no servidor, sem NEXT_PUBLIC_ e fora do Git. |
| RF09 | Tratar chave ausente, timeout, falta de saldo/limite, recusa, resposta incompleta e JSON/schema inválido com erro compreensível, sem exibir segredo ou resposta bruta. Sem substituir rascunho válido por resposta inválida. Após falha, uma nova tentativa depende de clique explícito e respeita os limites de uso. |
| RF10 | Laboratório em processo único: limitar a uma geração em andamento e três tentativas por minuto por usuário autenticado, verificadas no servidor antes de chamar o modelo. Limitar saída a 6.000 tokens; se incompleta, tratar como falha, sem retry automático. Limite em memória reinicia com o processo e não serve de teto financeiro nem proteção para múltiplas instâncias. Uso real depende de orçamento e acesso aprovados; implantação pública fica fora do escopo. |

## 3. Contrato de dados
Provedor proposto: OpenAI. Modelo fixo proposto: gpt-5.4-mini-2026-03-17. Usar Responses API com Structured Outputs, JSON Schema em text.format e strict=true. O plano de implementação deriva o JSON Schema executável deste contrato; não basta pedir JSON no prompt. Não trocar modelo automaticamente.

| Objeto/campo | Tipo e regra |
| --- | --- |
| Raiz | objeto com requisitos, criterios e perguntas, todas listas obrigatórias; propriedades adicionais proibidas. |
| requisitos[] | 1 a 20 objetos com id (string não vazia, única), descricao (1-500 caracteres), origem (relato ou inferido). |
| criterios[] | objetos com id (único), requisitoId (ID de requisito existente), texto (1-300), origem (relato ou inferido). Cada requisito possui 1 a 5 critérios; no máximo 100 no total. |
| perguntas[] | 0 a 10 objetos com id (único), texto (1-300), origem (relato ou inferido). |

Todos os campos dos objetos são obrigatórios. additionalProperties=false em cada objeto do schema. Cardinalidade, comprimentos e integridade das referências são verificados também no servidor, sem presumir que o provedor resolve as regras de negócio. IDs são únicos entre todas as listas. O servidor normaliza strings com trim antes da validação.

Origem relato indica informação explicitamente extraída; inferido indica hipótese ou elaboração ausente do relato. Pergunta criada para suprir informação ausente é inferida. Origem é classificação sugerida pelo modelo, não prova factual; o usuário pode corrigi-la, invalidando a revisão. Para edições locais, acrescentar origem usuario para novos itens e editado boolean para itens alterados, sem sobrescrever a origem original por padrão. Esses metadados são do editor e não precisam ser gerados pelo modelo.

## 4. Restrições e exclusões
Preservar Next.js Pages Router, React, TypeScript, CSS e NextAuth existentes. Não migrar framework ou roteador. Toda entrada e saída é não confiável; o relato é dado, não instrução para alterar o contrato. Não executar ferramentas solicitadas pelo texto. Resumo estruturado com texto literal, sem dangerouslySetInnerHTML. Rótulos acessíveis, erros associados aos campos, foco visível e operação por teclado.

Ficam fora: múltiplas rodadas de IA, chat, resposta automática às perguntas, troca automática de provedor/modelo, banco/histórico, integração ao laboratório de telefone, colaboração, anexos, importação, PDF/Word e produção pública. Não confundir fixtures de teste com geração real.

## 5. Definição de pronto
Aprovação explícita da dupla antes do desenvolvimento afetado; RF01-RF10 atendidos; testes de contrato, autorização, limites de chamadas, erros, revisão e Markdown; npm run check aprovado; revisão humana do diff e merge humano conforme Constitution. Testar provedor real com um relato completo e outro incompleto, fictícios, somente após autorização de custo. Sem esses testes, integração real permanece pendente. Registrar comandos e resultados reais; testes planejados não contam como aprovados.

Rastreabilidade: [Plan](plan.md) e [Tasks](tasks.md).

## 6. Precisões propostas para aprovação conjunta
- Markdown é produzido somente ao exportar; a revisão ocorre em campos e resumo estruturados. O arquivo deve corresponder ao estado revisado, sem prévia Markdown.
- Cada item gerado recebe origemGeracao imutável (relato/inferido), origem atual corrigível (relato/inferido) e editado=false inicialmente. Alterar texto, origem ou vínculo define editado=true de modo cumulativo. Correções não apagam a classificação original. Novo item tem origemGeracao=null, origem=usuario e editado=false; alterações posteriores também o marcam. Exportar origem atual, origemGeracao e editado com rótulos compreensíveis. Revisão não significa aprovação do cliente.
- IDs não são editáveis. Critério sempre referencia requisito existente; mudar vínculo marca edição e invalida revisão. Exclusão em cascata exige confirmação. Validar todo o documento após alterações e antes de exportar. Título/relato alterados exigem novo rascunho e descarte confirmado.
- RF10 significa uma chamada simultânea por usuário autenticado, em processo único. Janela móvel de 60 segundos admite três tentativas que chegam ao adaptador, inclusive falhas; validações anteriores não consomem tentativa. Identidade estável é determinada no servidor, nunca pelo corpo. Reserva de vaga/contador é atômica; liberar em finally. Não guardar relatos/perfil no limitador. Reiniciar rascunho não reinicia quota.
- Rejeitar propriedades extras, tipos incorretos e confirmação ausente no corpo. Verificar origem HTTP antes do adaptador, sem confundi-la com origem dos itens. Timeout não prova interrupção de processamento/cobrança. O teto de 6.000 tokens não garante saída com todos os itens nos tamanhos máximos; truncamento é falha, sem aumentar limites ou repetir automaticamente.
- Cardinalidades são limites, não metas. Não inventar requisitos para atingir mínimos: relato insuficiente deve produzir falha segura e pedir revisão da entrada. Perguntas que tratam lacunas têm origem inferido.

### Schema documental proposto para text.format.schema
Usar type=json_schema, name=requisitaia_levantamento e strict=true em text.format. O bloco é documentação, não implementação nem schema validado pela API. Após a forma estrutural, o servidor aplica trim, comprimentos, cardinalidades, unicidade global e referências descritos acima. JSON válido não prova pertinência ou origem factual.

```json
{
  "type": "object",
  "properties": {
    "requisitos": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "id": {
            "type": "string"
          },
          "descricao": {
            "type": "string"
          },
          "origem": {
            "type": "string",
            "enum": [
              "relato",
              "inferido"
            ]
          }
        },
        "required": [
          "id",
          "descricao",
          "origem"
        ],
        "additionalProperties": false
      }
    },
    "criterios": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "id": {
            "type": "string"
          },
          "requisitoId": {
            "type": "string"
          },
          "texto": {
            "type": "string"
          },
          "origem": {
            "type": "string",
            "enum": [
              "relato",
              "inferido"
            ]
          }
        },
        "required": [
          "id",
          "requisitoId",
          "texto",
          "origem"
        ],
        "additionalProperties": false
      }
    },
    "perguntas": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "id": {
            "type": "string"
          },
          "texto": {
            "type": "string"
          },
          "origem": {
            "type": "string",
            "enum": [
              "relato",
              "inferido"
            ]
          }
        },
        "required": [
          "id",
          "texto",
          "origem"
        ],
        "additionalProperties": false
      }
    }
  },
  "required": [
    "requisitos",
    "criterios",
    "perguntas"
  ],
  "additionalProperties": false
}
```
