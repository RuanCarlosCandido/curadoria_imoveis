## 📄 Documento do MVP – Curadoria de Imóveis em Leilão

### 🎯 **Objetivo**

Entregar uma plataforma simples e funcional que permita ao usuário visualizar se um imóvel em leilão está com preço atrativo e se há riscos associados, com base em dados públicos e geolocalização.

---

### ✅ **Escopo do MVP**

#### **Entrada do usuário**

* Link do leilão **ou**
* Dados manuais:

  * Endereço (bairro, cidade, UF)
  * Área (m²)
  * Valor do imóvel (leilão)

#### **Saída esperada**

* Preço médio do m² na região.
* Comparação entre preço do leilão e preço de mercado (cálculo de deságio).
* Classificação de risco da região (baixo, médio, alto).
* Checklist de pontos críticos:

  * Tipo de leilão (judicial / extrajudicial)
  * Ocupado ou desocupado
* Visualização do imóvel no mapa.

---

### 🧠 **Dados e Inteligência**

#### **Preço de mercado (m²)**

* Fonte: FIPEZap ou entrada manual (base local por bairro).
* Formato: JSON ou planilha com `bairro`, `cidade`, `preco_m2`.

#### **Classificação de risco**

* Fontes:

  * OTT-RJ (Onde Tem Tiroteio) – via consulta manual inicial
  * ISP-RJ – taxa de crimes por bairro
  * Atlas da Violência / Mapa da Violência – base histórica
  * CEMADEN / IPT – dados de enchentes e deslizamentos
* Estrutura inicial: base local manual com `bairro`, `cidade`, `risco` (baixo/médio/alto)
* Critérios: definidos por você inicialmente, ex: alta criminalidade = risco alto

---

### 🗺️ **Mapa**

* Ferramenta: [Leaflet.js](https://leafletjs.com) + OpenStreetMap
* Funcionalidade:

  * Ponto com marker para localização do imóvel
  * (Futuro: camadas com áreas de risco ou zonas críticas)

---

### 🏗️ **Arquitetura Proposta**

**Frontend (web):**

* Formulário simples com entrada dos dados do imóvel
* Exibição do resultado:

  * Tabela de comparação
  * Classificação de risco
  * Mapa com marker

**Backend (Java + Spring Boot):**

* Endpoint `/analisar` que recebe os dados do imóvel
* Carrega dados locais de:

  * Preço por m²
  * Risco por bairro
* Realiza o cálculo de deságio
* Devolve objeto com: localização, comparativo, risco, checklist

**Banco de Dados:**

* SQLite local
* Tabelas:

  * `precos_por_m2`
  * `risco_bairro`
  * (futuramente) `leiloes_processados`, `logs`, etc.

---

### 🧪 **Exemplo de fluxo**

1. Usuário informa:

   * Bairro: Copacabana
   * Cidade: Rio de Janeiro
   * Área: 60m²
   * Valor: R\$ 250.000

2. Sistema encontra:

   * Preço médio da região: R\$ 8.000/m²
   * Valor de mercado esperado: R\$ 480.000
   * Deságio: 47,9%
   * Risco da área: Médio

3. Exibe:

   * 🟠 Deságio bom
   * ⚠️ Risco médio (zona com ocorrências recentes)
   * 📍 Localização no mapa
   * 📝 Tipo: Judicial | Ocupado: Sim

---

### 🧩 **Funcionalidades Futuras (fora do MVP)**

* Scraping automatizado de portais OLX/Zap.
* PDF exportável do relatório.
* Cadastro de usuários e histórico.
* Integração em tempo real com APIs públicas (OTT, IBGE, etc).
* Heatmaps e camadas no mapa (criminalidade, escolas, etc).

---

### ⚠️ **Disclaimer obrigatório (já previsto no MVP)**

> “As informações fornecidas por esta plataforma são de caráter informativo, baseadas em dados públicos e comparações automatizadas. Não constituem recomendação de compra, nem substituem análise jurídica ou técnica. Use por sua conta e risco.”



Excelente pergunta, Ruan — e é aqui que o projeto começa a ganhar um **caráter autoral e estratégico**. Vamos pensar de forma prática, simples de manter, e compatível com a base pública que você consegue baixar.

A ideia geral é: **transformar dados brutos públicos em uma escala comum de 0 a 100**. Aqui vão sugestões **para cada camada de score**, incluindo ideias de fontes e como normalizar os dados.

---

## 🎯 PRINCÍPIO GERAL: ESCALA RELATIVA OU CATEGÓRICA

Você pode usar 2 métodos combinados:

### 1. **Escala Relativa (percentil ou score Z)**

* Útil quando você tem uma distribuição numérica grande.
* Ex: homicídios por 100 mil habitantes.
* Transformação:

  * Normaliza em relação ao pior valor do dataset (máximo).
  * Score = `(valor / valor_máximo) * 100`.

### 2. **Escala Categórica (faixas fixas)**

* Quando os valores têm cortes objetivos.
* Ex: distância a hospital, ocorrência de enchentes.
* Score = mapeamento direto por faixa.

---

## 🧱 SUGESTÕES POR TIPO DE SCORE

### 🔫 `shootings_score`

**Fonte:** OTT-RJ, Fogo Cruzado, etc.
**Dado bruto:** nº de eventos em X dias ou por mês, por bairro.

**Transformação:**

```text
0 eventos: 0
1-3 eventos: 30
4-6 eventos: 60
7+ eventos: 100
```

Ou, se tiver muito dado:

```text
score = (eventos_bairro / max_eventos_na_cidade) * 100
```

---

### ☠️ `violence_score`

**Fonte:** ISP-RJ, Atlas da Violência
**Dado bruto:** homicídios por 100 mil habitantes.

**Transformação:**

```text
<=10 por 100k: 0
11–30: 30
31–60: 60
>60: 100
```

> **Alternativa:** usar `score = (valor_bairro / pior_bairro) * 100`.

---

### 🌊 `flooding_score`

**Fonte:** Cemaden, IPT
**Dado bruto:** presença ou não em mapa de risco.

**Transformação (simplificada):**

```text
Não está em área de risco: 0
Risco leve: 40
Risco médio: 70
Risco alto: 100
```

> Pode usar shapefiles ou lista de bairros classificados manualmente.

---

### 🏥 `infrastructure_score` (o inverso dos outros)

**Fonte:** IBGE, OpenStreetMap
**Dado bruto:** distância média até hospital, escola, supermercado.

**Transformação (quanto maior a distância, maior o risco):**

```text
<= 500m de tudo: 0
~1km: 30
~2km: 60
> 3km: 100
```

> Pode ser definido manualmente para o MVP, com base em mapa.

---

## 🧮 Exemplo prático aplicado: bairro fictício

| Bairro             | Shooting | Violence | Flooding | Infra | Final Score | Risk Level |
| ------------------ | -------- | -------- | -------- | ----- | ----------- | ---------- |
| Bangu              | 60       | 80       | 40       | 30    | 60          | medium     |
| Copacabana         | 10       | 30       | 0        | 10    | 20          | low        |
| Complexo do Alemão | 100      | 100      | 70       | 80    | 90          | high       |

---

## ⚖️ DICA FINAL: Mantenha os critérios como constantes no código ou em arquivo de config

Assim, se você quiser mudar os pesos ou cortes depois, não precisa alterar a base de dados — só a lógica de cálculo.

```yaml
weights:
  shootings: 0.4
  violence: 0.3
  flooding: 0.2
  infrastructure: 0.1

thresholds:
  high: 67
  medium: 34
  low: 0
```

---

Se quiser, posso gerar uma planilha ou um JSON de exemplo com 5 bairros do RJ e scores simulados pra você testar. Deseja isso?
