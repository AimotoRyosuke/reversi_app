// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hint_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HintSettings {
  /// ヒント表示モード
  HintDisplayMode get displayMode => throw _privateConstructorUsedError;

  /// ミニマックスアルゴリズムの深さ
  int get minimaxDepth => throw _privateConstructorUsedError;

  /// Create a copy of HintSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HintSettingsCopyWith<HintSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HintSettingsCopyWith<$Res> {
  factory $HintSettingsCopyWith(
          HintSettings value, $Res Function(HintSettings) then) =
      _$HintSettingsCopyWithImpl<$Res, HintSettings>;
  @useResult
  $Res call({HintDisplayMode displayMode, int minimaxDepth});
}

/// @nodoc
class _$HintSettingsCopyWithImpl<$Res, $Val extends HintSettings>
    implements $HintSettingsCopyWith<$Res> {
  _$HintSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HintSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayMode = null,
    Object? minimaxDepth = null,
  }) {
    return _then(_value.copyWith(
      displayMode: null == displayMode
          ? _value.displayMode
          : displayMode // ignore: cast_nullable_to_non_nullable
              as HintDisplayMode,
      minimaxDepth: null == minimaxDepth
          ? _value.minimaxDepth
          : minimaxDepth // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HintSettingsImplCopyWith<$Res>
    implements $HintSettingsCopyWith<$Res> {
  factory _$$HintSettingsImplCopyWith(
          _$HintSettingsImpl value, $Res Function(_$HintSettingsImpl) then) =
      __$$HintSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({HintDisplayMode displayMode, int minimaxDepth});
}

/// @nodoc
class __$$HintSettingsImplCopyWithImpl<$Res>
    extends _$HintSettingsCopyWithImpl<$Res, _$HintSettingsImpl>
    implements _$$HintSettingsImplCopyWith<$Res> {
  __$$HintSettingsImplCopyWithImpl(
      _$HintSettingsImpl _value, $Res Function(_$HintSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of HintSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayMode = null,
    Object? minimaxDepth = null,
  }) {
    return _then(_$HintSettingsImpl(
      displayMode: null == displayMode
          ? _value.displayMode
          : displayMode // ignore: cast_nullable_to_non_nullable
              as HintDisplayMode,
      minimaxDepth: null == minimaxDepth
          ? _value.minimaxDepth
          : minimaxDepth // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$HintSettingsImpl implements _HintSettings {
  const _$HintSettingsImpl(
      {this.displayMode = HintDisplayMode.none, this.minimaxDepth = 4});

  /// ヒント表示モード
  @override
  @JsonKey()
  final HintDisplayMode displayMode;

  /// ミニマックスアルゴリズムの深さ
  @override
  @JsonKey()
  final int minimaxDepth;

  @override
  String toString() {
    return 'HintSettings(displayMode: $displayMode, minimaxDepth: $minimaxDepth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HintSettingsImpl &&
            (identical(other.displayMode, displayMode) ||
                other.displayMode == displayMode) &&
            (identical(other.minimaxDepth, minimaxDepth) ||
                other.minimaxDepth == minimaxDepth));
  }

  @override
  int get hashCode => Object.hash(runtimeType, displayMode, minimaxDepth);

  /// Create a copy of HintSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HintSettingsImplCopyWith<_$HintSettingsImpl> get copyWith =>
      __$$HintSettingsImplCopyWithImpl<_$HintSettingsImpl>(this, _$identity);
}

abstract class _HintSettings implements HintSettings {
  const factory _HintSettings(
      {final HintDisplayMode displayMode,
      final int minimaxDepth}) = _$HintSettingsImpl;

  /// ヒント表示モード
  @override
  HintDisplayMode get displayMode;

  /// ミニマックスアルゴリズムの深さ
  @override
  int get minimaxDepth;

  /// Create a copy of HintSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HintSettingsImplCopyWith<_$HintSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
