import 'package:bloc/bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.topStories);

  void setTab(int selectedTab) {
    switch (selectedTab) {
      case 0:
        return emit(HomeState.topStories);
      case 1:
        return emit(HomeState.search);
      case 2:
        return emit(HomeState.subscribe);
    }
  }
}

enum HomeState {
  topStories(0),
  search(1),
  subscribe(2);

  const HomeState(this.tabIndex);
  final int tabIndex;
}
