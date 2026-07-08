# Pokénion — Plano das novas mudanças

Decisões: Mapa = flutter_map (OSM, sem chave) + geolocator. Street View = pulado (placeholder). Foto de perfil = image_picker (câmera+galeria), permissões nativas adicionadas por mim.

Ordem de implementação: F5 → F4 → F2 → F1 → F3 (modo claro por último, cobre telas novas numa passada).

## F5 — Salvar/Cancelar em criação/edição de deck
Editor passa a usar rascunho (working copy) local. Adições/remoções/capa/nome não tocam o store até Salvar. Cancelar descarta (na criação, deck não passa a existir). Substituir botão inferior "Iniciar Batalha" por Salvar/Cancelar. Ajustar fluxo de criação (Home) p/ não persistir até salvar.

## F4 — Evoluir Pokémon do banco (batalha)
Tocar no Pokémon do banco → menu (Trocar / Evoluir). Evoluir por índice do banco: mesmas regras (evolução no deck, saldo de HP, limpa status). Novo método `evolveBench(index, card)` no battle_provider.

## F2 — Foto de perfil real
Editar foto → sheet: Avatares / Câmera / Galeria. image_picker p/ câmera+galeria. Persistir caminho no perfil (Hive) + exibir. Strings de permissão iOS/Android.

## F1 — Eventos próximos
flutter_map + geolocator. Centraliza no usuário; pin de evento aleatório próximo. Ao arrastar → botão "Procurar eventos nesta região" gera pin na área visível. Sheet do pin: nome, tipo (Torneio/Troca/Ambos), data, distância, organizador (mock determinístico). Placeholder de foto. Nova rota + acesso via nav/perfil.

## F3 — Modo claro
Camada de cores por contexto (ThemeExtension `AppPalette` / `context.palette`). Derivar paleta clara dos protótipos light/. Trocar usos fixos de AppColors por palette em todas as telas. Layout/funcionalidade inalterados. Tema já persiste em Settings.
