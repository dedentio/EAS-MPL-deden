import 'package:flutter_bloc/flutter_bloc.dart';
import 'news_event.dart';
import 'news_state.dart';
import '../../data/repositories/news_repository_impl.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepositoryImpl _newsRepository;

  NewsBloc(this._newsRepository) : super(NewsLoading()) {
    on<LoadNewsEvent>((event, emit) async {
      emit(NewsLoading());
      try {
        // Memanggil data dari Repository (yang sudah otomatis tersortir Z ke A karena NIM Ganjil)
        final articles = await _newsRepository.fetchNews();
        emit(NewsSuccess(articles));
      } catch (e) {
        emit(NewsError(e.toString()));
      }
    });
  }
}