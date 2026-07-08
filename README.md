# Pokenion — Pokémon TCG Companion App

[![Flutter Version](https://img.shields.io/badge/Flutter-%3E%3D%203.1.5-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-%3E%3D%203.1.5-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Firebase Integrated](https://img.shields.io/badge/Firebase-Auth%20%26%20Firestore-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Windows-lightgrey)](#)

O **Pokenion** é um aplicativo companheiro (*Companion App*) moderno e dinâmico projetado para jogadores e entusiastas de **Pokémon Trading Card Game (TCG)**. Ele oferece ferramentas robustas para gerenciar baralhos, auxiliar no andamento de partidas reais (físicas) por meio de um marcador digital de danos e status, sincronizar dados na nuvem e interagir com recursos de hardware móvel como câmera (para digitalização de cartas), GPS (para mapeamento de partidas) e notificações locais.

---

## 🚀 Principais Funcionalidades

- **🎴 Gerenciador de Decks**: Crie, edite e organize seus baralhos personalizados. Faça buscas rápidas na Pokédex local (integrando cartas da 1ª Geração, incluindo versões EX, Mega e V-Astro).
- **⚔️ Marcador de Batalha em Tempo Real**:
  - Controle de HP do Pokémon Ativo e do Banco.
  - Aplicação de condições de status oficiais (Confuso, Adormecido, Queimado, Envenenado, Paralisado).
  - Mecânica de Evolução integrada (calcula automaticamente o aumento de HP proporcional e limpa status de acordo com o livro de regras oficial).
  - Histórico de nocaute e trocas de Pokémon.
  - Simulador de cara ou coroa digital para lançamentos de moedas nas partidas.
- **🔄 Sincronização em Nuvem Híbrida**: Use o aplicativo como visitante (salvamento offline em cache local rápido com Hive e SQLite) ou faça login com sua conta do Google para sincronizar e proteger seus baralhos automaticamente no Cloud Firestore.
- **📷 Leitura de Cartas por OCR** (Pronto para Integração): Digitalize cartas físicas por meio da câmera do dispositivo móvel e converta imagens em dados estruturados no app usando Inteligência Artificial de reconhecimento de caracteres (OCR).
- **📍 Registro Geográfico de Partidas** (Pronto para Integração): Salve a localização GPS de onde seus duelos épicos ou trocas de cartas aconteceram.
- **🔔 Notificações Personalizadas** (Pronto para Integração): Lembretes de torneios locais e notificações sobre status de partidas e atualizações do app.

---

## 🛠️ Arquitetura e Tecnologias

O projeto foi construído seguindo os princípios de **Clean Architecture** separados em camadas de fácil manutenção:
- **`lib/domain/`**: Modelos de dados puros e entidades de negócio imutáveis criadas com `freezed`.
- **`lib/data/`**: Repositórios e fontes de dados (banco local Hive/SQLite e conexão Firebase Firestore).
- **`lib/presentation/`**: Interface visual (UI) moderna, componentes visuais com Material Design 3 e gerenciamento de estado declarativo com `riverpod`.

### Principais Dependências Utilizadas
*   **Core**: [Flutter](https://flutter.dev) & [Dart](https://dart.dev)
*   **Gerenciamento de Estado**: [Flutter Riverpod](https://pub.dev/packages/flutter_riverpod) com `riverpod_annotation` e `riverpod_generator` para estados robustos e limpos.
*   **Roteamento**: [GoRouter](https://pub.dev/packages/go_router) para gerenciamento declarativo de rotas.
*   **Banco de Dados Local**:
    *   [Sqflite](https://pub.dev/packages/sqflite) para armazenamento relacional de dados locais.
    *   [Hive](https://pub.dev/packages/hive_flutter) para armazenamento chave-valor rápido de preferências de tema e configurações.
*   **Backend & Nuvem**:
    *   [Firebase Core](https://pub.dev/packages/firebase_core) e [Firebase Auth](https://pub.dev/packages/firebase_auth) para autenticação.
    *   [Cloud Firestore](https://pub.dev/packages/cloud_firestore) para persistência em tempo real e sincronização de decks.
    *   [Google Sign-In](https://pub.dev/packages/google_sign_in) para login simplificado social.
*   **Recursos do Dispositivo Móvel**:
    *   [Camera](https://pub.dev/packages/camera) para captura de imagens.
    *   [Geolocator](https://pub.dev/packages/geolocator) para registrar a posição GPS do usuário.
    *   [Google ML Kit Text Recognition](https://pub.dev/packages/google_mlkit_text_recognition) para inteligência de OCR.
    *   [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications) para avisos do sistema.
    *   [Permission Handler](https://pub.dev/packages/permission_handler) para gerenciamento elegante de permissões nativas.

---

## 📁 Estrutura do Código (`lib/`)

```txt
lib/
├── core/
│   ├── router/          # Configuração declarativa de rotas do GoRouter
│   └── theme/           # Paleta de cores, tipografia e estilos globais
├── data/
│   ├── local/           # Serviços de persistência local (Hive e Sqflite)
│   ├── pokedex/         # Repositório de leitura dos dados locais de cartas (assets)
│   └── repositories/    # Sincronização remota com Firestore e regras de sincronia
├── domain/
│   └── models/          # Modelos de dados e lógica interna imutável (freezed)
├── presentation/
│   ├── providers/       # Riverpod providers para controle de estado (Auth, Decks, Battle)
│   ├── screens/         # Telas principais (Battle, Deck Detail, Home, Onboarding, Plans, Profile)
│   └── widgets/         # Componentes reutilizáveis de interface
├── app.dart             # Widget raiz de configuração do aplicativo
├── firebase_options.dart # Configurações de plataforma autogeradas pelo Firebase CLI
└── main.dart            # Ponto de entrada (inicialização de serviços e execução do app)
```

---

## ⚙️ Como Executar o Projeto

### Pré-requisitos
1. Ter o **SDK do Flutter** instalado (versão `>= 3.1.5`).
2. Configuração de um emulador de dispositivo móvel ou aparelho físico com depuração USB ativada (Android/iOS).
3. (Opcional) Configurar um projeto no console do Firebase para associar as chaves de API e gerar o arquivo `firebase_options.dart` para sua própria instância de banco de dados.

### Instalação

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/Erohf/Pokenion.git
    cd pokenion
    ```

2.  **Instale as dependências do projeto:**
    ```bash
    flutter pub get
    ```

3.  **Execute a geração de código (Freezed e Riverpod Generators):**
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Execute o aplicativo no seu dispositivo/emulador:**
    ```bash
    flutter run
    ```

---

## 👥 Integrantes

*   **Lucas Sampaio Souza Andrade** — Matrícula: `220115578`
*   **Francisco Silva Santana** — Matrícula: `222216228`

---

## 📃 Informações do Projeto

Para obter detalhes abrangentes sobre a arquitetura do projeto, os recursos do celular empregados, o mapeamento de APIs consumidas e os principais desafios técnicos superados com suas respectivas soluções de engenharia, consulte o arquivo **[about.html](file:///c:/Users/Lucas/Documents/.Dev/Pokenion/about.html)** na raiz deste projeto.
