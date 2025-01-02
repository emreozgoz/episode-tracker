import 'package:flutter/material.dart';

class Genre {
  final int id;
  final String name;
  final IconData icon;

  Genre({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    IconData getIconForGenre(int id) {
      switch (id) {
        case 10759: return Icons.sports_martial_arts;
        case 16: return Icons.animation;
        case 35: return Icons.theater_comedy;
        case 80: return Icons.local_police;
        case 99: return Icons.document_scanner;
        case 18: return Icons.theater_comedy;
        case 10751: return Icons.family_restroom;
        case 10762: return Icons.child_care;
        case 9648: return Icons.psychology;
        case 10763: return Icons.newspaper;
        case 10764: return Icons.movie;
        case 10765: return Icons.auto_fix_high;
        case 10766: return Icons.soap;
        case 10767: return Icons.tv;
        case 10768: return Icons.military_tech;
        default: return Icons.tv;
      }
    }

    return Genre(
      id: json['id'],
      name: json['name'],
      icon: getIconForGenre(json['id']),
    );
  }
} 