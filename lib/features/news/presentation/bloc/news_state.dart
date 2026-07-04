import 'package:equatable/equatable.dart';
import '../../domain/models/article.dart';

abstract class NewsState extends Equatable {
  const NewsState();
  
  @override
  List<Object> get props => [];
}

// 1. Status Saat Menunggu Data (Loading Spinner)
class NewsLoading extends NewsState {}

// 2. Status Saat Data Berhasil Dimuat (Tampilan Data)
class NewsSuccess extends NewsState {
  final List<Article> articles;

  const NewsSuccess(this.articles);

  @override
  List<Object> get props => [articles];
}

// 3. Status Saat Gagal/Koneksi Mati (Pesan Error)
class NewsError extends NewsState {
  final String errorMessage;

  const NewsError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}