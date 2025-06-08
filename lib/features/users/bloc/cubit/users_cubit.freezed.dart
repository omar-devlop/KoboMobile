// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'users_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UsersState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String msg) loading,
    required TResult Function(List<Account> data, String? loggingUserName)
        savedUsers,
    required TResult Function() empty,
    required TResult Function(
            List<Account> data, String? loggingUserName, String error)
        loginError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String msg)? loading,
    TResult? Function(List<Account> data, String? loggingUserName)? savedUsers,
    TResult? Function()? empty,
    TResult? Function(
            List<Account> data, String? loggingUserName, String error)?
        loginError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String msg)? loading,
    TResult Function(List<Account> data, String? loggingUserName)? savedUsers,
    TResult Function()? empty,
    TResult Function(List<Account> data, String? loggingUserName, String error)?
        loginError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Loading value) loading,
    required TResult Function(SavedUsers value) savedUsers,
    required TResult Function(Empty value) empty,
    required TResult Function(LoginError value) loginError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Loading value)? loading,
    TResult? Function(SavedUsers value)? savedUsers,
    TResult? Function(Empty value)? empty,
    TResult? Function(LoginError value)? loginError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Loading value)? loading,
    TResult Function(SavedUsers value)? savedUsers,
    TResult Function(Empty value)? empty,
    TResult Function(LoginError value)? loginError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsersStateCopyWith<$Res> {
  factory $UsersStateCopyWith(
          UsersState value, $Res Function(UsersState) then) =
      _$UsersStateCopyWithImpl<$Res, UsersState>;
}

/// @nodoc
class _$UsersStateCopyWithImpl<$Res, $Val extends UsersState>
    implements $UsersStateCopyWith<$Res> {
  _$UsersStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UsersState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String msg});
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$UsersStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of UsersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? msg = null,
  }) {
    return _then(_$LoadingImpl(
      msg: null == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LoadingImpl implements Loading {
  const _$LoadingImpl({required this.msg});

  @override
  final String msg;

  @override
  String toString() {
    return 'UsersState.loading(msg: $msg)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadingImpl &&
            (identical(other.msg, msg) || other.msg == msg));
  }

  @override
  int get hashCode => Object.hash(runtimeType, msg);

  /// Create a copy of UsersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadingImplCopyWith<_$LoadingImpl> get copyWith =>
      __$$LoadingImplCopyWithImpl<_$LoadingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String msg) loading,
    required TResult Function(List<Account> data, String? loggingUserName)
        savedUsers,
    required TResult Function() empty,
    required TResult Function(
            List<Account> data, String? loggingUserName, String error)
        loginError,
  }) {
    return loading(msg);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String msg)? loading,
    TResult? Function(List<Account> data, String? loggingUserName)? savedUsers,
    TResult? Function()? empty,
    TResult? Function(
            List<Account> data, String? loggingUserName, String error)?
        loginError,
  }) {
    return loading?.call(msg);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String msg)? loading,
    TResult Function(List<Account> data, String? loggingUserName)? savedUsers,
    TResult Function()? empty,
    TResult Function(List<Account> data, String? loggingUserName, String error)?
        loginError,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(msg);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Loading value) loading,
    required TResult Function(SavedUsers value) savedUsers,
    required TResult Function(Empty value) empty,
    required TResult Function(LoginError value) loginError,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Loading value)? loading,
    TResult? Function(SavedUsers value)? savedUsers,
    TResult? Function(Empty value)? empty,
    TResult? Function(LoginError value)? loginError,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Loading value)? loading,
    TResult Function(SavedUsers value)? savedUsers,
    TResult Function(Empty value)? empty,
    TResult Function(LoginError value)? loginError,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading implements UsersState {
  const factory Loading({required final String msg}) = _$LoadingImpl;

  String get msg;

  /// Create a copy of UsersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadingImplCopyWith<_$LoadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SavedUsersImplCopyWith<$Res> {
  factory _$$SavedUsersImplCopyWith(
          _$SavedUsersImpl value, $Res Function(_$SavedUsersImpl) then) =
      __$$SavedUsersImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Account> data, String? loggingUserName});
}

/// @nodoc
class __$$SavedUsersImplCopyWithImpl<$Res>
    extends _$UsersStateCopyWithImpl<$Res, _$SavedUsersImpl>
    implements _$$SavedUsersImplCopyWith<$Res> {
  __$$SavedUsersImplCopyWithImpl(
      _$SavedUsersImpl _value, $Res Function(_$SavedUsersImpl) _then)
      : super(_value, _then);

  /// Create a copy of UsersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? loggingUserName = freezed,
  }) {
    return _then(_$SavedUsersImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Account>,
      loggingUserName: freezed == loggingUserName
          ? _value.loggingUserName
          : loggingUserName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SavedUsersImpl implements SavedUsers {
  const _$SavedUsersImpl(
      {required final List<Account> data, this.loggingUserName})
      : _data = data;

  final List<Account> _data;
  @override
  List<Account> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final String? loggingUserName;

  @override
  String toString() {
    return 'UsersState.savedUsers(data: $data, loggingUserName: $loggingUserName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavedUsersImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.loggingUserName, loggingUserName) ||
                other.loggingUserName == loggingUserName));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_data), loggingUserName);

  /// Create a copy of UsersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavedUsersImplCopyWith<_$SavedUsersImpl> get copyWith =>
      __$$SavedUsersImplCopyWithImpl<_$SavedUsersImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String msg) loading,
    required TResult Function(List<Account> data, String? loggingUserName)
        savedUsers,
    required TResult Function() empty,
    required TResult Function(
            List<Account> data, String? loggingUserName, String error)
        loginError,
  }) {
    return savedUsers(data, loggingUserName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String msg)? loading,
    TResult? Function(List<Account> data, String? loggingUserName)? savedUsers,
    TResult? Function()? empty,
    TResult? Function(
            List<Account> data, String? loggingUserName, String error)?
        loginError,
  }) {
    return savedUsers?.call(data, loggingUserName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String msg)? loading,
    TResult Function(List<Account> data, String? loggingUserName)? savedUsers,
    TResult Function()? empty,
    TResult Function(List<Account> data, String? loggingUserName, String error)?
        loginError,
    required TResult orElse(),
  }) {
    if (savedUsers != null) {
      return savedUsers(data, loggingUserName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Loading value) loading,
    required TResult Function(SavedUsers value) savedUsers,
    required TResult Function(Empty value) empty,
    required TResult Function(LoginError value) loginError,
  }) {
    return savedUsers(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Loading value)? loading,
    TResult? Function(SavedUsers value)? savedUsers,
    TResult? Function(Empty value)? empty,
    TResult? Function(LoginError value)? loginError,
  }) {
    return savedUsers?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Loading value)? loading,
    TResult Function(SavedUsers value)? savedUsers,
    TResult Function(Empty value)? empty,
    TResult Function(LoginError value)? loginError,
    required TResult orElse(),
  }) {
    if (savedUsers != null) {
      return savedUsers(this);
    }
    return orElse();
  }
}

abstract class SavedUsers implements UsersState {
  const factory SavedUsers(
      {required final List<Account> data,
      final String? loggingUserName}) = _$SavedUsersImpl;

  List<Account> get data;
  String? get loggingUserName;

  /// Create a copy of UsersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavedUsersImplCopyWith<_$SavedUsersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EmptyImplCopyWith<$Res> {
  factory _$$EmptyImplCopyWith(
          _$EmptyImpl value, $Res Function(_$EmptyImpl) then) =
      __$$EmptyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$EmptyImplCopyWithImpl<$Res>
    extends _$UsersStateCopyWithImpl<$Res, _$EmptyImpl>
    implements _$$EmptyImplCopyWith<$Res> {
  __$$EmptyImplCopyWithImpl(
      _$EmptyImpl _value, $Res Function(_$EmptyImpl) _then)
      : super(_value, _then);

  /// Create a copy of UsersState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$EmptyImpl implements Empty {
  const _$EmptyImpl();

  @override
  String toString() {
    return 'UsersState.empty()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$EmptyImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String msg) loading,
    required TResult Function(List<Account> data, String? loggingUserName)
        savedUsers,
    required TResult Function() empty,
    required TResult Function(
            List<Account> data, String? loggingUserName, String error)
        loginError,
  }) {
    return empty();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String msg)? loading,
    TResult? Function(List<Account> data, String? loggingUserName)? savedUsers,
    TResult? Function()? empty,
    TResult? Function(
            List<Account> data, String? loggingUserName, String error)?
        loginError,
  }) {
    return empty?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String msg)? loading,
    TResult Function(List<Account> data, String? loggingUserName)? savedUsers,
    TResult Function()? empty,
    TResult Function(List<Account> data, String? loggingUserName, String error)?
        loginError,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Loading value) loading,
    required TResult Function(SavedUsers value) savedUsers,
    required TResult Function(Empty value) empty,
    required TResult Function(LoginError value) loginError,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Loading value)? loading,
    TResult? Function(SavedUsers value)? savedUsers,
    TResult? Function(Empty value)? empty,
    TResult? Function(LoginError value)? loginError,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Loading value)? loading,
    TResult Function(SavedUsers value)? savedUsers,
    TResult Function(Empty value)? empty,
    TResult Function(LoginError value)? loginError,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class Empty implements UsersState {
  const factory Empty() = _$EmptyImpl;
}

/// @nodoc
abstract class _$$LoginErrorImplCopyWith<$Res> {
  factory _$$LoginErrorImplCopyWith(
          _$LoginErrorImpl value, $Res Function(_$LoginErrorImpl) then) =
      __$$LoginErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Account> data, String? loggingUserName, String error});
}

/// @nodoc
class __$$LoginErrorImplCopyWithImpl<$Res>
    extends _$UsersStateCopyWithImpl<$Res, _$LoginErrorImpl>
    implements _$$LoginErrorImplCopyWith<$Res> {
  __$$LoginErrorImplCopyWithImpl(
      _$LoginErrorImpl _value, $Res Function(_$LoginErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of UsersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? loggingUserName = freezed,
    Object? error = null,
  }) {
    return _then(_$LoginErrorImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Account>,
      loggingUserName: freezed == loggingUserName
          ? _value.loggingUserName
          : loggingUserName // ignore: cast_nullable_to_non_nullable
              as String?,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LoginErrorImpl implements LoginError {
  const _$LoginErrorImpl(
      {required final List<Account> data,
      this.loggingUserName,
      required this.error})
      : _data = data;

  final List<Account> _data;
  @override
  List<Account> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final String? loggingUserName;
  @override
  final String error;

  @override
  String toString() {
    return 'UsersState.loginError(data: $data, loggingUserName: $loggingUserName, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginErrorImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.loggingUserName, loggingUserName) ||
                other.loggingUserName == loggingUserName) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_data), loggingUserName, error);

  /// Create a copy of UsersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginErrorImplCopyWith<_$LoginErrorImpl> get copyWith =>
      __$$LoginErrorImplCopyWithImpl<_$LoginErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String msg) loading,
    required TResult Function(List<Account> data, String? loggingUserName)
        savedUsers,
    required TResult Function() empty,
    required TResult Function(
            List<Account> data, String? loggingUserName, String error)
        loginError,
  }) {
    return loginError(data, loggingUserName, error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String msg)? loading,
    TResult? Function(List<Account> data, String? loggingUserName)? savedUsers,
    TResult? Function()? empty,
    TResult? Function(
            List<Account> data, String? loggingUserName, String error)?
        loginError,
  }) {
    return loginError?.call(data, loggingUserName, error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String msg)? loading,
    TResult Function(List<Account> data, String? loggingUserName)? savedUsers,
    TResult Function()? empty,
    TResult Function(List<Account> data, String? loggingUserName, String error)?
        loginError,
    required TResult orElse(),
  }) {
    if (loginError != null) {
      return loginError(data, loggingUserName, error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Loading value) loading,
    required TResult Function(SavedUsers value) savedUsers,
    required TResult Function(Empty value) empty,
    required TResult Function(LoginError value) loginError,
  }) {
    return loginError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Loading value)? loading,
    TResult? Function(SavedUsers value)? savedUsers,
    TResult? Function(Empty value)? empty,
    TResult? Function(LoginError value)? loginError,
  }) {
    return loginError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Loading value)? loading,
    TResult Function(SavedUsers value)? savedUsers,
    TResult Function(Empty value)? empty,
    TResult Function(LoginError value)? loginError,
    required TResult orElse(),
  }) {
    if (loginError != null) {
      return loginError(this);
    }
    return orElse();
  }
}

abstract class LoginError implements UsersState {
  const factory LoginError(
      {required final List<Account> data,
      final String? loggingUserName,
      required final String error}) = _$LoginErrorImpl;

  List<Account> get data;
  String? get loggingUserName;
  String get error;

  /// Create a copy of UsersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginErrorImplCopyWith<_$LoginErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
