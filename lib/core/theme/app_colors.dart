import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const bg        = Color(0xFF13131F);  // Fundo principal (quase preto)
  static const surface   = Color(0xFF1E1E2E);  // Cards/painéis
  static const surface2  = Color(0xFF252538);  // Cards aninhados
  static const surfaceVariant = Color(0xFFF2F2F3); // De acordo com Figma (base-050)
  
  // Borders
  static const border    = Color(0xFF2E2E45);  // Bordas sutis
  static const borderVariant = Color(0xFFE4E5E7); // De acordo com Figma (base-100)
  
  // Primary
  static const blue      = Color(0xFF4D8EFF);  // Azul primário (botões, ícones, destaque)
  static const blueDark  = Color(0xFF2A5FCC);  // Azul escuro (hover/press states)
  static const blueLight = Color(0xFF6BA3FF);  // Azul claro (texto highlight)
  
  // Text
  static const textPrimary   = Color(0xFFFFFFFF);  // Texto principal
  static const textSecondary = Color(0xFF9090A8);  // Texto secundário
  static const textDim       = Color(0xFF5A5A72);  // Texto muito sutil
  static const textBlack     = Color(0xFF000000);
  static const textDark      = Color(0xFF303236); // base-800
  
  // Semantic
  static const green   = Color(0xFF3DCB8E);  // Sucesso / HP alto
  static const yellow  = Color(0xFFF5C542);  // Aviso / HP médio
  static const red     = Color(0xFFE05252);  // Perigo / HP baixo / KO
  
  // Energy types (from context)
  static const energyFire       = Color(0xFFE05252);
  static const energyWater      = Color(0xFF4D9EFF);
  static const energyGrass      = Color(0xFF4DBF7A);
  static const energyLightning  = Color(0xFFF5C542);
  static const energyPsychic    = Color(0xFFB06DDD);
  static const energyFighting   = Color(0xFFCC8844);
  static const energyDarkness   = Color(0xFF5A5A8A);
  static const energyMetal      = Color(0xFF9090B8);
  static const energyDragon     = Color(0xFF6A8FDD);
  static const energyColorless  = Color(0xFFAAAAAA);
}
