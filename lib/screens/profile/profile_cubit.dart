import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/auth_service.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthService authService;

  ProfileCubit({required this.authService}) : super(const ProfileInitial());

  void saveName(String name) {
    print('✅ Name saved: $name');
    emit(ProfileSaved());
  }

  Future<void> logout() async {
    await authService.logout();
    emit(ProfileLoggedOut());
  }
}
