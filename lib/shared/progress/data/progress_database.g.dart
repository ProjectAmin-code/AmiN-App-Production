// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_database.dart';

// ignore_for_file: type=lint
class $StudentProfilesTable extends StudentProfiles
    with TableInfo<$StudentProfilesTable, StudentProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firebaseUidMeta = const VerificationMeta(
    'firebaseUid',
  );
  @override
  late final GeneratedColumn<String> firebaseUid = GeneratedColumn<String>(
    'firebase_uid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publicStudentIdMeta = const VerificationMeta(
    'publicStudentId',
  );
  @override
  late final GeneratedColumn<String> publicStudentId = GeneratedColumn<String>(
    'public_student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authStateMeta = const VerificationMeta(
    'authState',
  );
  @override
  late final GeneratedColumn<String> authState = GeneratedColumn<String>(
    'auth_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _legacyUserIdMeta = const VerificationMeta(
    'legacyUserId',
  );
  @override
  late final GeneratedColumn<String> legacyUserId = GeneratedColumn<String>(
    'legacy_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMillisMeta = const VerificationMeta(
    'createdAtMillis',
  );
  @override
  late final GeneratedColumn<int> createdAtMillis = GeneratedColumn<int>(
    'created_at_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMillisMeta = const VerificationMeta(
    'updatedAtMillis',
  );
  @override
  late final GeneratedColumn<int> updatedAtMillis = GeneratedColumn<int>(
    'updated_at_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    firebaseUid,
    publicStudentId,
    displayName,
    authState,
    legacyUserId,
    createdAtMillis,
    updatedAtMillis,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'student_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudentProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('firebase_uid')) {
      context.handle(
        _firebaseUidMeta,
        firebaseUid.isAcceptableOrUnknown(
          data['firebase_uid']!,
          _firebaseUidMeta,
        ),
      );
    }
    if (data.containsKey('public_student_id')) {
      context.handle(
        _publicStudentIdMeta,
        publicStudentId.isAcceptableOrUnknown(
          data['public_student_id']!,
          _publicStudentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_publicStudentIdMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('auth_state')) {
      context.handle(
        _authStateMeta,
        authState.isAcceptableOrUnknown(data['auth_state']!, _authStateMeta),
      );
    }
    if (data.containsKey('legacy_user_id')) {
      context.handle(
        _legacyUserIdMeta,
        legacyUserId.isAcceptableOrUnknown(
          data['legacy_user_id']!,
          _legacyUserIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at_millis')) {
      context.handle(
        _createdAtMillisMeta,
        createdAtMillis.isAcceptableOrUnknown(
          data['created_at_millis']!,
          _createdAtMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtMillisMeta);
    }
    if (data.containsKey('updated_at_millis')) {
      context.handle(
        _updatedAtMillisMeta,
        updatedAtMillis.isAcceptableOrUnknown(
          data['updated_at_millis']!,
          _updatedAtMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMillisMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  StudentProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudentProfile(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      firebaseUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}firebase_uid'],
      ),
      publicStudentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}public_student_id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      authState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}auth_state'],
      )!,
      legacyUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}legacy_user_id'],
      ),
      createdAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_millis'],
      )!,
      updatedAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_millis'],
      )!,
    );
  }

  @override
  $StudentProfilesTable createAlias(String alias) {
    return $StudentProfilesTable(attachedDatabase, alias);
  }
}

class StudentProfile extends DataClass implements Insertable<StudentProfile> {
  final String localId;
  final String? firebaseUid;
  final String publicStudentId;
  final String displayName;
  final String authState;
  final String? legacyUserId;
  final int createdAtMillis;
  final int updatedAtMillis;
  const StudentProfile({
    required this.localId,
    this.firebaseUid,
    required this.publicStudentId,
    required this.displayName,
    required this.authState,
    this.legacyUserId,
    required this.createdAtMillis,
    required this.updatedAtMillis,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || firebaseUid != null) {
      map['firebase_uid'] = Variable<String>(firebaseUid);
    }
    map['public_student_id'] = Variable<String>(publicStudentId);
    map['display_name'] = Variable<String>(displayName);
    map['auth_state'] = Variable<String>(authState);
    if (!nullToAbsent || legacyUserId != null) {
      map['legacy_user_id'] = Variable<String>(legacyUserId);
    }
    map['created_at_millis'] = Variable<int>(createdAtMillis);
    map['updated_at_millis'] = Variable<int>(updatedAtMillis);
    return map;
  }

  StudentProfilesCompanion toCompanion(bool nullToAbsent) {
    return StudentProfilesCompanion(
      localId: Value(localId),
      firebaseUid: firebaseUid == null && nullToAbsent
          ? const Value.absent()
          : Value(firebaseUid),
      publicStudentId: Value(publicStudentId),
      displayName: Value(displayName),
      authState: Value(authState),
      legacyUserId: legacyUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(legacyUserId),
      createdAtMillis: Value(createdAtMillis),
      updatedAtMillis: Value(updatedAtMillis),
    );
  }

  factory StudentProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudentProfile(
      localId: serializer.fromJson<String>(json['localId']),
      firebaseUid: serializer.fromJson<String?>(json['firebaseUid']),
      publicStudentId: serializer.fromJson<String>(json['publicStudentId']),
      displayName: serializer.fromJson<String>(json['displayName']),
      authState: serializer.fromJson<String>(json['authState']),
      legacyUserId: serializer.fromJson<String?>(json['legacyUserId']),
      createdAtMillis: serializer.fromJson<int>(json['createdAtMillis']),
      updatedAtMillis: serializer.fromJson<int>(json['updatedAtMillis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'firebaseUid': serializer.toJson<String?>(firebaseUid),
      'publicStudentId': serializer.toJson<String>(publicStudentId),
      'displayName': serializer.toJson<String>(displayName),
      'authState': serializer.toJson<String>(authState),
      'legacyUserId': serializer.toJson<String?>(legacyUserId),
      'createdAtMillis': serializer.toJson<int>(createdAtMillis),
      'updatedAtMillis': serializer.toJson<int>(updatedAtMillis),
    };
  }

  StudentProfile copyWith({
    String? localId,
    Value<String?> firebaseUid = const Value.absent(),
    String? publicStudentId,
    String? displayName,
    String? authState,
    Value<String?> legacyUserId = const Value.absent(),
    int? createdAtMillis,
    int? updatedAtMillis,
  }) => StudentProfile(
    localId: localId ?? this.localId,
    firebaseUid: firebaseUid.present ? firebaseUid.value : this.firebaseUid,
    publicStudentId: publicStudentId ?? this.publicStudentId,
    displayName: displayName ?? this.displayName,
    authState: authState ?? this.authState,
    legacyUserId: legacyUserId.present ? legacyUserId.value : this.legacyUserId,
    createdAtMillis: createdAtMillis ?? this.createdAtMillis,
    updatedAtMillis: updatedAtMillis ?? this.updatedAtMillis,
  );
  StudentProfile copyWithCompanion(StudentProfilesCompanion data) {
    return StudentProfile(
      localId: data.localId.present ? data.localId.value : this.localId,
      firebaseUid: data.firebaseUid.present
          ? data.firebaseUid.value
          : this.firebaseUid,
      publicStudentId: data.publicStudentId.present
          ? data.publicStudentId.value
          : this.publicStudentId,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      authState: data.authState.present ? data.authState.value : this.authState,
      legacyUserId: data.legacyUserId.present
          ? data.legacyUserId.value
          : this.legacyUserId,
      createdAtMillis: data.createdAtMillis.present
          ? data.createdAtMillis.value
          : this.createdAtMillis,
      updatedAtMillis: data.updatedAtMillis.present
          ? data.updatedAtMillis.value
          : this.updatedAtMillis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudentProfile(')
          ..write('localId: $localId, ')
          ..write('firebaseUid: $firebaseUid, ')
          ..write('publicStudentId: $publicStudentId, ')
          ..write('displayName: $displayName, ')
          ..write('authState: $authState, ')
          ..write('legacyUserId: $legacyUserId, ')
          ..write('createdAtMillis: $createdAtMillis, ')
          ..write('updatedAtMillis: $updatedAtMillis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    firebaseUid,
    publicStudentId,
    displayName,
    authState,
    legacyUserId,
    createdAtMillis,
    updatedAtMillis,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudentProfile &&
          other.localId == this.localId &&
          other.firebaseUid == this.firebaseUid &&
          other.publicStudentId == this.publicStudentId &&
          other.displayName == this.displayName &&
          other.authState == this.authState &&
          other.legacyUserId == this.legacyUserId &&
          other.createdAtMillis == this.createdAtMillis &&
          other.updatedAtMillis == this.updatedAtMillis);
}

class StudentProfilesCompanion extends UpdateCompanion<StudentProfile> {
  final Value<String> localId;
  final Value<String?> firebaseUid;
  final Value<String> publicStudentId;
  final Value<String> displayName;
  final Value<String> authState;
  final Value<String?> legacyUserId;
  final Value<int> createdAtMillis;
  final Value<int> updatedAtMillis;
  final Value<int> rowid;
  const StudentProfilesCompanion({
    this.localId = const Value.absent(),
    this.firebaseUid = const Value.absent(),
    this.publicStudentId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.authState = const Value.absent(),
    this.legacyUserId = const Value.absent(),
    this.createdAtMillis = const Value.absent(),
    this.updatedAtMillis = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentProfilesCompanion.insert({
    required String localId,
    this.firebaseUid = const Value.absent(),
    required String publicStudentId,
    required String displayName,
    this.authState = const Value.absent(),
    this.legacyUserId = const Value.absent(),
    required int createdAtMillis,
    required int updatedAtMillis,
    this.rowid = const Value.absent(),
  }) : localId = Value(localId),
       publicStudentId = Value(publicStudentId),
       displayName = Value(displayName),
       createdAtMillis = Value(createdAtMillis),
       updatedAtMillis = Value(updatedAtMillis);
  static Insertable<StudentProfile> custom({
    Expression<String>? localId,
    Expression<String>? firebaseUid,
    Expression<String>? publicStudentId,
    Expression<String>? displayName,
    Expression<String>? authState,
    Expression<String>? legacyUserId,
    Expression<int>? createdAtMillis,
    Expression<int>? updatedAtMillis,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (firebaseUid != null) 'firebase_uid': firebaseUid,
      if (publicStudentId != null) 'public_student_id': publicStudentId,
      if (displayName != null) 'display_name': displayName,
      if (authState != null) 'auth_state': authState,
      if (legacyUserId != null) 'legacy_user_id': legacyUserId,
      if (createdAtMillis != null) 'created_at_millis': createdAtMillis,
      if (updatedAtMillis != null) 'updated_at_millis': updatedAtMillis,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentProfilesCompanion copyWith({
    Value<String>? localId,
    Value<String?>? firebaseUid,
    Value<String>? publicStudentId,
    Value<String>? displayName,
    Value<String>? authState,
    Value<String?>? legacyUserId,
    Value<int>? createdAtMillis,
    Value<int>? updatedAtMillis,
    Value<int>? rowid,
  }) {
    return StudentProfilesCompanion(
      localId: localId ?? this.localId,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      publicStudentId: publicStudentId ?? this.publicStudentId,
      displayName: displayName ?? this.displayName,
      authState: authState ?? this.authState,
      legacyUserId: legacyUserId ?? this.legacyUserId,
      createdAtMillis: createdAtMillis ?? this.createdAtMillis,
      updatedAtMillis: updatedAtMillis ?? this.updatedAtMillis,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (firebaseUid.present) {
      map['firebase_uid'] = Variable<String>(firebaseUid.value);
    }
    if (publicStudentId.present) {
      map['public_student_id'] = Variable<String>(publicStudentId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (authState.present) {
      map['auth_state'] = Variable<String>(authState.value);
    }
    if (legacyUserId.present) {
      map['legacy_user_id'] = Variable<String>(legacyUserId.value);
    }
    if (createdAtMillis.present) {
      map['created_at_millis'] = Variable<int>(createdAtMillis.value);
    }
    if (updatedAtMillis.present) {
      map['updated_at_millis'] = Variable<int>(updatedAtMillis.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentProfilesCompanion(')
          ..write('localId: $localId, ')
          ..write('firebaseUid: $firebaseUid, ')
          ..write('publicStudentId: $publicStudentId, ')
          ..write('displayName: $displayName, ')
          ..write('authState: $authState, ')
          ..write('legacyUserId: $legacyUserId, ')
          ..write('createdAtMillis: $createdAtMillis, ')
          ..write('updatedAtMillis: $updatedAtMillis, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InstallationsTable extends Installations
    with TableInfo<$InstallationsTable, Installation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InstallationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _installationIdMeta = const VerificationMeta(
    'installationId',
  );
  @override
  late final GeneratedColumn<String> installationId = GeneratedColumn<String>(
    'installation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localProfileIdMeta = const VerificationMeta(
    'localProfileId',
  );
  @override
  late final GeneratedColumn<String> localProfileId = GeneratedColumn<String>(
    'local_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appVersionMeta = const VerificationMeta(
    'appVersion',
  );
  @override
  late final GeneratedColumn<String> appVersion = GeneratedColumn<String>(
    'app_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstSeenAtMillisMeta = const VerificationMeta(
    'firstSeenAtMillis',
  );
  @override
  late final GeneratedColumn<int> firstSeenAtMillis = GeneratedColumn<int>(
    'first_seen_at_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSeenAtMillisMeta = const VerificationMeta(
    'lastSeenAtMillis',
  );
  @override
  late final GeneratedColumn<int> lastSeenAtMillis = GeneratedColumn<int>(
    'last_seen_at_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncAtMillisMeta = const VerificationMeta(
    'lastSyncAtMillis',
  );
  @override
  late final GeneratedColumn<int> lastSyncAtMillis = GeneratedColumn<int>(
    'last_sync_at_millis',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    installationId,
    localProfileId,
    platform,
    appVersion,
    firstSeenAtMillis,
    lastSeenAtMillis,
    lastSyncAtMillis,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'installations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Installation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('installation_id')) {
      context.handle(
        _installationIdMeta,
        installationId.isAcceptableOrUnknown(
          data['installation_id']!,
          _installationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installationIdMeta);
    }
    if (data.containsKey('local_profile_id')) {
      context.handle(
        _localProfileIdMeta,
        localProfileId.isAcceptableOrUnknown(
          data['local_profile_id']!,
          _localProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localProfileIdMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    if (data.containsKey('app_version')) {
      context.handle(
        _appVersionMeta,
        appVersion.isAcceptableOrUnknown(data['app_version']!, _appVersionMeta),
      );
    } else if (isInserting) {
      context.missing(_appVersionMeta);
    }
    if (data.containsKey('first_seen_at_millis')) {
      context.handle(
        _firstSeenAtMillisMeta,
        firstSeenAtMillis.isAcceptableOrUnknown(
          data['first_seen_at_millis']!,
          _firstSeenAtMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstSeenAtMillisMeta);
    }
    if (data.containsKey('last_seen_at_millis')) {
      context.handle(
        _lastSeenAtMillisMeta,
        lastSeenAtMillis.isAcceptableOrUnknown(
          data['last_seen_at_millis']!,
          _lastSeenAtMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSeenAtMillisMeta);
    }
    if (data.containsKey('last_sync_at_millis')) {
      context.handle(
        _lastSyncAtMillisMeta,
        lastSyncAtMillis.isAcceptableOrUnknown(
          data['last_sync_at_millis']!,
          _lastSyncAtMillisMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {installationId};
  @override
  Installation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Installation(
      installationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}installation_id'],
      )!,
      localProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_profile_id'],
      )!,
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      )!,
      appVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_version'],
      )!,
      firstSeenAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}first_seen_at_millis'],
      )!,
      lastSeenAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_seen_at_millis'],
      )!,
      lastSyncAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_sync_at_millis'],
      ),
    );
  }

  @override
  $InstallationsTable createAlias(String alias) {
    return $InstallationsTable(attachedDatabase, alias);
  }
}

class Installation extends DataClass implements Insertable<Installation> {
  final String installationId;
  final String localProfileId;
  final String platform;
  final String appVersion;
  final int firstSeenAtMillis;
  final int lastSeenAtMillis;
  final int? lastSyncAtMillis;
  const Installation({
    required this.installationId,
    required this.localProfileId,
    required this.platform,
    required this.appVersion,
    required this.firstSeenAtMillis,
    required this.lastSeenAtMillis,
    this.lastSyncAtMillis,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['installation_id'] = Variable<String>(installationId);
    map['local_profile_id'] = Variable<String>(localProfileId);
    map['platform'] = Variable<String>(platform);
    map['app_version'] = Variable<String>(appVersion);
    map['first_seen_at_millis'] = Variable<int>(firstSeenAtMillis);
    map['last_seen_at_millis'] = Variable<int>(lastSeenAtMillis);
    if (!nullToAbsent || lastSyncAtMillis != null) {
      map['last_sync_at_millis'] = Variable<int>(lastSyncAtMillis);
    }
    return map;
  }

  InstallationsCompanion toCompanion(bool nullToAbsent) {
    return InstallationsCompanion(
      installationId: Value(installationId),
      localProfileId: Value(localProfileId),
      platform: Value(platform),
      appVersion: Value(appVersion),
      firstSeenAtMillis: Value(firstSeenAtMillis),
      lastSeenAtMillis: Value(lastSeenAtMillis),
      lastSyncAtMillis: lastSyncAtMillis == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAtMillis),
    );
  }

  factory Installation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Installation(
      installationId: serializer.fromJson<String>(json['installationId']),
      localProfileId: serializer.fromJson<String>(json['localProfileId']),
      platform: serializer.fromJson<String>(json['platform']),
      appVersion: serializer.fromJson<String>(json['appVersion']),
      firstSeenAtMillis: serializer.fromJson<int>(json['firstSeenAtMillis']),
      lastSeenAtMillis: serializer.fromJson<int>(json['lastSeenAtMillis']),
      lastSyncAtMillis: serializer.fromJson<int?>(json['lastSyncAtMillis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'installationId': serializer.toJson<String>(installationId),
      'localProfileId': serializer.toJson<String>(localProfileId),
      'platform': serializer.toJson<String>(platform),
      'appVersion': serializer.toJson<String>(appVersion),
      'firstSeenAtMillis': serializer.toJson<int>(firstSeenAtMillis),
      'lastSeenAtMillis': serializer.toJson<int>(lastSeenAtMillis),
      'lastSyncAtMillis': serializer.toJson<int?>(lastSyncAtMillis),
    };
  }

  Installation copyWith({
    String? installationId,
    String? localProfileId,
    String? platform,
    String? appVersion,
    int? firstSeenAtMillis,
    int? lastSeenAtMillis,
    Value<int?> lastSyncAtMillis = const Value.absent(),
  }) => Installation(
    installationId: installationId ?? this.installationId,
    localProfileId: localProfileId ?? this.localProfileId,
    platform: platform ?? this.platform,
    appVersion: appVersion ?? this.appVersion,
    firstSeenAtMillis: firstSeenAtMillis ?? this.firstSeenAtMillis,
    lastSeenAtMillis: lastSeenAtMillis ?? this.lastSeenAtMillis,
    lastSyncAtMillis: lastSyncAtMillis.present
        ? lastSyncAtMillis.value
        : this.lastSyncAtMillis,
  );
  Installation copyWithCompanion(InstallationsCompanion data) {
    return Installation(
      installationId: data.installationId.present
          ? data.installationId.value
          : this.installationId,
      localProfileId: data.localProfileId.present
          ? data.localProfileId.value
          : this.localProfileId,
      platform: data.platform.present ? data.platform.value : this.platform,
      appVersion: data.appVersion.present
          ? data.appVersion.value
          : this.appVersion,
      firstSeenAtMillis: data.firstSeenAtMillis.present
          ? data.firstSeenAtMillis.value
          : this.firstSeenAtMillis,
      lastSeenAtMillis: data.lastSeenAtMillis.present
          ? data.lastSeenAtMillis.value
          : this.lastSeenAtMillis,
      lastSyncAtMillis: data.lastSyncAtMillis.present
          ? data.lastSyncAtMillis.value
          : this.lastSyncAtMillis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Installation(')
          ..write('installationId: $installationId, ')
          ..write('localProfileId: $localProfileId, ')
          ..write('platform: $platform, ')
          ..write('appVersion: $appVersion, ')
          ..write('firstSeenAtMillis: $firstSeenAtMillis, ')
          ..write('lastSeenAtMillis: $lastSeenAtMillis, ')
          ..write('lastSyncAtMillis: $lastSyncAtMillis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    installationId,
    localProfileId,
    platform,
    appVersion,
    firstSeenAtMillis,
    lastSeenAtMillis,
    lastSyncAtMillis,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Installation &&
          other.installationId == this.installationId &&
          other.localProfileId == this.localProfileId &&
          other.platform == this.platform &&
          other.appVersion == this.appVersion &&
          other.firstSeenAtMillis == this.firstSeenAtMillis &&
          other.lastSeenAtMillis == this.lastSeenAtMillis &&
          other.lastSyncAtMillis == this.lastSyncAtMillis);
}

class InstallationsCompanion extends UpdateCompanion<Installation> {
  final Value<String> installationId;
  final Value<String> localProfileId;
  final Value<String> platform;
  final Value<String> appVersion;
  final Value<int> firstSeenAtMillis;
  final Value<int> lastSeenAtMillis;
  final Value<int?> lastSyncAtMillis;
  final Value<int> rowid;
  const InstallationsCompanion({
    this.installationId = const Value.absent(),
    this.localProfileId = const Value.absent(),
    this.platform = const Value.absent(),
    this.appVersion = const Value.absent(),
    this.firstSeenAtMillis = const Value.absent(),
    this.lastSeenAtMillis = const Value.absent(),
    this.lastSyncAtMillis = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InstallationsCompanion.insert({
    required String installationId,
    required String localProfileId,
    required String platform,
    required String appVersion,
    required int firstSeenAtMillis,
    required int lastSeenAtMillis,
    this.lastSyncAtMillis = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : installationId = Value(installationId),
       localProfileId = Value(localProfileId),
       platform = Value(platform),
       appVersion = Value(appVersion),
       firstSeenAtMillis = Value(firstSeenAtMillis),
       lastSeenAtMillis = Value(lastSeenAtMillis);
  static Insertable<Installation> custom({
    Expression<String>? installationId,
    Expression<String>? localProfileId,
    Expression<String>? platform,
    Expression<String>? appVersion,
    Expression<int>? firstSeenAtMillis,
    Expression<int>? lastSeenAtMillis,
    Expression<int>? lastSyncAtMillis,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (installationId != null) 'installation_id': installationId,
      if (localProfileId != null) 'local_profile_id': localProfileId,
      if (platform != null) 'platform': platform,
      if (appVersion != null) 'app_version': appVersion,
      if (firstSeenAtMillis != null) 'first_seen_at_millis': firstSeenAtMillis,
      if (lastSeenAtMillis != null) 'last_seen_at_millis': lastSeenAtMillis,
      if (lastSyncAtMillis != null) 'last_sync_at_millis': lastSyncAtMillis,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InstallationsCompanion copyWith({
    Value<String>? installationId,
    Value<String>? localProfileId,
    Value<String>? platform,
    Value<String>? appVersion,
    Value<int>? firstSeenAtMillis,
    Value<int>? lastSeenAtMillis,
    Value<int?>? lastSyncAtMillis,
    Value<int>? rowid,
  }) {
    return InstallationsCompanion(
      installationId: installationId ?? this.installationId,
      localProfileId: localProfileId ?? this.localProfileId,
      platform: platform ?? this.platform,
      appVersion: appVersion ?? this.appVersion,
      firstSeenAtMillis: firstSeenAtMillis ?? this.firstSeenAtMillis,
      lastSeenAtMillis: lastSeenAtMillis ?? this.lastSeenAtMillis,
      lastSyncAtMillis: lastSyncAtMillis ?? this.lastSyncAtMillis,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (installationId.present) {
      map['installation_id'] = Variable<String>(installationId.value);
    }
    if (localProfileId.present) {
      map['local_profile_id'] = Variable<String>(localProfileId.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (appVersion.present) {
      map['app_version'] = Variable<String>(appVersion.value);
    }
    if (firstSeenAtMillis.present) {
      map['first_seen_at_millis'] = Variable<int>(firstSeenAtMillis.value);
    }
    if (lastSeenAtMillis.present) {
      map['last_seen_at_millis'] = Variable<int>(lastSeenAtMillis.value);
    }
    if (lastSyncAtMillis.present) {
      map['last_sync_at_millis'] = Variable<int>(lastSyncAtMillis.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InstallationsCompanion(')
          ..write('installationId: $installationId, ')
          ..write('localProfileId: $localProfileId, ')
          ..write('platform: $platform, ')
          ..write('appVersion: $appVersion, ')
          ..write('firstSeenAtMillis: $firstSeenAtMillis, ')
          ..write('lastSeenAtMillis: $lastSeenAtMillis, ')
          ..write('lastSyncAtMillis: $lastSyncAtMillis, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonProgressRowsTable extends LessonProgressRows
    with TableInfo<$LessonProgressRowsTable, LessonProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonProgressRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localProfileIdMeta = const VerificationMeta(
    'localProfileId',
  );
  @override
  late final GeneratedColumn<String> localProfileId = GeneratedColumn<String>(
    'local_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('started'),
  );
  static const VerificationMeta _startedAtMillisMeta = const VerificationMeta(
    'startedAtMillis',
  );
  @override
  late final GeneratedColumn<int> startedAtMillis = GeneratedColumn<int>(
    'started_at_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMillisMeta = const VerificationMeta(
    'completedAtMillis',
  );
  @override
  late final GeneratedColumn<int> completedAtMillis = GeneratedColumn<int>(
    'completed_at_millis',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalTimeSpentSecondsMeta =
      const VerificationMeta('totalTimeSpentSeconds');
  @override
  late final GeneratedColumn<int> totalTimeSpentSeconds = GeneratedColumn<int>(
    'total_time_spent_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _visitCountMeta = const VerificationMeta(
    'visitCount',
  );
  @override
  late final GeneratedColumn<int> visitCount = GeneratedColumn<int>(
    'visit_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _updatedAtMillisMeta = const VerificationMeta(
    'updatedAtMillis',
  );
  @override
  late final GeneratedColumn<int> updatedAtMillis = GeneratedColumn<int>(
    'updated_at_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    localProfileId,
    lessonId,
    status,
    startedAtMillis,
    completedAtMillis,
    totalTimeSpentSeconds,
    visitCount,
    updatedAtMillis,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_progress_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<LessonProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_profile_id')) {
      context.handle(
        _localProfileIdMeta,
        localProfileId.isAcceptableOrUnknown(
          data['local_profile_id']!,
          _localProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localProfileIdMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('started_at_millis')) {
      context.handle(
        _startedAtMillisMeta,
        startedAtMillis.isAcceptableOrUnknown(
          data['started_at_millis']!,
          _startedAtMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startedAtMillisMeta);
    }
    if (data.containsKey('completed_at_millis')) {
      context.handle(
        _completedAtMillisMeta,
        completedAtMillis.isAcceptableOrUnknown(
          data['completed_at_millis']!,
          _completedAtMillisMeta,
        ),
      );
    }
    if (data.containsKey('total_time_spent_seconds')) {
      context.handle(
        _totalTimeSpentSecondsMeta,
        totalTimeSpentSeconds.isAcceptableOrUnknown(
          data['total_time_spent_seconds']!,
          _totalTimeSpentSecondsMeta,
        ),
      );
    }
    if (data.containsKey('visit_count')) {
      context.handle(
        _visitCountMeta,
        visitCount.isAcceptableOrUnknown(data['visit_count']!, _visitCountMeta),
      );
    }
    if (data.containsKey('updated_at_millis')) {
      context.handle(
        _updatedAtMillisMeta,
        updatedAtMillis.isAcceptableOrUnknown(
          data['updated_at_millis']!,
          _updatedAtMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMillisMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localProfileId, lessonId};
  @override
  LessonProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonProgressRow(
      localProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_profile_id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      startedAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at_millis'],
      )!,
      completedAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_at_millis'],
      ),
      totalTimeSpentSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_time_spent_seconds'],
      )!,
      visitCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}visit_count'],
      )!,
      updatedAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_millis'],
      )!,
    );
  }

  @override
  $LessonProgressRowsTable createAlias(String alias) {
    return $LessonProgressRowsTable(attachedDatabase, alias);
  }
}

class LessonProgressRow extends DataClass
    implements Insertable<LessonProgressRow> {
  final String localProfileId;
  final String lessonId;
  final String status;
  final int startedAtMillis;
  final int? completedAtMillis;
  final int totalTimeSpentSeconds;
  final int visitCount;
  final int updatedAtMillis;
  const LessonProgressRow({
    required this.localProfileId,
    required this.lessonId,
    required this.status,
    required this.startedAtMillis,
    this.completedAtMillis,
    required this.totalTimeSpentSeconds,
    required this.visitCount,
    required this.updatedAtMillis,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_profile_id'] = Variable<String>(localProfileId);
    map['lesson_id'] = Variable<String>(lessonId);
    map['status'] = Variable<String>(status);
    map['started_at_millis'] = Variable<int>(startedAtMillis);
    if (!nullToAbsent || completedAtMillis != null) {
      map['completed_at_millis'] = Variable<int>(completedAtMillis);
    }
    map['total_time_spent_seconds'] = Variable<int>(totalTimeSpentSeconds);
    map['visit_count'] = Variable<int>(visitCount);
    map['updated_at_millis'] = Variable<int>(updatedAtMillis);
    return map;
  }

  LessonProgressRowsCompanion toCompanion(bool nullToAbsent) {
    return LessonProgressRowsCompanion(
      localProfileId: Value(localProfileId),
      lessonId: Value(lessonId),
      status: Value(status),
      startedAtMillis: Value(startedAtMillis),
      completedAtMillis: completedAtMillis == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAtMillis),
      totalTimeSpentSeconds: Value(totalTimeSpentSeconds),
      visitCount: Value(visitCount),
      updatedAtMillis: Value(updatedAtMillis),
    );
  }

  factory LessonProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonProgressRow(
      localProfileId: serializer.fromJson<String>(json['localProfileId']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      status: serializer.fromJson<String>(json['status']),
      startedAtMillis: serializer.fromJson<int>(json['startedAtMillis']),
      completedAtMillis: serializer.fromJson<int?>(json['completedAtMillis']),
      totalTimeSpentSeconds: serializer.fromJson<int>(
        json['totalTimeSpentSeconds'],
      ),
      visitCount: serializer.fromJson<int>(json['visitCount']),
      updatedAtMillis: serializer.fromJson<int>(json['updatedAtMillis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localProfileId': serializer.toJson<String>(localProfileId),
      'lessonId': serializer.toJson<String>(lessonId),
      'status': serializer.toJson<String>(status),
      'startedAtMillis': serializer.toJson<int>(startedAtMillis),
      'completedAtMillis': serializer.toJson<int?>(completedAtMillis),
      'totalTimeSpentSeconds': serializer.toJson<int>(totalTimeSpentSeconds),
      'visitCount': serializer.toJson<int>(visitCount),
      'updatedAtMillis': serializer.toJson<int>(updatedAtMillis),
    };
  }

  LessonProgressRow copyWith({
    String? localProfileId,
    String? lessonId,
    String? status,
    int? startedAtMillis,
    Value<int?> completedAtMillis = const Value.absent(),
    int? totalTimeSpentSeconds,
    int? visitCount,
    int? updatedAtMillis,
  }) => LessonProgressRow(
    localProfileId: localProfileId ?? this.localProfileId,
    lessonId: lessonId ?? this.lessonId,
    status: status ?? this.status,
    startedAtMillis: startedAtMillis ?? this.startedAtMillis,
    completedAtMillis: completedAtMillis.present
        ? completedAtMillis.value
        : this.completedAtMillis,
    totalTimeSpentSeconds: totalTimeSpentSeconds ?? this.totalTimeSpentSeconds,
    visitCount: visitCount ?? this.visitCount,
    updatedAtMillis: updatedAtMillis ?? this.updatedAtMillis,
  );
  LessonProgressRow copyWithCompanion(LessonProgressRowsCompanion data) {
    return LessonProgressRow(
      localProfileId: data.localProfileId.present
          ? data.localProfileId.value
          : this.localProfileId,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      status: data.status.present ? data.status.value : this.status,
      startedAtMillis: data.startedAtMillis.present
          ? data.startedAtMillis.value
          : this.startedAtMillis,
      completedAtMillis: data.completedAtMillis.present
          ? data.completedAtMillis.value
          : this.completedAtMillis,
      totalTimeSpentSeconds: data.totalTimeSpentSeconds.present
          ? data.totalTimeSpentSeconds.value
          : this.totalTimeSpentSeconds,
      visitCount: data.visitCount.present
          ? data.visitCount.value
          : this.visitCount,
      updatedAtMillis: data.updatedAtMillis.present
          ? data.updatedAtMillis.value
          : this.updatedAtMillis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressRow(')
          ..write('localProfileId: $localProfileId, ')
          ..write('lessonId: $lessonId, ')
          ..write('status: $status, ')
          ..write('startedAtMillis: $startedAtMillis, ')
          ..write('completedAtMillis: $completedAtMillis, ')
          ..write('totalTimeSpentSeconds: $totalTimeSpentSeconds, ')
          ..write('visitCount: $visitCount, ')
          ..write('updatedAtMillis: $updatedAtMillis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localProfileId,
    lessonId,
    status,
    startedAtMillis,
    completedAtMillis,
    totalTimeSpentSeconds,
    visitCount,
    updatedAtMillis,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonProgressRow &&
          other.localProfileId == this.localProfileId &&
          other.lessonId == this.lessonId &&
          other.status == this.status &&
          other.startedAtMillis == this.startedAtMillis &&
          other.completedAtMillis == this.completedAtMillis &&
          other.totalTimeSpentSeconds == this.totalTimeSpentSeconds &&
          other.visitCount == this.visitCount &&
          other.updatedAtMillis == this.updatedAtMillis);
}

class LessonProgressRowsCompanion extends UpdateCompanion<LessonProgressRow> {
  final Value<String> localProfileId;
  final Value<String> lessonId;
  final Value<String> status;
  final Value<int> startedAtMillis;
  final Value<int?> completedAtMillis;
  final Value<int> totalTimeSpentSeconds;
  final Value<int> visitCount;
  final Value<int> updatedAtMillis;
  final Value<int> rowid;
  const LessonProgressRowsCompanion({
    this.localProfileId = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAtMillis = const Value.absent(),
    this.completedAtMillis = const Value.absent(),
    this.totalTimeSpentSeconds = const Value.absent(),
    this.visitCount = const Value.absent(),
    this.updatedAtMillis = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonProgressRowsCompanion.insert({
    required String localProfileId,
    required String lessonId,
    this.status = const Value.absent(),
    required int startedAtMillis,
    this.completedAtMillis = const Value.absent(),
    this.totalTimeSpentSeconds = const Value.absent(),
    this.visitCount = const Value.absent(),
    required int updatedAtMillis,
    this.rowid = const Value.absent(),
  }) : localProfileId = Value(localProfileId),
       lessonId = Value(lessonId),
       startedAtMillis = Value(startedAtMillis),
       updatedAtMillis = Value(updatedAtMillis);
  static Insertable<LessonProgressRow> custom({
    Expression<String>? localProfileId,
    Expression<String>? lessonId,
    Expression<String>? status,
    Expression<int>? startedAtMillis,
    Expression<int>? completedAtMillis,
    Expression<int>? totalTimeSpentSeconds,
    Expression<int>? visitCount,
    Expression<int>? updatedAtMillis,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localProfileId != null) 'local_profile_id': localProfileId,
      if (lessonId != null) 'lesson_id': lessonId,
      if (status != null) 'status': status,
      if (startedAtMillis != null) 'started_at_millis': startedAtMillis,
      if (completedAtMillis != null) 'completed_at_millis': completedAtMillis,
      if (totalTimeSpentSeconds != null)
        'total_time_spent_seconds': totalTimeSpentSeconds,
      if (visitCount != null) 'visit_count': visitCount,
      if (updatedAtMillis != null) 'updated_at_millis': updatedAtMillis,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonProgressRowsCompanion copyWith({
    Value<String>? localProfileId,
    Value<String>? lessonId,
    Value<String>? status,
    Value<int>? startedAtMillis,
    Value<int?>? completedAtMillis,
    Value<int>? totalTimeSpentSeconds,
    Value<int>? visitCount,
    Value<int>? updatedAtMillis,
    Value<int>? rowid,
  }) {
    return LessonProgressRowsCompanion(
      localProfileId: localProfileId ?? this.localProfileId,
      lessonId: lessonId ?? this.lessonId,
      status: status ?? this.status,
      startedAtMillis: startedAtMillis ?? this.startedAtMillis,
      completedAtMillis: completedAtMillis ?? this.completedAtMillis,
      totalTimeSpentSeconds:
          totalTimeSpentSeconds ?? this.totalTimeSpentSeconds,
      visitCount: visitCount ?? this.visitCount,
      updatedAtMillis: updatedAtMillis ?? this.updatedAtMillis,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localProfileId.present) {
      map['local_profile_id'] = Variable<String>(localProfileId.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startedAtMillis.present) {
      map['started_at_millis'] = Variable<int>(startedAtMillis.value);
    }
    if (completedAtMillis.present) {
      map['completed_at_millis'] = Variable<int>(completedAtMillis.value);
    }
    if (totalTimeSpentSeconds.present) {
      map['total_time_spent_seconds'] = Variable<int>(
        totalTimeSpentSeconds.value,
      );
    }
    if (visitCount.present) {
      map['visit_count'] = Variable<int>(visitCount.value);
    }
    if (updatedAtMillis.present) {
      map['updated_at_millis'] = Variable<int>(updatedAtMillis.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressRowsCompanion(')
          ..write('localProfileId: $localProfileId, ')
          ..write('lessonId: $lessonId, ')
          ..write('status: $status, ')
          ..write('startedAtMillis: $startedAtMillis, ')
          ..write('completedAtMillis: $completedAtMillis, ')
          ..write('totalTimeSpentSeconds: $totalTimeSpentSeconds, ')
          ..write('visitCount: $visitCount, ')
          ..write('updatedAtMillis: $updatedAtMillis, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizAttemptsTable extends QuizAttempts
    with TableInfo<$QuizAttemptsTable, QuizAttempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _attemptIdMeta = const VerificationMeta(
    'attemptId',
  );
  @override
  late final GeneratedColumn<String> attemptId = GeneratedColumn<String>(
    'attempt_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localProfileIdMeta = const VerificationMeta(
    'localProfileId',
  );
  @override
  late final GeneratedColumn<String> localProfileId = GeneratedColumn<String>(
    'local_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quizIdMeta = const VerificationMeta('quizId');
  @override
  late final GeneratedColumn<String> quizId = GeneratedColumn<String>(
    'quiz_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quizLevelMeta = const VerificationMeta(
    'quizLevel',
  );
  @override
  late final GeneratedColumn<String> quizLevel = GeneratedColumn<String>(
    'quiz_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('started'),
  );
  static const VerificationMeta _startedAtMillisMeta = const VerificationMeta(
    'startedAtMillis',
  );
  @override
  late final GeneratedColumn<int> startedAtMillis = GeneratedColumn<int>(
    'started_at_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMillisMeta = const VerificationMeta(
    'completedAtMillis',
  );
  @override
  late final GeneratedColumn<int> completedAtMillis = GeneratedColumn<int>(
    'completed_at_millis',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _normalQuestionsTotalMeta =
      const VerificationMeta('normalQuestionsTotal');
  @override
  late final GeneratedColumn<int> normalQuestionsTotal = GeneratedColumn<int>(
    'normal_questions_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _bonusQuestionsTotalMeta =
      const VerificationMeta('bonusQuestionsTotal');
  @override
  late final GeneratedColumn<int> bonusQuestionsTotal = GeneratedColumn<int>(
    'bonus_questions_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _correctAnswersMeta = const VerificationMeta(
    'correctAnswers',
  );
  @override
  late final GeneratedColumn<int> correctAnswers = GeneratedColumn<int>(
    'correct_answers',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _wrongAnswersMeta = const VerificationMeta(
    'wrongAnswers',
  );
  @override
  late final GeneratedColumn<int> wrongAnswers = GeneratedColumn<int>(
    'wrong_answers',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bonusCorrectMeta = const VerificationMeta(
    'bonusCorrect',
  );
  @override
  late final GeneratedColumn<int> bonusCorrect = GeneratedColumn<int>(
    'bonus_correct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalScoreMeta = const VerificationMeta(
    'totalScore',
  );
  @override
  late final GeneratedColumn<int> totalScore = GeneratedColumn<int>(
    'total_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    attemptId,
    localProfileId,
    quizId,
    quizLevel,
    status,
    startedAtMillis,
    completedAtMillis,
    normalQuestionsTotal,
    bonusQuestionsTotal,
    correctAnswers,
    wrongAnswers,
    bonusCorrect,
    totalScore,
    durationSeconds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizAttempt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('attempt_id')) {
      context.handle(
        _attemptIdMeta,
        attemptId.isAcceptableOrUnknown(data['attempt_id']!, _attemptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_attemptIdMeta);
    }
    if (data.containsKey('local_profile_id')) {
      context.handle(
        _localProfileIdMeta,
        localProfileId.isAcceptableOrUnknown(
          data['local_profile_id']!,
          _localProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localProfileIdMeta);
    }
    if (data.containsKey('quiz_id')) {
      context.handle(
        _quizIdMeta,
        quizId.isAcceptableOrUnknown(data['quiz_id']!, _quizIdMeta),
      );
    } else if (isInserting) {
      context.missing(_quizIdMeta);
    }
    if (data.containsKey('quiz_level')) {
      context.handle(
        _quizLevelMeta,
        quizLevel.isAcceptableOrUnknown(data['quiz_level']!, _quizLevelMeta),
      );
    } else if (isInserting) {
      context.missing(_quizLevelMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('started_at_millis')) {
      context.handle(
        _startedAtMillisMeta,
        startedAtMillis.isAcceptableOrUnknown(
          data['started_at_millis']!,
          _startedAtMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startedAtMillisMeta);
    }
    if (data.containsKey('completed_at_millis')) {
      context.handle(
        _completedAtMillisMeta,
        completedAtMillis.isAcceptableOrUnknown(
          data['completed_at_millis']!,
          _completedAtMillisMeta,
        ),
      );
    }
    if (data.containsKey('normal_questions_total')) {
      context.handle(
        _normalQuestionsTotalMeta,
        normalQuestionsTotal.isAcceptableOrUnknown(
          data['normal_questions_total']!,
          _normalQuestionsTotalMeta,
        ),
      );
    }
    if (data.containsKey('bonus_questions_total')) {
      context.handle(
        _bonusQuestionsTotalMeta,
        bonusQuestionsTotal.isAcceptableOrUnknown(
          data['bonus_questions_total']!,
          _bonusQuestionsTotalMeta,
        ),
      );
    }
    if (data.containsKey('correct_answers')) {
      context.handle(
        _correctAnswersMeta,
        correctAnswers.isAcceptableOrUnknown(
          data['correct_answers']!,
          _correctAnswersMeta,
        ),
      );
    }
    if (data.containsKey('wrong_answers')) {
      context.handle(
        _wrongAnswersMeta,
        wrongAnswers.isAcceptableOrUnknown(
          data['wrong_answers']!,
          _wrongAnswersMeta,
        ),
      );
    }
    if (data.containsKey('bonus_correct')) {
      context.handle(
        _bonusCorrectMeta,
        bonusCorrect.isAcceptableOrUnknown(
          data['bonus_correct']!,
          _bonusCorrectMeta,
        ),
      );
    }
    if (data.containsKey('total_score')) {
      context.handle(
        _totalScoreMeta,
        totalScore.isAcceptableOrUnknown(data['total_score']!, _totalScoreMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {attemptId};
  @override
  QuizAttempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizAttempt(
      attemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attempt_id'],
      )!,
      localProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_profile_id'],
      )!,
      quizId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quiz_id'],
      )!,
      quizLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quiz_level'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      startedAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at_millis'],
      )!,
      completedAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_at_millis'],
      ),
      normalQuestionsTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}normal_questions_total'],
      )!,
      bonusQuestionsTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bonus_questions_total'],
      )!,
      correctAnswers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_answers'],
      )!,
      wrongAnswers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wrong_answers'],
      )!,
      bonusCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bonus_correct'],
      )!,
      totalScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_score'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
    );
  }

  @override
  $QuizAttemptsTable createAlias(String alias) {
    return $QuizAttemptsTable(attachedDatabase, alias);
  }
}

class QuizAttempt extends DataClass implements Insertable<QuizAttempt> {
  final String attemptId;
  final String localProfileId;
  final String quizId;
  final String quizLevel;
  final String status;
  final int startedAtMillis;
  final int? completedAtMillis;
  final int normalQuestionsTotal;
  final int bonusQuestionsTotal;
  final int correctAnswers;
  final int wrongAnswers;
  final int bonusCorrect;
  final int totalScore;
  final int durationSeconds;
  const QuizAttempt({
    required this.attemptId,
    required this.localProfileId,
    required this.quizId,
    required this.quizLevel,
    required this.status,
    required this.startedAtMillis,
    this.completedAtMillis,
    required this.normalQuestionsTotal,
    required this.bonusQuestionsTotal,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.bonusCorrect,
    required this.totalScore,
    required this.durationSeconds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['attempt_id'] = Variable<String>(attemptId);
    map['local_profile_id'] = Variable<String>(localProfileId);
    map['quiz_id'] = Variable<String>(quizId);
    map['quiz_level'] = Variable<String>(quizLevel);
    map['status'] = Variable<String>(status);
    map['started_at_millis'] = Variable<int>(startedAtMillis);
    if (!nullToAbsent || completedAtMillis != null) {
      map['completed_at_millis'] = Variable<int>(completedAtMillis);
    }
    map['normal_questions_total'] = Variable<int>(normalQuestionsTotal);
    map['bonus_questions_total'] = Variable<int>(bonusQuestionsTotal);
    map['correct_answers'] = Variable<int>(correctAnswers);
    map['wrong_answers'] = Variable<int>(wrongAnswers);
    map['bonus_correct'] = Variable<int>(bonusCorrect);
    map['total_score'] = Variable<int>(totalScore);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    return map;
  }

  QuizAttemptsCompanion toCompanion(bool nullToAbsent) {
    return QuizAttemptsCompanion(
      attemptId: Value(attemptId),
      localProfileId: Value(localProfileId),
      quizId: Value(quizId),
      quizLevel: Value(quizLevel),
      status: Value(status),
      startedAtMillis: Value(startedAtMillis),
      completedAtMillis: completedAtMillis == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAtMillis),
      normalQuestionsTotal: Value(normalQuestionsTotal),
      bonusQuestionsTotal: Value(bonusQuestionsTotal),
      correctAnswers: Value(correctAnswers),
      wrongAnswers: Value(wrongAnswers),
      bonusCorrect: Value(bonusCorrect),
      totalScore: Value(totalScore),
      durationSeconds: Value(durationSeconds),
    );
  }

  factory QuizAttempt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizAttempt(
      attemptId: serializer.fromJson<String>(json['attemptId']),
      localProfileId: serializer.fromJson<String>(json['localProfileId']),
      quizId: serializer.fromJson<String>(json['quizId']),
      quizLevel: serializer.fromJson<String>(json['quizLevel']),
      status: serializer.fromJson<String>(json['status']),
      startedAtMillis: serializer.fromJson<int>(json['startedAtMillis']),
      completedAtMillis: serializer.fromJson<int?>(json['completedAtMillis']),
      normalQuestionsTotal: serializer.fromJson<int>(
        json['normalQuestionsTotal'],
      ),
      bonusQuestionsTotal: serializer.fromJson<int>(
        json['bonusQuestionsTotal'],
      ),
      correctAnswers: serializer.fromJson<int>(json['correctAnswers']),
      wrongAnswers: serializer.fromJson<int>(json['wrongAnswers']),
      bonusCorrect: serializer.fromJson<int>(json['bonusCorrect']),
      totalScore: serializer.fromJson<int>(json['totalScore']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'attemptId': serializer.toJson<String>(attemptId),
      'localProfileId': serializer.toJson<String>(localProfileId),
      'quizId': serializer.toJson<String>(quizId),
      'quizLevel': serializer.toJson<String>(quizLevel),
      'status': serializer.toJson<String>(status),
      'startedAtMillis': serializer.toJson<int>(startedAtMillis),
      'completedAtMillis': serializer.toJson<int?>(completedAtMillis),
      'normalQuestionsTotal': serializer.toJson<int>(normalQuestionsTotal),
      'bonusQuestionsTotal': serializer.toJson<int>(bonusQuestionsTotal),
      'correctAnswers': serializer.toJson<int>(correctAnswers),
      'wrongAnswers': serializer.toJson<int>(wrongAnswers),
      'bonusCorrect': serializer.toJson<int>(bonusCorrect),
      'totalScore': serializer.toJson<int>(totalScore),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
    };
  }

  QuizAttempt copyWith({
    String? attemptId,
    String? localProfileId,
    String? quizId,
    String? quizLevel,
    String? status,
    int? startedAtMillis,
    Value<int?> completedAtMillis = const Value.absent(),
    int? normalQuestionsTotal,
    int? bonusQuestionsTotal,
    int? correctAnswers,
    int? wrongAnswers,
    int? bonusCorrect,
    int? totalScore,
    int? durationSeconds,
  }) => QuizAttempt(
    attemptId: attemptId ?? this.attemptId,
    localProfileId: localProfileId ?? this.localProfileId,
    quizId: quizId ?? this.quizId,
    quizLevel: quizLevel ?? this.quizLevel,
    status: status ?? this.status,
    startedAtMillis: startedAtMillis ?? this.startedAtMillis,
    completedAtMillis: completedAtMillis.present
        ? completedAtMillis.value
        : this.completedAtMillis,
    normalQuestionsTotal: normalQuestionsTotal ?? this.normalQuestionsTotal,
    bonusQuestionsTotal: bonusQuestionsTotal ?? this.bonusQuestionsTotal,
    correctAnswers: correctAnswers ?? this.correctAnswers,
    wrongAnswers: wrongAnswers ?? this.wrongAnswers,
    bonusCorrect: bonusCorrect ?? this.bonusCorrect,
    totalScore: totalScore ?? this.totalScore,
    durationSeconds: durationSeconds ?? this.durationSeconds,
  );
  QuizAttempt copyWithCompanion(QuizAttemptsCompanion data) {
    return QuizAttempt(
      attemptId: data.attemptId.present ? data.attemptId.value : this.attemptId,
      localProfileId: data.localProfileId.present
          ? data.localProfileId.value
          : this.localProfileId,
      quizId: data.quizId.present ? data.quizId.value : this.quizId,
      quizLevel: data.quizLevel.present ? data.quizLevel.value : this.quizLevel,
      status: data.status.present ? data.status.value : this.status,
      startedAtMillis: data.startedAtMillis.present
          ? data.startedAtMillis.value
          : this.startedAtMillis,
      completedAtMillis: data.completedAtMillis.present
          ? data.completedAtMillis.value
          : this.completedAtMillis,
      normalQuestionsTotal: data.normalQuestionsTotal.present
          ? data.normalQuestionsTotal.value
          : this.normalQuestionsTotal,
      bonusQuestionsTotal: data.bonusQuestionsTotal.present
          ? data.bonusQuestionsTotal.value
          : this.bonusQuestionsTotal,
      correctAnswers: data.correctAnswers.present
          ? data.correctAnswers.value
          : this.correctAnswers,
      wrongAnswers: data.wrongAnswers.present
          ? data.wrongAnswers.value
          : this.wrongAnswers,
      bonusCorrect: data.bonusCorrect.present
          ? data.bonusCorrect.value
          : this.bonusCorrect,
      totalScore: data.totalScore.present
          ? data.totalScore.value
          : this.totalScore,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizAttempt(')
          ..write('attemptId: $attemptId, ')
          ..write('localProfileId: $localProfileId, ')
          ..write('quizId: $quizId, ')
          ..write('quizLevel: $quizLevel, ')
          ..write('status: $status, ')
          ..write('startedAtMillis: $startedAtMillis, ')
          ..write('completedAtMillis: $completedAtMillis, ')
          ..write('normalQuestionsTotal: $normalQuestionsTotal, ')
          ..write('bonusQuestionsTotal: $bonusQuestionsTotal, ')
          ..write('correctAnswers: $correctAnswers, ')
          ..write('wrongAnswers: $wrongAnswers, ')
          ..write('bonusCorrect: $bonusCorrect, ')
          ..write('totalScore: $totalScore, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    attemptId,
    localProfileId,
    quizId,
    quizLevel,
    status,
    startedAtMillis,
    completedAtMillis,
    normalQuestionsTotal,
    bonusQuestionsTotal,
    correctAnswers,
    wrongAnswers,
    bonusCorrect,
    totalScore,
    durationSeconds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizAttempt &&
          other.attemptId == this.attemptId &&
          other.localProfileId == this.localProfileId &&
          other.quizId == this.quizId &&
          other.quizLevel == this.quizLevel &&
          other.status == this.status &&
          other.startedAtMillis == this.startedAtMillis &&
          other.completedAtMillis == this.completedAtMillis &&
          other.normalQuestionsTotal == this.normalQuestionsTotal &&
          other.bonusQuestionsTotal == this.bonusQuestionsTotal &&
          other.correctAnswers == this.correctAnswers &&
          other.wrongAnswers == this.wrongAnswers &&
          other.bonusCorrect == this.bonusCorrect &&
          other.totalScore == this.totalScore &&
          other.durationSeconds == this.durationSeconds);
}

class QuizAttemptsCompanion extends UpdateCompanion<QuizAttempt> {
  final Value<String> attemptId;
  final Value<String> localProfileId;
  final Value<String> quizId;
  final Value<String> quizLevel;
  final Value<String> status;
  final Value<int> startedAtMillis;
  final Value<int?> completedAtMillis;
  final Value<int> normalQuestionsTotal;
  final Value<int> bonusQuestionsTotal;
  final Value<int> correctAnswers;
  final Value<int> wrongAnswers;
  final Value<int> bonusCorrect;
  final Value<int> totalScore;
  final Value<int> durationSeconds;
  final Value<int> rowid;
  const QuizAttemptsCompanion({
    this.attemptId = const Value.absent(),
    this.localProfileId = const Value.absent(),
    this.quizId = const Value.absent(),
    this.quizLevel = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAtMillis = const Value.absent(),
    this.completedAtMillis = const Value.absent(),
    this.normalQuestionsTotal = const Value.absent(),
    this.bonusQuestionsTotal = const Value.absent(),
    this.correctAnswers = const Value.absent(),
    this.wrongAnswers = const Value.absent(),
    this.bonusCorrect = const Value.absent(),
    this.totalScore = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizAttemptsCompanion.insert({
    required String attemptId,
    required String localProfileId,
    required String quizId,
    required String quizLevel,
    this.status = const Value.absent(),
    required int startedAtMillis,
    this.completedAtMillis = const Value.absent(),
    this.normalQuestionsTotal = const Value.absent(),
    this.bonusQuestionsTotal = const Value.absent(),
    this.correctAnswers = const Value.absent(),
    this.wrongAnswers = const Value.absent(),
    this.bonusCorrect = const Value.absent(),
    this.totalScore = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : attemptId = Value(attemptId),
       localProfileId = Value(localProfileId),
       quizId = Value(quizId),
       quizLevel = Value(quizLevel),
       startedAtMillis = Value(startedAtMillis);
  static Insertable<QuizAttempt> custom({
    Expression<String>? attemptId,
    Expression<String>? localProfileId,
    Expression<String>? quizId,
    Expression<String>? quizLevel,
    Expression<String>? status,
    Expression<int>? startedAtMillis,
    Expression<int>? completedAtMillis,
    Expression<int>? normalQuestionsTotal,
    Expression<int>? bonusQuestionsTotal,
    Expression<int>? correctAnswers,
    Expression<int>? wrongAnswers,
    Expression<int>? bonusCorrect,
    Expression<int>? totalScore,
    Expression<int>? durationSeconds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (attemptId != null) 'attempt_id': attemptId,
      if (localProfileId != null) 'local_profile_id': localProfileId,
      if (quizId != null) 'quiz_id': quizId,
      if (quizLevel != null) 'quiz_level': quizLevel,
      if (status != null) 'status': status,
      if (startedAtMillis != null) 'started_at_millis': startedAtMillis,
      if (completedAtMillis != null) 'completed_at_millis': completedAtMillis,
      if (normalQuestionsTotal != null)
        'normal_questions_total': normalQuestionsTotal,
      if (bonusQuestionsTotal != null)
        'bonus_questions_total': bonusQuestionsTotal,
      if (correctAnswers != null) 'correct_answers': correctAnswers,
      if (wrongAnswers != null) 'wrong_answers': wrongAnswers,
      if (bonusCorrect != null) 'bonus_correct': bonusCorrect,
      if (totalScore != null) 'total_score': totalScore,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizAttemptsCompanion copyWith({
    Value<String>? attemptId,
    Value<String>? localProfileId,
    Value<String>? quizId,
    Value<String>? quizLevel,
    Value<String>? status,
    Value<int>? startedAtMillis,
    Value<int?>? completedAtMillis,
    Value<int>? normalQuestionsTotal,
    Value<int>? bonusQuestionsTotal,
    Value<int>? correctAnswers,
    Value<int>? wrongAnswers,
    Value<int>? bonusCorrect,
    Value<int>? totalScore,
    Value<int>? durationSeconds,
    Value<int>? rowid,
  }) {
    return QuizAttemptsCompanion(
      attemptId: attemptId ?? this.attemptId,
      localProfileId: localProfileId ?? this.localProfileId,
      quizId: quizId ?? this.quizId,
      quizLevel: quizLevel ?? this.quizLevel,
      status: status ?? this.status,
      startedAtMillis: startedAtMillis ?? this.startedAtMillis,
      completedAtMillis: completedAtMillis ?? this.completedAtMillis,
      normalQuestionsTotal: normalQuestionsTotal ?? this.normalQuestionsTotal,
      bonusQuestionsTotal: bonusQuestionsTotal ?? this.bonusQuestionsTotal,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      bonusCorrect: bonusCorrect ?? this.bonusCorrect,
      totalScore: totalScore ?? this.totalScore,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (attemptId.present) {
      map['attempt_id'] = Variable<String>(attemptId.value);
    }
    if (localProfileId.present) {
      map['local_profile_id'] = Variable<String>(localProfileId.value);
    }
    if (quizId.present) {
      map['quiz_id'] = Variable<String>(quizId.value);
    }
    if (quizLevel.present) {
      map['quiz_level'] = Variable<String>(quizLevel.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startedAtMillis.present) {
      map['started_at_millis'] = Variable<int>(startedAtMillis.value);
    }
    if (completedAtMillis.present) {
      map['completed_at_millis'] = Variable<int>(completedAtMillis.value);
    }
    if (normalQuestionsTotal.present) {
      map['normal_questions_total'] = Variable<int>(normalQuestionsTotal.value);
    }
    if (bonusQuestionsTotal.present) {
      map['bonus_questions_total'] = Variable<int>(bonusQuestionsTotal.value);
    }
    if (correctAnswers.present) {
      map['correct_answers'] = Variable<int>(correctAnswers.value);
    }
    if (wrongAnswers.present) {
      map['wrong_answers'] = Variable<int>(wrongAnswers.value);
    }
    if (bonusCorrect.present) {
      map['bonus_correct'] = Variable<int>(bonusCorrect.value);
    }
    if (totalScore.present) {
      map['total_score'] = Variable<int>(totalScore.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizAttemptsCompanion(')
          ..write('attemptId: $attemptId, ')
          ..write('localProfileId: $localProfileId, ')
          ..write('quizId: $quizId, ')
          ..write('quizLevel: $quizLevel, ')
          ..write('status: $status, ')
          ..write('startedAtMillis: $startedAtMillis, ')
          ..write('completedAtMillis: $completedAtMillis, ')
          ..write('normalQuestionsTotal: $normalQuestionsTotal, ')
          ..write('bonusQuestionsTotal: $bonusQuestionsTotal, ')
          ..write('correctAnswers: $correctAnswers, ')
          ..write('wrongAnswers: $wrongAnswers, ')
          ..write('bonusCorrect: $bonusCorrect, ')
          ..write('totalScore: $totalScore, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizAnswersTable extends QuizAnswers
    with TableInfo<$QuizAnswersTable, QuizAnswer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizAnswersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _answerIdMeta = const VerificationMeta(
    'answerId',
  );
  @override
  late final GeneratedColumn<String> answerId = GeneratedColumn<String>(
    'answer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptIdMeta = const VerificationMeta(
    'attemptId',
  );
  @override
  late final GeneratedColumn<String> attemptId = GeneratedColumn<String>(
    'attempt_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _selectedAnswerMeta = const VerificationMeta(
    'selectedAnswer',
  );
  @override
  late final GeneratedColumn<String> selectedAnswer = GeneratedColumn<String>(
    'selected_answer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAutoGradedMeta = const VerificationMeta(
    'isAutoGraded',
  );
  @override
  late final GeneratedColumn<bool> isAutoGraded = GeneratedColumn<bool>(
    'is_auto_graded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_auto_graded" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isCorrectMeta = const VerificationMeta(
    'isCorrect',
  );
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
    'is_correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isBonusQuestionMeta = const VerificationMeta(
    'isBonusQuestion',
  );
  @override
  late final GeneratedColumn<bool> isBonusQuestion = GeneratedColumn<bool>(
    'is_bonus_question',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_bonus_question" IN (0, 1))',
    ),
  );
  static const VerificationMeta _responseTimeMillisecondsMeta =
      const VerificationMeta('responseTimeMilliseconds');
  @override
  late final GeneratedColumn<int> responseTimeMilliseconds =
      GeneratedColumn<int>(
        'response_time_milliseconds',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _attemptNumberMeta = const VerificationMeta(
    'attemptNumber',
  );
  @override
  late final GeneratedColumn<int> attemptNumber = GeneratedColumn<int>(
    'attempt_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _hintUsedMeta = const VerificationMeta(
    'hintUsed',
  );
  @override
  late final GeneratedColumn<bool> hintUsed = GeneratedColumn<bool>(
    'hint_used',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("hint_used" IN (0, 1))',
    ),
  );
  static const VerificationMeta _answeredAtMillisMeta = const VerificationMeta(
    'answeredAtMillis',
  );
  @override
  late final GeneratedColumn<int> answeredAtMillis = GeneratedColumn<int>(
    'answered_at_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    answerId,
    attemptId,
    questionId,
    selectedAnswer,
    isAutoGraded,
    isCorrect,
    isBonusQuestion,
    responseTimeMilliseconds,
    attemptNumber,
    hintUsed,
    answeredAtMillis,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_answers';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizAnswer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('answer_id')) {
      context.handle(
        _answerIdMeta,
        answerId.isAcceptableOrUnknown(data['answer_id']!, _answerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_answerIdMeta);
    }
    if (data.containsKey('attempt_id')) {
      context.handle(
        _attemptIdMeta,
        attemptId.isAcceptableOrUnknown(data['attempt_id']!, _attemptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_attemptIdMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('selected_answer')) {
      context.handle(
        _selectedAnswerMeta,
        selectedAnswer.isAcceptableOrUnknown(
          data['selected_answer']!,
          _selectedAnswerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_selectedAnswerMeta);
    }
    if (data.containsKey('is_auto_graded')) {
      context.handle(
        _isAutoGradedMeta,
        isAutoGraded.isAcceptableOrUnknown(
          data['is_auto_graded']!,
          _isAutoGradedMeta,
        ),
      );
    }
    if (data.containsKey('is_correct')) {
      context.handle(
        _isCorrectMeta,
        isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta),
      );
    } else if (isInserting) {
      context.missing(_isCorrectMeta);
    }
    if (data.containsKey('is_bonus_question')) {
      context.handle(
        _isBonusQuestionMeta,
        isBonusQuestion.isAcceptableOrUnknown(
          data['is_bonus_question']!,
          _isBonusQuestionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isBonusQuestionMeta);
    }
    if (data.containsKey('response_time_milliseconds')) {
      context.handle(
        _responseTimeMillisecondsMeta,
        responseTimeMilliseconds.isAcceptableOrUnknown(
          data['response_time_milliseconds']!,
          _responseTimeMillisecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_responseTimeMillisecondsMeta);
    }
    if (data.containsKey('attempt_number')) {
      context.handle(
        _attemptNumberMeta,
        attemptNumber.isAcceptableOrUnknown(
          data['attempt_number']!,
          _attemptNumberMeta,
        ),
      );
    }
    if (data.containsKey('hint_used')) {
      context.handle(
        _hintUsedMeta,
        hintUsed.isAcceptableOrUnknown(data['hint_used']!, _hintUsedMeta),
      );
    }
    if (data.containsKey('answered_at_millis')) {
      context.handle(
        _answeredAtMillisMeta,
        answeredAtMillis.isAcceptableOrUnknown(
          data['answered_at_millis']!,
          _answeredAtMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_answeredAtMillisMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {answerId};
  @override
  QuizAnswer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizAnswer(
      answerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer_id'],
      )!,
      attemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attempt_id'],
      )!,
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      )!,
      selectedAnswer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_answer'],
      )!,
      isAutoGraded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_auto_graded'],
      )!,
      isCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_correct'],
      )!,
      isBonusQuestion: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_bonus_question'],
      )!,
      responseTimeMilliseconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}response_time_milliseconds'],
      )!,
      attemptNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_number'],
      )!,
      hintUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}hint_used'],
      ),
      answeredAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}answered_at_millis'],
      )!,
    );
  }

  @override
  $QuizAnswersTable createAlias(String alias) {
    return $QuizAnswersTable(attachedDatabase, alias);
  }
}

class QuizAnswer extends DataClass implements Insertable<QuizAnswer> {
  final String answerId;
  final String attemptId;
  final String questionId;
  final String selectedAnswer;
  final bool isAutoGraded;
  final bool isCorrect;
  final bool isBonusQuestion;
  final int responseTimeMilliseconds;
  final int attemptNumber;
  final bool? hintUsed;
  final int answeredAtMillis;
  const QuizAnswer({
    required this.answerId,
    required this.attemptId,
    required this.questionId,
    required this.selectedAnswer,
    required this.isAutoGraded,
    required this.isCorrect,
    required this.isBonusQuestion,
    required this.responseTimeMilliseconds,
    required this.attemptNumber,
    this.hintUsed,
    required this.answeredAtMillis,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['answer_id'] = Variable<String>(answerId);
    map['attempt_id'] = Variable<String>(attemptId);
    map['question_id'] = Variable<String>(questionId);
    map['selected_answer'] = Variable<String>(selectedAnswer);
    map['is_auto_graded'] = Variable<bool>(isAutoGraded);
    map['is_correct'] = Variable<bool>(isCorrect);
    map['is_bonus_question'] = Variable<bool>(isBonusQuestion);
    map['response_time_milliseconds'] = Variable<int>(responseTimeMilliseconds);
    map['attempt_number'] = Variable<int>(attemptNumber);
    if (!nullToAbsent || hintUsed != null) {
      map['hint_used'] = Variable<bool>(hintUsed);
    }
    map['answered_at_millis'] = Variable<int>(answeredAtMillis);
    return map;
  }

  QuizAnswersCompanion toCompanion(bool nullToAbsent) {
    return QuizAnswersCompanion(
      answerId: Value(answerId),
      attemptId: Value(attemptId),
      questionId: Value(questionId),
      selectedAnswer: Value(selectedAnswer),
      isAutoGraded: Value(isAutoGraded),
      isCorrect: Value(isCorrect),
      isBonusQuestion: Value(isBonusQuestion),
      responseTimeMilliseconds: Value(responseTimeMilliseconds),
      attemptNumber: Value(attemptNumber),
      hintUsed: hintUsed == null && nullToAbsent
          ? const Value.absent()
          : Value(hintUsed),
      answeredAtMillis: Value(answeredAtMillis),
    );
  }

  factory QuizAnswer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizAnswer(
      answerId: serializer.fromJson<String>(json['answerId']),
      attemptId: serializer.fromJson<String>(json['attemptId']),
      questionId: serializer.fromJson<String>(json['questionId']),
      selectedAnswer: serializer.fromJson<String>(json['selectedAnswer']),
      isAutoGraded: serializer.fromJson<bool>(json['isAutoGraded']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
      isBonusQuestion: serializer.fromJson<bool>(json['isBonusQuestion']),
      responseTimeMilliseconds: serializer.fromJson<int>(
        json['responseTimeMilliseconds'],
      ),
      attemptNumber: serializer.fromJson<int>(json['attemptNumber']),
      hintUsed: serializer.fromJson<bool?>(json['hintUsed']),
      answeredAtMillis: serializer.fromJson<int>(json['answeredAtMillis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'answerId': serializer.toJson<String>(answerId),
      'attemptId': serializer.toJson<String>(attemptId),
      'questionId': serializer.toJson<String>(questionId),
      'selectedAnswer': serializer.toJson<String>(selectedAnswer),
      'isAutoGraded': serializer.toJson<bool>(isAutoGraded),
      'isCorrect': serializer.toJson<bool>(isCorrect),
      'isBonusQuestion': serializer.toJson<bool>(isBonusQuestion),
      'responseTimeMilliseconds': serializer.toJson<int>(
        responseTimeMilliseconds,
      ),
      'attemptNumber': serializer.toJson<int>(attemptNumber),
      'hintUsed': serializer.toJson<bool?>(hintUsed),
      'answeredAtMillis': serializer.toJson<int>(answeredAtMillis),
    };
  }

  QuizAnswer copyWith({
    String? answerId,
    String? attemptId,
    String? questionId,
    String? selectedAnswer,
    bool? isAutoGraded,
    bool? isCorrect,
    bool? isBonusQuestion,
    int? responseTimeMilliseconds,
    int? attemptNumber,
    Value<bool?> hintUsed = const Value.absent(),
    int? answeredAtMillis,
  }) => QuizAnswer(
    answerId: answerId ?? this.answerId,
    attemptId: attemptId ?? this.attemptId,
    questionId: questionId ?? this.questionId,
    selectedAnswer: selectedAnswer ?? this.selectedAnswer,
    isAutoGraded: isAutoGraded ?? this.isAutoGraded,
    isCorrect: isCorrect ?? this.isCorrect,
    isBonusQuestion: isBonusQuestion ?? this.isBonusQuestion,
    responseTimeMilliseconds:
        responseTimeMilliseconds ?? this.responseTimeMilliseconds,
    attemptNumber: attemptNumber ?? this.attemptNumber,
    hintUsed: hintUsed.present ? hintUsed.value : this.hintUsed,
    answeredAtMillis: answeredAtMillis ?? this.answeredAtMillis,
  );
  QuizAnswer copyWithCompanion(QuizAnswersCompanion data) {
    return QuizAnswer(
      answerId: data.answerId.present ? data.answerId.value : this.answerId,
      attemptId: data.attemptId.present ? data.attemptId.value : this.attemptId,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      selectedAnswer: data.selectedAnswer.present
          ? data.selectedAnswer.value
          : this.selectedAnswer,
      isAutoGraded: data.isAutoGraded.present
          ? data.isAutoGraded.value
          : this.isAutoGraded,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
      isBonusQuestion: data.isBonusQuestion.present
          ? data.isBonusQuestion.value
          : this.isBonusQuestion,
      responseTimeMilliseconds: data.responseTimeMilliseconds.present
          ? data.responseTimeMilliseconds.value
          : this.responseTimeMilliseconds,
      attemptNumber: data.attemptNumber.present
          ? data.attemptNumber.value
          : this.attemptNumber,
      hintUsed: data.hintUsed.present ? data.hintUsed.value : this.hintUsed,
      answeredAtMillis: data.answeredAtMillis.present
          ? data.answeredAtMillis.value
          : this.answeredAtMillis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizAnswer(')
          ..write('answerId: $answerId, ')
          ..write('attemptId: $attemptId, ')
          ..write('questionId: $questionId, ')
          ..write('selectedAnswer: $selectedAnswer, ')
          ..write('isAutoGraded: $isAutoGraded, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('isBonusQuestion: $isBonusQuestion, ')
          ..write('responseTimeMilliseconds: $responseTimeMilliseconds, ')
          ..write('attemptNumber: $attemptNumber, ')
          ..write('hintUsed: $hintUsed, ')
          ..write('answeredAtMillis: $answeredAtMillis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    answerId,
    attemptId,
    questionId,
    selectedAnswer,
    isAutoGraded,
    isCorrect,
    isBonusQuestion,
    responseTimeMilliseconds,
    attemptNumber,
    hintUsed,
    answeredAtMillis,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizAnswer &&
          other.answerId == this.answerId &&
          other.attemptId == this.attemptId &&
          other.questionId == this.questionId &&
          other.selectedAnswer == this.selectedAnswer &&
          other.isAutoGraded == this.isAutoGraded &&
          other.isCorrect == this.isCorrect &&
          other.isBonusQuestion == this.isBonusQuestion &&
          other.responseTimeMilliseconds == this.responseTimeMilliseconds &&
          other.attemptNumber == this.attemptNumber &&
          other.hintUsed == this.hintUsed &&
          other.answeredAtMillis == this.answeredAtMillis);
}

class QuizAnswersCompanion extends UpdateCompanion<QuizAnswer> {
  final Value<String> answerId;
  final Value<String> attemptId;
  final Value<String> questionId;
  final Value<String> selectedAnswer;
  final Value<bool> isAutoGraded;
  final Value<bool> isCorrect;
  final Value<bool> isBonusQuestion;
  final Value<int> responseTimeMilliseconds;
  final Value<int> attemptNumber;
  final Value<bool?> hintUsed;
  final Value<int> answeredAtMillis;
  final Value<int> rowid;
  const QuizAnswersCompanion({
    this.answerId = const Value.absent(),
    this.attemptId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.selectedAnswer = const Value.absent(),
    this.isAutoGraded = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.isBonusQuestion = const Value.absent(),
    this.responseTimeMilliseconds = const Value.absent(),
    this.attemptNumber = const Value.absent(),
    this.hintUsed = const Value.absent(),
    this.answeredAtMillis = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizAnswersCompanion.insert({
    required String answerId,
    required String attemptId,
    required String questionId,
    required String selectedAnswer,
    this.isAutoGraded = const Value.absent(),
    required bool isCorrect,
    required bool isBonusQuestion,
    required int responseTimeMilliseconds,
    this.attemptNumber = const Value.absent(),
    this.hintUsed = const Value.absent(),
    required int answeredAtMillis,
    this.rowid = const Value.absent(),
  }) : answerId = Value(answerId),
       attemptId = Value(attemptId),
       questionId = Value(questionId),
       selectedAnswer = Value(selectedAnswer),
       isCorrect = Value(isCorrect),
       isBonusQuestion = Value(isBonusQuestion),
       responseTimeMilliseconds = Value(responseTimeMilliseconds),
       answeredAtMillis = Value(answeredAtMillis);
  static Insertable<QuizAnswer> custom({
    Expression<String>? answerId,
    Expression<String>? attemptId,
    Expression<String>? questionId,
    Expression<String>? selectedAnswer,
    Expression<bool>? isAutoGraded,
    Expression<bool>? isCorrect,
    Expression<bool>? isBonusQuestion,
    Expression<int>? responseTimeMilliseconds,
    Expression<int>? attemptNumber,
    Expression<bool>? hintUsed,
    Expression<int>? answeredAtMillis,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (answerId != null) 'answer_id': answerId,
      if (attemptId != null) 'attempt_id': attemptId,
      if (questionId != null) 'question_id': questionId,
      if (selectedAnswer != null) 'selected_answer': selectedAnswer,
      if (isAutoGraded != null) 'is_auto_graded': isAutoGraded,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (isBonusQuestion != null) 'is_bonus_question': isBonusQuestion,
      if (responseTimeMilliseconds != null)
        'response_time_milliseconds': responseTimeMilliseconds,
      if (attemptNumber != null) 'attempt_number': attemptNumber,
      if (hintUsed != null) 'hint_used': hintUsed,
      if (answeredAtMillis != null) 'answered_at_millis': answeredAtMillis,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizAnswersCompanion copyWith({
    Value<String>? answerId,
    Value<String>? attemptId,
    Value<String>? questionId,
    Value<String>? selectedAnswer,
    Value<bool>? isAutoGraded,
    Value<bool>? isCorrect,
    Value<bool>? isBonusQuestion,
    Value<int>? responseTimeMilliseconds,
    Value<int>? attemptNumber,
    Value<bool?>? hintUsed,
    Value<int>? answeredAtMillis,
    Value<int>? rowid,
  }) {
    return QuizAnswersCompanion(
      answerId: answerId ?? this.answerId,
      attemptId: attemptId ?? this.attemptId,
      questionId: questionId ?? this.questionId,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      isAutoGraded: isAutoGraded ?? this.isAutoGraded,
      isCorrect: isCorrect ?? this.isCorrect,
      isBonusQuestion: isBonusQuestion ?? this.isBonusQuestion,
      responseTimeMilliseconds:
          responseTimeMilliseconds ?? this.responseTimeMilliseconds,
      attemptNumber: attemptNumber ?? this.attemptNumber,
      hintUsed: hintUsed ?? this.hintUsed,
      answeredAtMillis: answeredAtMillis ?? this.answeredAtMillis,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (answerId.present) {
      map['answer_id'] = Variable<String>(answerId.value);
    }
    if (attemptId.present) {
      map['attempt_id'] = Variable<String>(attemptId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (selectedAnswer.present) {
      map['selected_answer'] = Variable<String>(selectedAnswer.value);
    }
    if (isAutoGraded.present) {
      map['is_auto_graded'] = Variable<bool>(isAutoGraded.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (isBonusQuestion.present) {
      map['is_bonus_question'] = Variable<bool>(isBonusQuestion.value);
    }
    if (responseTimeMilliseconds.present) {
      map['response_time_milliseconds'] = Variable<int>(
        responseTimeMilliseconds.value,
      );
    }
    if (attemptNumber.present) {
      map['attempt_number'] = Variable<int>(attemptNumber.value);
    }
    if (hintUsed.present) {
      map['hint_used'] = Variable<bool>(hintUsed.value);
    }
    if (answeredAtMillis.present) {
      map['answered_at_millis'] = Variable<int>(answeredAtMillis.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizAnswersCompanion(')
          ..write('answerId: $answerId, ')
          ..write('attemptId: $attemptId, ')
          ..write('questionId: $questionId, ')
          ..write('selectedAnswer: $selectedAnswer, ')
          ..write('isAutoGraded: $isAutoGraded, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('isBonusQuestion: $isBonusQuestion, ')
          ..write('responseTimeMilliseconds: $responseTimeMilliseconds, ')
          ..write('attemptNumber: $attemptNumber, ')
          ..write('hintUsed: $hintUsed, ')
          ..write('answeredAtMillis: $answeredAtMillis, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GameSessionsTable extends GameSessions
    with TableInfo<$GameSessionsTable, GameSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gameSessionIdMeta = const VerificationMeta(
    'gameSessionId',
  );
  @override
  late final GeneratedColumn<String> gameSessionId = GeneratedColumn<String>(
    'game_session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localProfileIdMeta = const VerificationMeta(
    'localProfileId',
  );
  @override
  late final GeneratedColumn<String> localProfileId = GeneratedColumn<String>(
    'local_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gameTypeMeta = const VerificationMeta(
    'gameType',
  );
  @override
  late final GeneratedColumn<String> gameType = GeneratedColumn<String>(
    'game_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('started'),
  );
  static const VerificationMeta _startedAtMillisMeta = const VerificationMeta(
    'startedAtMillis',
  );
  @override
  late final GeneratedColumn<int> startedAtMillis = GeneratedColumn<int>(
    'started_at_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMillisMeta = const VerificationMeta(
    'completedAtMillis',
  );
  @override
  late final GeneratedColumn<int> completedAtMillis = GeneratedColumn<int>(
    'completed_at_millis',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _correctCountMeta = const VerificationMeta(
    'correctCount',
  );
  @override
  late final GeneratedColumn<int> correctCount = GeneratedColumn<int>(
    'correct_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wrongCountMeta = const VerificationMeta(
    'wrongCount',
  );
  @override
  late final GeneratedColumn<int> wrongCount = GeneratedColumn<int>(
    'wrong_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    gameSessionId,
    localProfileId,
    gameType,
    gameId,
    status,
    startedAtMillis,
    completedAtMillis,
    durationSeconds,
    score,
    correctCount,
    wrongCount,
    attemptCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<GameSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('game_session_id')) {
      context.handle(
        _gameSessionIdMeta,
        gameSessionId.isAcceptableOrUnknown(
          data['game_session_id']!,
          _gameSessionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gameSessionIdMeta);
    }
    if (data.containsKey('local_profile_id')) {
      context.handle(
        _localProfileIdMeta,
        localProfileId.isAcceptableOrUnknown(
          data['local_profile_id']!,
          _localProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localProfileIdMeta);
    }
    if (data.containsKey('game_type')) {
      context.handle(
        _gameTypeMeta,
        gameType.isAcceptableOrUnknown(data['game_type']!, _gameTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_gameTypeMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('started_at_millis')) {
      context.handle(
        _startedAtMillisMeta,
        startedAtMillis.isAcceptableOrUnknown(
          data['started_at_millis']!,
          _startedAtMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startedAtMillisMeta);
    }
    if (data.containsKey('completed_at_millis')) {
      context.handle(
        _completedAtMillisMeta,
        completedAtMillis.isAcceptableOrUnknown(
          data['completed_at_millis']!,
          _completedAtMillisMeta,
        ),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('correct_count')) {
      context.handle(
        _correctCountMeta,
        correctCount.isAcceptableOrUnknown(
          data['correct_count']!,
          _correctCountMeta,
        ),
      );
    }
    if (data.containsKey('wrong_count')) {
      context.handle(
        _wrongCountMeta,
        wrongCount.isAcceptableOrUnknown(data['wrong_count']!, _wrongCountMeta),
      );
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gameSessionId};
  @override
  GameSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameSession(
      gameSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_session_id'],
      )!,
      localProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_profile_id'],
      )!,
      gameType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_type'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      startedAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at_millis'],
      )!,
      completedAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_at_millis'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      ),
      correctCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_count'],
      ),
      wrongCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wrong_count'],
      ),
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      ),
    );
  }

  @override
  $GameSessionsTable createAlias(String alias) {
    return $GameSessionsTable(attachedDatabase, alias);
  }
}

class GameSession extends DataClass implements Insertable<GameSession> {
  final String gameSessionId;
  final String localProfileId;
  final String gameType;
  final String gameId;
  final String status;
  final int startedAtMillis;
  final int? completedAtMillis;
  final int durationSeconds;
  final int? score;
  final int? correctCount;
  final int? wrongCount;
  final int? attemptCount;
  const GameSession({
    required this.gameSessionId,
    required this.localProfileId,
    required this.gameType,
    required this.gameId,
    required this.status,
    required this.startedAtMillis,
    this.completedAtMillis,
    required this.durationSeconds,
    this.score,
    this.correctCount,
    this.wrongCount,
    this.attemptCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['game_session_id'] = Variable<String>(gameSessionId);
    map['local_profile_id'] = Variable<String>(localProfileId);
    map['game_type'] = Variable<String>(gameType);
    map['game_id'] = Variable<String>(gameId);
    map['status'] = Variable<String>(status);
    map['started_at_millis'] = Variable<int>(startedAtMillis);
    if (!nullToAbsent || completedAtMillis != null) {
      map['completed_at_millis'] = Variable<int>(completedAtMillis);
    }
    map['duration_seconds'] = Variable<int>(durationSeconds);
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<int>(score);
    }
    if (!nullToAbsent || correctCount != null) {
      map['correct_count'] = Variable<int>(correctCount);
    }
    if (!nullToAbsent || wrongCount != null) {
      map['wrong_count'] = Variable<int>(wrongCount);
    }
    if (!nullToAbsent || attemptCount != null) {
      map['attempt_count'] = Variable<int>(attemptCount);
    }
    return map;
  }

  GameSessionsCompanion toCompanion(bool nullToAbsent) {
    return GameSessionsCompanion(
      gameSessionId: Value(gameSessionId),
      localProfileId: Value(localProfileId),
      gameType: Value(gameType),
      gameId: Value(gameId),
      status: Value(status),
      startedAtMillis: Value(startedAtMillis),
      completedAtMillis: completedAtMillis == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAtMillis),
      durationSeconds: Value(durationSeconds),
      score: score == null && nullToAbsent
          ? const Value.absent()
          : Value(score),
      correctCount: correctCount == null && nullToAbsent
          ? const Value.absent()
          : Value(correctCount),
      wrongCount: wrongCount == null && nullToAbsent
          ? const Value.absent()
          : Value(wrongCount),
      attemptCount: attemptCount == null && nullToAbsent
          ? const Value.absent()
          : Value(attemptCount),
    );
  }

  factory GameSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameSession(
      gameSessionId: serializer.fromJson<String>(json['gameSessionId']),
      localProfileId: serializer.fromJson<String>(json['localProfileId']),
      gameType: serializer.fromJson<String>(json['gameType']),
      gameId: serializer.fromJson<String>(json['gameId']),
      status: serializer.fromJson<String>(json['status']),
      startedAtMillis: serializer.fromJson<int>(json['startedAtMillis']),
      completedAtMillis: serializer.fromJson<int?>(json['completedAtMillis']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      score: serializer.fromJson<int?>(json['score']),
      correctCount: serializer.fromJson<int?>(json['correctCount']),
      wrongCount: serializer.fromJson<int?>(json['wrongCount']),
      attemptCount: serializer.fromJson<int?>(json['attemptCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gameSessionId': serializer.toJson<String>(gameSessionId),
      'localProfileId': serializer.toJson<String>(localProfileId),
      'gameType': serializer.toJson<String>(gameType),
      'gameId': serializer.toJson<String>(gameId),
      'status': serializer.toJson<String>(status),
      'startedAtMillis': serializer.toJson<int>(startedAtMillis),
      'completedAtMillis': serializer.toJson<int?>(completedAtMillis),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'score': serializer.toJson<int?>(score),
      'correctCount': serializer.toJson<int?>(correctCount),
      'wrongCount': serializer.toJson<int?>(wrongCount),
      'attemptCount': serializer.toJson<int?>(attemptCount),
    };
  }

  GameSession copyWith({
    String? gameSessionId,
    String? localProfileId,
    String? gameType,
    String? gameId,
    String? status,
    int? startedAtMillis,
    Value<int?> completedAtMillis = const Value.absent(),
    int? durationSeconds,
    Value<int?> score = const Value.absent(),
    Value<int?> correctCount = const Value.absent(),
    Value<int?> wrongCount = const Value.absent(),
    Value<int?> attemptCount = const Value.absent(),
  }) => GameSession(
    gameSessionId: gameSessionId ?? this.gameSessionId,
    localProfileId: localProfileId ?? this.localProfileId,
    gameType: gameType ?? this.gameType,
    gameId: gameId ?? this.gameId,
    status: status ?? this.status,
    startedAtMillis: startedAtMillis ?? this.startedAtMillis,
    completedAtMillis: completedAtMillis.present
        ? completedAtMillis.value
        : this.completedAtMillis,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    score: score.present ? score.value : this.score,
    correctCount: correctCount.present ? correctCount.value : this.correctCount,
    wrongCount: wrongCount.present ? wrongCount.value : this.wrongCount,
    attemptCount: attemptCount.present ? attemptCount.value : this.attemptCount,
  );
  GameSession copyWithCompanion(GameSessionsCompanion data) {
    return GameSession(
      gameSessionId: data.gameSessionId.present
          ? data.gameSessionId.value
          : this.gameSessionId,
      localProfileId: data.localProfileId.present
          ? data.localProfileId.value
          : this.localProfileId,
      gameType: data.gameType.present ? data.gameType.value : this.gameType,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      status: data.status.present ? data.status.value : this.status,
      startedAtMillis: data.startedAtMillis.present
          ? data.startedAtMillis.value
          : this.startedAtMillis,
      completedAtMillis: data.completedAtMillis.present
          ? data.completedAtMillis.value
          : this.completedAtMillis,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      score: data.score.present ? data.score.value : this.score,
      correctCount: data.correctCount.present
          ? data.correctCount.value
          : this.correctCount,
      wrongCount: data.wrongCount.present
          ? data.wrongCount.value
          : this.wrongCount,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameSession(')
          ..write('gameSessionId: $gameSessionId, ')
          ..write('localProfileId: $localProfileId, ')
          ..write('gameType: $gameType, ')
          ..write('gameId: $gameId, ')
          ..write('status: $status, ')
          ..write('startedAtMillis: $startedAtMillis, ')
          ..write('completedAtMillis: $completedAtMillis, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('score: $score, ')
          ..write('correctCount: $correctCount, ')
          ..write('wrongCount: $wrongCount, ')
          ..write('attemptCount: $attemptCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    gameSessionId,
    localProfileId,
    gameType,
    gameId,
    status,
    startedAtMillis,
    completedAtMillis,
    durationSeconds,
    score,
    correctCount,
    wrongCount,
    attemptCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameSession &&
          other.gameSessionId == this.gameSessionId &&
          other.localProfileId == this.localProfileId &&
          other.gameType == this.gameType &&
          other.gameId == this.gameId &&
          other.status == this.status &&
          other.startedAtMillis == this.startedAtMillis &&
          other.completedAtMillis == this.completedAtMillis &&
          other.durationSeconds == this.durationSeconds &&
          other.score == this.score &&
          other.correctCount == this.correctCount &&
          other.wrongCount == this.wrongCount &&
          other.attemptCount == this.attemptCount);
}

class GameSessionsCompanion extends UpdateCompanion<GameSession> {
  final Value<String> gameSessionId;
  final Value<String> localProfileId;
  final Value<String> gameType;
  final Value<String> gameId;
  final Value<String> status;
  final Value<int> startedAtMillis;
  final Value<int?> completedAtMillis;
  final Value<int> durationSeconds;
  final Value<int?> score;
  final Value<int?> correctCount;
  final Value<int?> wrongCount;
  final Value<int?> attemptCount;
  final Value<int> rowid;
  const GameSessionsCompanion({
    this.gameSessionId = const Value.absent(),
    this.localProfileId = const Value.absent(),
    this.gameType = const Value.absent(),
    this.gameId = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAtMillis = const Value.absent(),
    this.completedAtMillis = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.score = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.wrongCount = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GameSessionsCompanion.insert({
    required String gameSessionId,
    required String localProfileId,
    required String gameType,
    required String gameId,
    this.status = const Value.absent(),
    required int startedAtMillis,
    this.completedAtMillis = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.score = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.wrongCount = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : gameSessionId = Value(gameSessionId),
       localProfileId = Value(localProfileId),
       gameType = Value(gameType),
       gameId = Value(gameId),
       startedAtMillis = Value(startedAtMillis);
  static Insertable<GameSession> custom({
    Expression<String>? gameSessionId,
    Expression<String>? localProfileId,
    Expression<String>? gameType,
    Expression<String>? gameId,
    Expression<String>? status,
    Expression<int>? startedAtMillis,
    Expression<int>? completedAtMillis,
    Expression<int>? durationSeconds,
    Expression<int>? score,
    Expression<int>? correctCount,
    Expression<int>? wrongCount,
    Expression<int>? attemptCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gameSessionId != null) 'game_session_id': gameSessionId,
      if (localProfileId != null) 'local_profile_id': localProfileId,
      if (gameType != null) 'game_type': gameType,
      if (gameId != null) 'game_id': gameId,
      if (status != null) 'status': status,
      if (startedAtMillis != null) 'started_at_millis': startedAtMillis,
      if (completedAtMillis != null) 'completed_at_millis': completedAtMillis,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (score != null) 'score': score,
      if (correctCount != null) 'correct_count': correctCount,
      if (wrongCount != null) 'wrong_count': wrongCount,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GameSessionsCompanion copyWith({
    Value<String>? gameSessionId,
    Value<String>? localProfileId,
    Value<String>? gameType,
    Value<String>? gameId,
    Value<String>? status,
    Value<int>? startedAtMillis,
    Value<int?>? completedAtMillis,
    Value<int>? durationSeconds,
    Value<int?>? score,
    Value<int?>? correctCount,
    Value<int?>? wrongCount,
    Value<int?>? attemptCount,
    Value<int>? rowid,
  }) {
    return GameSessionsCompanion(
      gameSessionId: gameSessionId ?? this.gameSessionId,
      localProfileId: localProfileId ?? this.localProfileId,
      gameType: gameType ?? this.gameType,
      gameId: gameId ?? this.gameId,
      status: status ?? this.status,
      startedAtMillis: startedAtMillis ?? this.startedAtMillis,
      completedAtMillis: completedAtMillis ?? this.completedAtMillis,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      score: score ?? this.score,
      correctCount: correctCount ?? this.correctCount,
      wrongCount: wrongCount ?? this.wrongCount,
      attemptCount: attemptCount ?? this.attemptCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gameSessionId.present) {
      map['game_session_id'] = Variable<String>(gameSessionId.value);
    }
    if (localProfileId.present) {
      map['local_profile_id'] = Variable<String>(localProfileId.value);
    }
    if (gameType.present) {
      map['game_type'] = Variable<String>(gameType.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startedAtMillis.present) {
      map['started_at_millis'] = Variable<int>(startedAtMillis.value);
    }
    if (completedAtMillis.present) {
      map['completed_at_millis'] = Variable<int>(completedAtMillis.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (correctCount.present) {
      map['correct_count'] = Variable<int>(correctCount.value);
    }
    if (wrongCount.present) {
      map['wrong_count'] = Variable<int>(wrongCount.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameSessionsCompanion(')
          ..write('gameSessionId: $gameSessionId, ')
          ..write('localProfileId: $localProfileId, ')
          ..write('gameType: $gameType, ')
          ..write('gameId: $gameId, ')
          ..write('status: $status, ')
          ..write('startedAtMillis: $startedAtMillis, ')
          ..write('completedAtMillis: $completedAtMillis, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('score: $score, ')
          ..write('correctCount: $correctCount, ')
          ..write('wrongCount: $wrongCount, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LearningSessionsTable extends LearningSessions
    with TableInfo<$LearningSessionsTable, LearningSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LearningSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localProfileIdMeta = const VerificationMeta(
    'localProfileId',
  );
  @override
  late final GeneratedColumn<String> localProfileId = GeneratedColumn<String>(
    'local_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMillisMeta = const VerificationMeta(
    'startedAtMillis',
  );
  @override
  late final GeneratedColumn<int> startedAtMillis = GeneratedColumn<int>(
    'started_at_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMillisMeta = const VerificationMeta(
    'endedAtMillis',
  );
  @override
  late final GeneratedColumn<int> endedAtMillis = GeneratedColumn<int>(
    'ended_at_millis',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeLearningSecondsMeta =
      const VerificationMeta('activeLearningSeconds');
  @override
  late final GeneratedColumn<int> activeLearningSeconds = GeneratedColumn<int>(
    'active_learning_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    sessionId,
    localProfileId,
    startedAtMillis,
    endedAtMillis,
    activeLearningSeconds,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'learning_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<LearningSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('local_profile_id')) {
      context.handle(
        _localProfileIdMeta,
        localProfileId.isAcceptableOrUnknown(
          data['local_profile_id']!,
          _localProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localProfileIdMeta);
    }
    if (data.containsKey('started_at_millis')) {
      context.handle(
        _startedAtMillisMeta,
        startedAtMillis.isAcceptableOrUnknown(
          data['started_at_millis']!,
          _startedAtMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startedAtMillisMeta);
    }
    if (data.containsKey('ended_at_millis')) {
      context.handle(
        _endedAtMillisMeta,
        endedAtMillis.isAcceptableOrUnknown(
          data['ended_at_millis']!,
          _endedAtMillisMeta,
        ),
      );
    }
    if (data.containsKey('active_learning_seconds')) {
      context.handle(
        _activeLearningSecondsMeta,
        activeLearningSeconds.isAcceptableOrUnknown(
          data['active_learning_seconds']!,
          _activeLearningSecondsMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId};
  @override
  LearningSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LearningSession(
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      localProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_profile_id'],
      )!,
      startedAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at_millis'],
      )!,
      endedAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ended_at_millis'],
      ),
      activeLearningSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}active_learning_seconds'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $LearningSessionsTable createAlias(String alias) {
    return $LearningSessionsTable(attachedDatabase, alias);
  }
}

class LearningSession extends DataClass implements Insertable<LearningSession> {
  final String sessionId;
  final String localProfileId;
  final int startedAtMillis;
  final int? endedAtMillis;
  final int activeLearningSeconds;
  final String status;
  const LearningSession({
    required this.sessionId,
    required this.localProfileId,
    required this.startedAtMillis,
    this.endedAtMillis,
    required this.activeLearningSeconds,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    map['local_profile_id'] = Variable<String>(localProfileId);
    map['started_at_millis'] = Variable<int>(startedAtMillis);
    if (!nullToAbsent || endedAtMillis != null) {
      map['ended_at_millis'] = Variable<int>(endedAtMillis);
    }
    map['active_learning_seconds'] = Variable<int>(activeLearningSeconds);
    map['status'] = Variable<String>(status);
    return map;
  }

  LearningSessionsCompanion toCompanion(bool nullToAbsent) {
    return LearningSessionsCompanion(
      sessionId: Value(sessionId),
      localProfileId: Value(localProfileId),
      startedAtMillis: Value(startedAtMillis),
      endedAtMillis: endedAtMillis == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAtMillis),
      activeLearningSeconds: Value(activeLearningSeconds),
      status: Value(status),
    );
  }

  factory LearningSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LearningSession(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      localProfileId: serializer.fromJson<String>(json['localProfileId']),
      startedAtMillis: serializer.fromJson<int>(json['startedAtMillis']),
      endedAtMillis: serializer.fromJson<int?>(json['endedAtMillis']),
      activeLearningSeconds: serializer.fromJson<int>(
        json['activeLearningSeconds'],
      ),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'localProfileId': serializer.toJson<String>(localProfileId),
      'startedAtMillis': serializer.toJson<int>(startedAtMillis),
      'endedAtMillis': serializer.toJson<int?>(endedAtMillis),
      'activeLearningSeconds': serializer.toJson<int>(activeLearningSeconds),
      'status': serializer.toJson<String>(status),
    };
  }

  LearningSession copyWith({
    String? sessionId,
    String? localProfileId,
    int? startedAtMillis,
    Value<int?> endedAtMillis = const Value.absent(),
    int? activeLearningSeconds,
    String? status,
  }) => LearningSession(
    sessionId: sessionId ?? this.sessionId,
    localProfileId: localProfileId ?? this.localProfileId,
    startedAtMillis: startedAtMillis ?? this.startedAtMillis,
    endedAtMillis: endedAtMillis.present
        ? endedAtMillis.value
        : this.endedAtMillis,
    activeLearningSeconds: activeLearningSeconds ?? this.activeLearningSeconds,
    status: status ?? this.status,
  );
  LearningSession copyWithCompanion(LearningSessionsCompanion data) {
    return LearningSession(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      localProfileId: data.localProfileId.present
          ? data.localProfileId.value
          : this.localProfileId,
      startedAtMillis: data.startedAtMillis.present
          ? data.startedAtMillis.value
          : this.startedAtMillis,
      endedAtMillis: data.endedAtMillis.present
          ? data.endedAtMillis.value
          : this.endedAtMillis,
      activeLearningSeconds: data.activeLearningSeconds.present
          ? data.activeLearningSeconds.value
          : this.activeLearningSeconds,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LearningSession(')
          ..write('sessionId: $sessionId, ')
          ..write('localProfileId: $localProfileId, ')
          ..write('startedAtMillis: $startedAtMillis, ')
          ..write('endedAtMillis: $endedAtMillis, ')
          ..write('activeLearningSeconds: $activeLearningSeconds, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    sessionId,
    localProfileId,
    startedAtMillis,
    endedAtMillis,
    activeLearningSeconds,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LearningSession &&
          other.sessionId == this.sessionId &&
          other.localProfileId == this.localProfileId &&
          other.startedAtMillis == this.startedAtMillis &&
          other.endedAtMillis == this.endedAtMillis &&
          other.activeLearningSeconds == this.activeLearningSeconds &&
          other.status == this.status);
}

class LearningSessionsCompanion extends UpdateCompanion<LearningSession> {
  final Value<String> sessionId;
  final Value<String> localProfileId;
  final Value<int> startedAtMillis;
  final Value<int?> endedAtMillis;
  final Value<int> activeLearningSeconds;
  final Value<String> status;
  final Value<int> rowid;
  const LearningSessionsCompanion({
    this.sessionId = const Value.absent(),
    this.localProfileId = const Value.absent(),
    this.startedAtMillis = const Value.absent(),
    this.endedAtMillis = const Value.absent(),
    this.activeLearningSeconds = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LearningSessionsCompanion.insert({
    required String sessionId,
    required String localProfileId,
    required int startedAtMillis,
    this.endedAtMillis = const Value.absent(),
    this.activeLearningSeconds = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       localProfileId = Value(localProfileId),
       startedAtMillis = Value(startedAtMillis);
  static Insertable<LearningSession> custom({
    Expression<String>? sessionId,
    Expression<String>? localProfileId,
    Expression<int>? startedAtMillis,
    Expression<int>? endedAtMillis,
    Expression<int>? activeLearningSeconds,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (localProfileId != null) 'local_profile_id': localProfileId,
      if (startedAtMillis != null) 'started_at_millis': startedAtMillis,
      if (endedAtMillis != null) 'ended_at_millis': endedAtMillis,
      if (activeLearningSeconds != null)
        'active_learning_seconds': activeLearningSeconds,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LearningSessionsCompanion copyWith({
    Value<String>? sessionId,
    Value<String>? localProfileId,
    Value<int>? startedAtMillis,
    Value<int?>? endedAtMillis,
    Value<int>? activeLearningSeconds,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return LearningSessionsCompanion(
      sessionId: sessionId ?? this.sessionId,
      localProfileId: localProfileId ?? this.localProfileId,
      startedAtMillis: startedAtMillis ?? this.startedAtMillis,
      endedAtMillis: endedAtMillis ?? this.endedAtMillis,
      activeLearningSeconds:
          activeLearningSeconds ?? this.activeLearningSeconds,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (localProfileId.present) {
      map['local_profile_id'] = Variable<String>(localProfileId.value);
    }
    if (startedAtMillis.present) {
      map['started_at_millis'] = Variable<int>(startedAtMillis.value);
    }
    if (endedAtMillis.present) {
      map['ended_at_millis'] = Variable<int>(endedAtMillis.value);
    }
    if (activeLearningSeconds.present) {
      map['active_learning_seconds'] = Variable<int>(
        activeLearningSeconds.value,
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LearningSessionsCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('localProfileId: $localProfileId, ')
          ..write('startedAtMillis: $startedAtMillis, ')
          ..write('endedAtMillis: $endedAtMillis, ')
          ..write('activeLearningSeconds: $activeLearningSeconds, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LearningEventsTable extends LearningEvents
    with TableInfo<$LearningEventsTable, LearningEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LearningEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localProfileIdMeta = const VerificationMeta(
    'localProfileId',
  );
  @override
  late final GeneratedColumn<String> localProfileId = GeneratedColumn<String>(
    'local_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firebaseUidMeta = const VerificationMeta(
    'firebaseUid',
  );
  @override
  late final GeneratedColumn<String> firebaseUid = GeneratedColumn<String>(
    'firebase_uid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _installationIdMeta = const VerificationMeta(
    'installationId',
  );
  @override
  late final GeneratedColumn<String> installationId = GeneratedColumn<String>(
    'installation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMillisMeta = const VerificationMeta(
    'timestampMillis',
  );
  @override
  late final GeneratedColumn<int> timestampMillis = GeneratedColumn<int>(
    'timestamp_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _createdAtMillisMeta = const VerificationMeta(
    'createdAtMillis',
  );
  @override
  late final GeneratedColumn<int> createdAtMillis = GeneratedColumn<int>(
    'created_at_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMillisMeta = const VerificationMeta(
    'syncedAtMillis',
  );
  @override
  late final GeneratedColumn<int> syncedAtMillis = GeneratedColumn<int>(
    'synced_at_millis',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    eventId,
    localProfileId,
    firebaseUid,
    installationId,
    eventType,
    entityType,
    entityId,
    timestampMillis,
    payloadJson,
    syncStatus,
    createdAtMillis,
    syncedAtMillis,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'learning_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<LearningEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('local_profile_id')) {
      context.handle(
        _localProfileIdMeta,
        localProfileId.isAcceptableOrUnknown(
          data['local_profile_id']!,
          _localProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localProfileIdMeta);
    }
    if (data.containsKey('firebase_uid')) {
      context.handle(
        _firebaseUidMeta,
        firebaseUid.isAcceptableOrUnknown(
          data['firebase_uid']!,
          _firebaseUidMeta,
        ),
      );
    }
    if (data.containsKey('installation_id')) {
      context.handle(
        _installationIdMeta,
        installationId.isAcceptableOrUnknown(
          data['installation_id']!,
          _installationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installationIdMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('timestamp_millis')) {
      context.handle(
        _timestampMillisMeta,
        timestampMillis.isAcceptableOrUnknown(
          data['timestamp_millis']!,
          _timestampMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_timestampMillisMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('created_at_millis')) {
      context.handle(
        _createdAtMillisMeta,
        createdAtMillis.isAcceptableOrUnknown(
          data['created_at_millis']!,
          _createdAtMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtMillisMeta);
    }
    if (data.containsKey('synced_at_millis')) {
      context.handle(
        _syncedAtMillisMeta,
        syncedAtMillis.isAcceptableOrUnknown(
          data['synced_at_millis']!,
          _syncedAtMillisMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventId};
  @override
  LearningEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LearningEvent(
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      localProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_profile_id'],
      )!,
      firebaseUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}firebase_uid'],
      ),
      installationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}installation_id'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      timestampMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timestamp_millis'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      createdAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_millis'],
      )!,
      syncedAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}synced_at_millis'],
      ),
    );
  }

  @override
  $LearningEventsTable createAlias(String alias) {
    return $LearningEventsTable(attachedDatabase, alias);
  }
}

class LearningEvent extends DataClass implements Insertable<LearningEvent> {
  final String eventId;
  final String localProfileId;
  final String? firebaseUid;
  final String installationId;
  final String eventType;
  final String entityType;
  final String entityId;
  final int timestampMillis;
  final String payloadJson;
  final String syncStatus;
  final int createdAtMillis;
  final int? syncedAtMillis;
  const LearningEvent({
    required this.eventId,
    required this.localProfileId,
    this.firebaseUid,
    required this.installationId,
    required this.eventType,
    required this.entityType,
    required this.entityId,
    required this.timestampMillis,
    required this.payloadJson,
    required this.syncStatus,
    required this.createdAtMillis,
    this.syncedAtMillis,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_id'] = Variable<String>(eventId);
    map['local_profile_id'] = Variable<String>(localProfileId);
    if (!nullToAbsent || firebaseUid != null) {
      map['firebase_uid'] = Variable<String>(firebaseUid);
    }
    map['installation_id'] = Variable<String>(installationId);
    map['event_type'] = Variable<String>(eventType);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['timestamp_millis'] = Variable<int>(timestampMillis);
    map['payload_json'] = Variable<String>(payloadJson);
    map['sync_status'] = Variable<String>(syncStatus);
    map['created_at_millis'] = Variable<int>(createdAtMillis);
    if (!nullToAbsent || syncedAtMillis != null) {
      map['synced_at_millis'] = Variable<int>(syncedAtMillis);
    }
    return map;
  }

  LearningEventsCompanion toCompanion(bool nullToAbsent) {
    return LearningEventsCompanion(
      eventId: Value(eventId),
      localProfileId: Value(localProfileId),
      firebaseUid: firebaseUid == null && nullToAbsent
          ? const Value.absent()
          : Value(firebaseUid),
      installationId: Value(installationId),
      eventType: Value(eventType),
      entityType: Value(entityType),
      entityId: Value(entityId),
      timestampMillis: Value(timestampMillis),
      payloadJson: Value(payloadJson),
      syncStatus: Value(syncStatus),
      createdAtMillis: Value(createdAtMillis),
      syncedAtMillis: syncedAtMillis == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAtMillis),
    );
  }

  factory LearningEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LearningEvent(
      eventId: serializer.fromJson<String>(json['eventId']),
      localProfileId: serializer.fromJson<String>(json['localProfileId']),
      firebaseUid: serializer.fromJson<String?>(json['firebaseUid']),
      installationId: serializer.fromJson<String>(json['installationId']),
      eventType: serializer.fromJson<String>(json['eventType']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      timestampMillis: serializer.fromJson<int>(json['timestampMillis']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      createdAtMillis: serializer.fromJson<int>(json['createdAtMillis']),
      syncedAtMillis: serializer.fromJson<int?>(json['syncedAtMillis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventId': serializer.toJson<String>(eventId),
      'localProfileId': serializer.toJson<String>(localProfileId),
      'firebaseUid': serializer.toJson<String?>(firebaseUid),
      'installationId': serializer.toJson<String>(installationId),
      'eventType': serializer.toJson<String>(eventType),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'timestampMillis': serializer.toJson<int>(timestampMillis),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'createdAtMillis': serializer.toJson<int>(createdAtMillis),
      'syncedAtMillis': serializer.toJson<int?>(syncedAtMillis),
    };
  }

  LearningEvent copyWith({
    String? eventId,
    String? localProfileId,
    Value<String?> firebaseUid = const Value.absent(),
    String? installationId,
    String? eventType,
    String? entityType,
    String? entityId,
    int? timestampMillis,
    String? payloadJson,
    String? syncStatus,
    int? createdAtMillis,
    Value<int?> syncedAtMillis = const Value.absent(),
  }) => LearningEvent(
    eventId: eventId ?? this.eventId,
    localProfileId: localProfileId ?? this.localProfileId,
    firebaseUid: firebaseUid.present ? firebaseUid.value : this.firebaseUid,
    installationId: installationId ?? this.installationId,
    eventType: eventType ?? this.eventType,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    timestampMillis: timestampMillis ?? this.timestampMillis,
    payloadJson: payloadJson ?? this.payloadJson,
    syncStatus: syncStatus ?? this.syncStatus,
    createdAtMillis: createdAtMillis ?? this.createdAtMillis,
    syncedAtMillis: syncedAtMillis.present
        ? syncedAtMillis.value
        : this.syncedAtMillis,
  );
  LearningEvent copyWithCompanion(LearningEventsCompanion data) {
    return LearningEvent(
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      localProfileId: data.localProfileId.present
          ? data.localProfileId.value
          : this.localProfileId,
      firebaseUid: data.firebaseUid.present
          ? data.firebaseUid.value
          : this.firebaseUid,
      installationId: data.installationId.present
          ? data.installationId.value
          : this.installationId,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      timestampMillis: data.timestampMillis.present
          ? data.timestampMillis.value
          : this.timestampMillis,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      createdAtMillis: data.createdAtMillis.present
          ? data.createdAtMillis.value
          : this.createdAtMillis,
      syncedAtMillis: data.syncedAtMillis.present
          ? data.syncedAtMillis.value
          : this.syncedAtMillis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LearningEvent(')
          ..write('eventId: $eventId, ')
          ..write('localProfileId: $localProfileId, ')
          ..write('firebaseUid: $firebaseUid, ')
          ..write('installationId: $installationId, ')
          ..write('eventType: $eventType, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('timestampMillis: $timestampMillis, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAtMillis: $createdAtMillis, ')
          ..write('syncedAtMillis: $syncedAtMillis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    eventId,
    localProfileId,
    firebaseUid,
    installationId,
    eventType,
    entityType,
    entityId,
    timestampMillis,
    payloadJson,
    syncStatus,
    createdAtMillis,
    syncedAtMillis,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LearningEvent &&
          other.eventId == this.eventId &&
          other.localProfileId == this.localProfileId &&
          other.firebaseUid == this.firebaseUid &&
          other.installationId == this.installationId &&
          other.eventType == this.eventType &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.timestampMillis == this.timestampMillis &&
          other.payloadJson == this.payloadJson &&
          other.syncStatus == this.syncStatus &&
          other.createdAtMillis == this.createdAtMillis &&
          other.syncedAtMillis == this.syncedAtMillis);
}

class LearningEventsCompanion extends UpdateCompanion<LearningEvent> {
  final Value<String> eventId;
  final Value<String> localProfileId;
  final Value<String?> firebaseUid;
  final Value<String> installationId;
  final Value<String> eventType;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<int> timestampMillis;
  final Value<String> payloadJson;
  final Value<String> syncStatus;
  final Value<int> createdAtMillis;
  final Value<int?> syncedAtMillis;
  final Value<int> rowid;
  const LearningEventsCompanion({
    this.eventId = const Value.absent(),
    this.localProfileId = const Value.absent(),
    this.firebaseUid = const Value.absent(),
    this.installationId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.timestampMillis = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAtMillis = const Value.absent(),
    this.syncedAtMillis = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LearningEventsCompanion.insert({
    required String eventId,
    required String localProfileId,
    this.firebaseUid = const Value.absent(),
    required String installationId,
    required String eventType,
    required String entityType,
    required String entityId,
    required int timestampMillis,
    required String payloadJson,
    this.syncStatus = const Value.absent(),
    required int createdAtMillis,
    this.syncedAtMillis = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : eventId = Value(eventId),
       localProfileId = Value(localProfileId),
       installationId = Value(installationId),
       eventType = Value(eventType),
       entityType = Value(entityType),
       entityId = Value(entityId),
       timestampMillis = Value(timestampMillis),
       payloadJson = Value(payloadJson),
       createdAtMillis = Value(createdAtMillis);
  static Insertable<LearningEvent> custom({
    Expression<String>? eventId,
    Expression<String>? localProfileId,
    Expression<String>? firebaseUid,
    Expression<String>? installationId,
    Expression<String>? eventType,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<int>? timestampMillis,
    Expression<String>? payloadJson,
    Expression<String>? syncStatus,
    Expression<int>? createdAtMillis,
    Expression<int>? syncedAtMillis,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventId != null) 'event_id': eventId,
      if (localProfileId != null) 'local_profile_id': localProfileId,
      if (firebaseUid != null) 'firebase_uid': firebaseUid,
      if (installationId != null) 'installation_id': installationId,
      if (eventType != null) 'event_type': eventType,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (timestampMillis != null) 'timestamp_millis': timestampMillis,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (createdAtMillis != null) 'created_at_millis': createdAtMillis,
      if (syncedAtMillis != null) 'synced_at_millis': syncedAtMillis,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LearningEventsCompanion copyWith({
    Value<String>? eventId,
    Value<String>? localProfileId,
    Value<String?>? firebaseUid,
    Value<String>? installationId,
    Value<String>? eventType,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<int>? timestampMillis,
    Value<String>? payloadJson,
    Value<String>? syncStatus,
    Value<int>? createdAtMillis,
    Value<int?>? syncedAtMillis,
    Value<int>? rowid,
  }) {
    return LearningEventsCompanion(
      eventId: eventId ?? this.eventId,
      localProfileId: localProfileId ?? this.localProfileId,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      installationId: installationId ?? this.installationId,
      eventType: eventType ?? this.eventType,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      timestampMillis: timestampMillis ?? this.timestampMillis,
      payloadJson: payloadJson ?? this.payloadJson,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAtMillis: createdAtMillis ?? this.createdAtMillis,
      syncedAtMillis: syncedAtMillis ?? this.syncedAtMillis,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (localProfileId.present) {
      map['local_profile_id'] = Variable<String>(localProfileId.value);
    }
    if (firebaseUid.present) {
      map['firebase_uid'] = Variable<String>(firebaseUid.value);
    }
    if (installationId.present) {
      map['installation_id'] = Variable<String>(installationId.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (timestampMillis.present) {
      map['timestamp_millis'] = Variable<int>(timestampMillis.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (createdAtMillis.present) {
      map['created_at_millis'] = Variable<int>(createdAtMillis.value);
    }
    if (syncedAtMillis.present) {
      map['synced_at_millis'] = Variable<int>(syncedAtMillis.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LearningEventsCompanion(')
          ..write('eventId: $eventId, ')
          ..write('localProfileId: $localProfileId, ')
          ..write('firebaseUid: $firebaseUid, ')
          ..write('installationId: $installationId, ')
          ..write('eventType: $eventType, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('timestampMillis: $timestampMillis, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAtMillis: $createdAtMillis, ')
          ..write('syncedAtMillis: $syncedAtMillis, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueItemsTable extends SyncQueueItems
    with TableInfo<$SyncQueueItemsTable, SyncQueueItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _queueIdMeta = const VerificationMeta(
    'queueId',
  );
  @override
  late final GeneratedColumn<String> queueId = GeneratedColumn<String>(
    'queue_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localProfileIdMeta = const VerificationMeta(
    'localProfileId',
  );
  @override
  late final GeneratedColumn<String> localProfileId = GeneratedColumn<String>(
    'local_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _documentPathMeta = const VerificationMeta(
    'documentPath',
  );
  @override
  late final GeneratedColumn<String> documentPath = GeneratedColumn<String>(
    'document_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _documentIdMeta = const VerificationMeta(
    'documentId',
  );
  @override
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
    'document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadVersionMeta = const VerificationMeta(
    'payloadVersion',
  );
  @override
  late final GeneratedColumn<int> payloadVersion = GeneratedColumn<int>(
    'payload_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextAttemptAtMillisMeta =
      const VerificationMeta('nextAttemptAtMillis');
  @override
  late final GeneratedColumn<int> nextAttemptAtMillis = GeneratedColumn<int>(
    'next_attempt_at_millis',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMillisMeta = const VerificationMeta(
    'createdAtMillis',
  );
  @override
  late final GeneratedColumn<int> createdAtMillis = GeneratedColumn<int>(
    'created_at_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMillisMeta = const VerificationMeta(
    'updatedAtMillis',
  );
  @override
  late final GeneratedColumn<int> updatedAtMillis = GeneratedColumn<int>(
    'updated_at_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    queueId,
    localProfileId,
    documentPath,
    documentId,
    payloadJson,
    payloadVersion,
    status,
    attemptCount,
    nextAttemptAtMillis,
    lastError,
    createdAtMillis,
    updatedAtMillis,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('queue_id')) {
      context.handle(
        _queueIdMeta,
        queueId.isAcceptableOrUnknown(data['queue_id']!, _queueIdMeta),
      );
    } else if (isInserting) {
      context.missing(_queueIdMeta);
    }
    if (data.containsKey('local_profile_id')) {
      context.handle(
        _localProfileIdMeta,
        localProfileId.isAcceptableOrUnknown(
          data['local_profile_id']!,
          _localProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localProfileIdMeta);
    }
    if (data.containsKey('document_path')) {
      context.handle(
        _documentPathMeta,
        documentPath.isAcceptableOrUnknown(
          data['document_path']!,
          _documentPathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_documentPathMeta);
    }
    if (data.containsKey('document_id')) {
      context.handle(
        _documentIdMeta,
        documentId.isAcceptableOrUnknown(data['document_id']!, _documentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('payload_version')) {
      context.handle(
        _payloadVersionMeta,
        payloadVersion.isAcceptableOrUnknown(
          data['payload_version']!,
          _payloadVersionMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('next_attempt_at_millis')) {
      context.handle(
        _nextAttemptAtMillisMeta,
        nextAttemptAtMillis.isAcceptableOrUnknown(
          data['next_attempt_at_millis']!,
          _nextAttemptAtMillisMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('created_at_millis')) {
      context.handle(
        _createdAtMillisMeta,
        createdAtMillis.isAcceptableOrUnknown(
          data['created_at_millis']!,
          _createdAtMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtMillisMeta);
    }
    if (data.containsKey('updated_at_millis')) {
      context.handle(
        _updatedAtMillisMeta,
        updatedAtMillis.isAcceptableOrUnknown(
          data['updated_at_millis']!,
          _updatedAtMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMillisMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {queueId};
  @override
  SyncQueueItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueItem(
      queueId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}queue_id'],
      )!,
      localProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_profile_id'],
      )!,
      documentPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_path'],
      )!,
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_id'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      payloadVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payload_version'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      nextAttemptAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_attempt_at_millis'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_millis'],
      )!,
      updatedAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_millis'],
      )!,
    );
  }

  @override
  $SyncQueueItemsTable createAlias(String alias) {
    return $SyncQueueItemsTable(attachedDatabase, alias);
  }
}

class SyncQueueItem extends DataClass implements Insertable<SyncQueueItem> {
  final String queueId;
  final String localProfileId;
  final String documentPath;
  final String documentId;
  final String payloadJson;
  final int payloadVersion;
  final String status;
  final int attemptCount;
  final int? nextAttemptAtMillis;
  final String? lastError;
  final int createdAtMillis;
  final int updatedAtMillis;
  const SyncQueueItem({
    required this.queueId,
    required this.localProfileId,
    required this.documentPath,
    required this.documentId,
    required this.payloadJson,
    required this.payloadVersion,
    required this.status,
    required this.attemptCount,
    this.nextAttemptAtMillis,
    this.lastError,
    required this.createdAtMillis,
    required this.updatedAtMillis,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['queue_id'] = Variable<String>(queueId);
    map['local_profile_id'] = Variable<String>(localProfileId);
    map['document_path'] = Variable<String>(documentPath);
    map['document_id'] = Variable<String>(documentId);
    map['payload_json'] = Variable<String>(payloadJson);
    map['payload_version'] = Variable<int>(payloadVersion);
    map['status'] = Variable<String>(status);
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || nextAttemptAtMillis != null) {
      map['next_attempt_at_millis'] = Variable<int>(nextAttemptAtMillis);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at_millis'] = Variable<int>(createdAtMillis);
    map['updated_at_millis'] = Variable<int>(updatedAtMillis);
    return map;
  }

  SyncQueueItemsCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueItemsCompanion(
      queueId: Value(queueId),
      localProfileId: Value(localProfileId),
      documentPath: Value(documentPath),
      documentId: Value(documentId),
      payloadJson: Value(payloadJson),
      payloadVersion: Value(payloadVersion),
      status: Value(status),
      attemptCount: Value(attemptCount),
      nextAttemptAtMillis: nextAttemptAtMillis == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAtMillis),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAtMillis: Value(createdAtMillis),
      updatedAtMillis: Value(updatedAtMillis),
    );
  }

  factory SyncQueueItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueItem(
      queueId: serializer.fromJson<String>(json['queueId']),
      localProfileId: serializer.fromJson<String>(json['localProfileId']),
      documentPath: serializer.fromJson<String>(json['documentPath']),
      documentId: serializer.fromJson<String>(json['documentId']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      payloadVersion: serializer.fromJson<int>(json['payloadVersion']),
      status: serializer.fromJson<String>(json['status']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      nextAttemptAtMillis: serializer.fromJson<int?>(
        json['nextAttemptAtMillis'],
      ),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAtMillis: serializer.fromJson<int>(json['createdAtMillis']),
      updatedAtMillis: serializer.fromJson<int>(json['updatedAtMillis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'queueId': serializer.toJson<String>(queueId),
      'localProfileId': serializer.toJson<String>(localProfileId),
      'documentPath': serializer.toJson<String>(documentPath),
      'documentId': serializer.toJson<String>(documentId),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'payloadVersion': serializer.toJson<int>(payloadVersion),
      'status': serializer.toJson<String>(status),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'nextAttemptAtMillis': serializer.toJson<int?>(nextAttemptAtMillis),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAtMillis': serializer.toJson<int>(createdAtMillis),
      'updatedAtMillis': serializer.toJson<int>(updatedAtMillis),
    };
  }

  SyncQueueItem copyWith({
    String? queueId,
    String? localProfileId,
    String? documentPath,
    String? documentId,
    String? payloadJson,
    int? payloadVersion,
    String? status,
    int? attemptCount,
    Value<int?> nextAttemptAtMillis = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
    int? createdAtMillis,
    int? updatedAtMillis,
  }) => SyncQueueItem(
    queueId: queueId ?? this.queueId,
    localProfileId: localProfileId ?? this.localProfileId,
    documentPath: documentPath ?? this.documentPath,
    documentId: documentId ?? this.documentId,
    payloadJson: payloadJson ?? this.payloadJson,
    payloadVersion: payloadVersion ?? this.payloadVersion,
    status: status ?? this.status,
    attemptCount: attemptCount ?? this.attemptCount,
    nextAttemptAtMillis: nextAttemptAtMillis.present
        ? nextAttemptAtMillis.value
        : this.nextAttemptAtMillis,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAtMillis: createdAtMillis ?? this.createdAtMillis,
    updatedAtMillis: updatedAtMillis ?? this.updatedAtMillis,
  );
  SyncQueueItem copyWithCompanion(SyncQueueItemsCompanion data) {
    return SyncQueueItem(
      queueId: data.queueId.present ? data.queueId.value : this.queueId,
      localProfileId: data.localProfileId.present
          ? data.localProfileId.value
          : this.localProfileId,
      documentPath: data.documentPath.present
          ? data.documentPath.value
          : this.documentPath,
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      payloadVersion: data.payloadVersion.present
          ? data.payloadVersion.value
          : this.payloadVersion,
      status: data.status.present ? data.status.value : this.status,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      nextAttemptAtMillis: data.nextAttemptAtMillis.present
          ? data.nextAttemptAtMillis.value
          : this.nextAttemptAtMillis,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAtMillis: data.createdAtMillis.present
          ? data.createdAtMillis.value
          : this.createdAtMillis,
      updatedAtMillis: data.updatedAtMillis.present
          ? data.updatedAtMillis.value
          : this.updatedAtMillis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueItem(')
          ..write('queueId: $queueId, ')
          ..write('localProfileId: $localProfileId, ')
          ..write('documentPath: $documentPath, ')
          ..write('documentId: $documentId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('payloadVersion: $payloadVersion, ')
          ..write('status: $status, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('nextAttemptAtMillis: $nextAttemptAtMillis, ')
          ..write('lastError: $lastError, ')
          ..write('createdAtMillis: $createdAtMillis, ')
          ..write('updatedAtMillis: $updatedAtMillis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    queueId,
    localProfileId,
    documentPath,
    documentId,
    payloadJson,
    payloadVersion,
    status,
    attemptCount,
    nextAttemptAtMillis,
    lastError,
    createdAtMillis,
    updatedAtMillis,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueItem &&
          other.queueId == this.queueId &&
          other.localProfileId == this.localProfileId &&
          other.documentPath == this.documentPath &&
          other.documentId == this.documentId &&
          other.payloadJson == this.payloadJson &&
          other.payloadVersion == this.payloadVersion &&
          other.status == this.status &&
          other.attemptCount == this.attemptCount &&
          other.nextAttemptAtMillis == this.nextAttemptAtMillis &&
          other.lastError == this.lastError &&
          other.createdAtMillis == this.createdAtMillis &&
          other.updatedAtMillis == this.updatedAtMillis);
}

class SyncQueueItemsCompanion extends UpdateCompanion<SyncQueueItem> {
  final Value<String> queueId;
  final Value<String> localProfileId;
  final Value<String> documentPath;
  final Value<String> documentId;
  final Value<String> payloadJson;
  final Value<int> payloadVersion;
  final Value<String> status;
  final Value<int> attemptCount;
  final Value<int?> nextAttemptAtMillis;
  final Value<String?> lastError;
  final Value<int> createdAtMillis;
  final Value<int> updatedAtMillis;
  final Value<int> rowid;
  const SyncQueueItemsCompanion({
    this.queueId = const Value.absent(),
    this.localProfileId = const Value.absent(),
    this.documentPath = const Value.absent(),
    this.documentId = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.payloadVersion = const Value.absent(),
    this.status = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.nextAttemptAtMillis = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAtMillis = const Value.absent(),
    this.updatedAtMillis = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueItemsCompanion.insert({
    required String queueId,
    required String localProfileId,
    required String documentPath,
    required String documentId,
    required String payloadJson,
    this.payloadVersion = const Value.absent(),
    this.status = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.nextAttemptAtMillis = const Value.absent(),
    this.lastError = const Value.absent(),
    required int createdAtMillis,
    required int updatedAtMillis,
    this.rowid = const Value.absent(),
  }) : queueId = Value(queueId),
       localProfileId = Value(localProfileId),
       documentPath = Value(documentPath),
       documentId = Value(documentId),
       payloadJson = Value(payloadJson),
       createdAtMillis = Value(createdAtMillis),
       updatedAtMillis = Value(updatedAtMillis);
  static Insertable<SyncQueueItem> custom({
    Expression<String>? queueId,
    Expression<String>? localProfileId,
    Expression<String>? documentPath,
    Expression<String>? documentId,
    Expression<String>? payloadJson,
    Expression<int>? payloadVersion,
    Expression<String>? status,
    Expression<int>? attemptCount,
    Expression<int>? nextAttemptAtMillis,
    Expression<String>? lastError,
    Expression<int>? createdAtMillis,
    Expression<int>? updatedAtMillis,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (queueId != null) 'queue_id': queueId,
      if (localProfileId != null) 'local_profile_id': localProfileId,
      if (documentPath != null) 'document_path': documentPath,
      if (documentId != null) 'document_id': documentId,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (payloadVersion != null) 'payload_version': payloadVersion,
      if (status != null) 'status': status,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (nextAttemptAtMillis != null)
        'next_attempt_at_millis': nextAttemptAtMillis,
      if (lastError != null) 'last_error': lastError,
      if (createdAtMillis != null) 'created_at_millis': createdAtMillis,
      if (updatedAtMillis != null) 'updated_at_millis': updatedAtMillis,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueItemsCompanion copyWith({
    Value<String>? queueId,
    Value<String>? localProfileId,
    Value<String>? documentPath,
    Value<String>? documentId,
    Value<String>? payloadJson,
    Value<int>? payloadVersion,
    Value<String>? status,
    Value<int>? attemptCount,
    Value<int?>? nextAttemptAtMillis,
    Value<String?>? lastError,
    Value<int>? createdAtMillis,
    Value<int>? updatedAtMillis,
    Value<int>? rowid,
  }) {
    return SyncQueueItemsCompanion(
      queueId: queueId ?? this.queueId,
      localProfileId: localProfileId ?? this.localProfileId,
      documentPath: documentPath ?? this.documentPath,
      documentId: documentId ?? this.documentId,
      payloadJson: payloadJson ?? this.payloadJson,
      payloadVersion: payloadVersion ?? this.payloadVersion,
      status: status ?? this.status,
      attemptCount: attemptCount ?? this.attemptCount,
      nextAttemptAtMillis: nextAttemptAtMillis ?? this.nextAttemptAtMillis,
      lastError: lastError ?? this.lastError,
      createdAtMillis: createdAtMillis ?? this.createdAtMillis,
      updatedAtMillis: updatedAtMillis ?? this.updatedAtMillis,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (queueId.present) {
      map['queue_id'] = Variable<String>(queueId.value);
    }
    if (localProfileId.present) {
      map['local_profile_id'] = Variable<String>(localProfileId.value);
    }
    if (documentPath.present) {
      map['document_path'] = Variable<String>(documentPath.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (payloadVersion.present) {
      map['payload_version'] = Variable<int>(payloadVersion.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (nextAttemptAtMillis.present) {
      map['next_attempt_at_millis'] = Variable<int>(nextAttemptAtMillis.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAtMillis.present) {
      map['created_at_millis'] = Variable<int>(createdAtMillis.value);
    }
    if (updatedAtMillis.present) {
      map['updated_at_millis'] = Variable<int>(updatedAtMillis.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueItemsCompanion(')
          ..write('queueId: $queueId, ')
          ..write('localProfileId: $localProfileId, ')
          ..write('documentPath: $documentPath, ')
          ..write('documentId: $documentId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('payloadVersion: $payloadVersion, ')
          ..write('status: $status, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('nextAttemptAtMillis: $nextAttemptAtMillis, ')
          ..write('lastError: $lastError, ')
          ..write('createdAtMillis: $createdAtMillis, ')
          ..write('updatedAtMillis: $updatedAtMillis, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataRowsTable extends SyncMetadataRows
    with TableInfo<$SyncMetadataRowsTable, SyncMetadataRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localProfileIdMeta = const VerificationMeta(
    'localProfileId',
  );
  @override
  late final GeneratedColumn<String> localProfileId = GeneratedColumn<String>(
    'local_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncAtMillisMeta = const VerificationMeta(
    'lastSyncAtMillis',
  );
  @override
  late final GeneratedColumn<int> lastSyncAtMillis = GeneratedColumn<int>(
    'last_sync_at_millis',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastResultMeta = const VerificationMeta(
    'lastResult',
  );
  @override
  late final GeneratedColumn<String> lastResult = GeneratedColumn<String>(
    'last_result',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    localProfileId,
    lastSyncAtMillis,
    lastResult,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetadataRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_profile_id')) {
      context.handle(
        _localProfileIdMeta,
        localProfileId.isAcceptableOrUnknown(
          data['local_profile_id']!,
          _localProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localProfileIdMeta);
    }
    if (data.containsKey('last_sync_at_millis')) {
      context.handle(
        _lastSyncAtMillisMeta,
        lastSyncAtMillis.isAcceptableOrUnknown(
          data['last_sync_at_millis']!,
          _lastSyncAtMillisMeta,
        ),
      );
    }
    if (data.containsKey('last_result')) {
      context.handle(
        _lastResultMeta,
        lastResult.isAcceptableOrUnknown(data['last_result']!, _lastResultMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localProfileId};
  @override
  SyncMetadataRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadataRow(
      localProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_profile_id'],
      )!,
      lastSyncAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_sync_at_millis'],
      ),
      lastResult: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_result'],
      ),
    );
  }

  @override
  $SyncMetadataRowsTable createAlias(String alias) {
    return $SyncMetadataRowsTable(attachedDatabase, alias);
  }
}

class SyncMetadataRow extends DataClass implements Insertable<SyncMetadataRow> {
  final String localProfileId;
  final int? lastSyncAtMillis;
  final String? lastResult;
  const SyncMetadataRow({
    required this.localProfileId,
    this.lastSyncAtMillis,
    this.lastResult,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_profile_id'] = Variable<String>(localProfileId);
    if (!nullToAbsent || lastSyncAtMillis != null) {
      map['last_sync_at_millis'] = Variable<int>(lastSyncAtMillis);
    }
    if (!nullToAbsent || lastResult != null) {
      map['last_result'] = Variable<String>(lastResult);
    }
    return map;
  }

  SyncMetadataRowsCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataRowsCompanion(
      localProfileId: Value(localProfileId),
      lastSyncAtMillis: lastSyncAtMillis == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAtMillis),
      lastResult: lastResult == null && nullToAbsent
          ? const Value.absent()
          : Value(lastResult),
    );
  }

  factory SyncMetadataRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadataRow(
      localProfileId: serializer.fromJson<String>(json['localProfileId']),
      lastSyncAtMillis: serializer.fromJson<int?>(json['lastSyncAtMillis']),
      lastResult: serializer.fromJson<String?>(json['lastResult']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localProfileId': serializer.toJson<String>(localProfileId),
      'lastSyncAtMillis': serializer.toJson<int?>(lastSyncAtMillis),
      'lastResult': serializer.toJson<String?>(lastResult),
    };
  }

  SyncMetadataRow copyWith({
    String? localProfileId,
    Value<int?> lastSyncAtMillis = const Value.absent(),
    Value<String?> lastResult = const Value.absent(),
  }) => SyncMetadataRow(
    localProfileId: localProfileId ?? this.localProfileId,
    lastSyncAtMillis: lastSyncAtMillis.present
        ? lastSyncAtMillis.value
        : this.lastSyncAtMillis,
    lastResult: lastResult.present ? lastResult.value : this.lastResult,
  );
  SyncMetadataRow copyWithCompanion(SyncMetadataRowsCompanion data) {
    return SyncMetadataRow(
      localProfileId: data.localProfileId.present
          ? data.localProfileId.value
          : this.localProfileId,
      lastSyncAtMillis: data.lastSyncAtMillis.present
          ? data.lastSyncAtMillis.value
          : this.lastSyncAtMillis,
      lastResult: data.lastResult.present
          ? data.lastResult.value
          : this.lastResult,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataRow(')
          ..write('localProfileId: $localProfileId, ')
          ..write('lastSyncAtMillis: $lastSyncAtMillis, ')
          ..write('lastResult: $lastResult')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(localProfileId, lastSyncAtMillis, lastResult);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadataRow &&
          other.localProfileId == this.localProfileId &&
          other.lastSyncAtMillis == this.lastSyncAtMillis &&
          other.lastResult == this.lastResult);
}

class SyncMetadataRowsCompanion extends UpdateCompanion<SyncMetadataRow> {
  final Value<String> localProfileId;
  final Value<int?> lastSyncAtMillis;
  final Value<String?> lastResult;
  final Value<int> rowid;
  const SyncMetadataRowsCompanion({
    this.localProfileId = const Value.absent(),
    this.lastSyncAtMillis = const Value.absent(),
    this.lastResult = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetadataRowsCompanion.insert({
    required String localProfileId,
    this.lastSyncAtMillis = const Value.absent(),
    this.lastResult = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localProfileId = Value(localProfileId);
  static Insertable<SyncMetadataRow> custom({
    Expression<String>? localProfileId,
    Expression<int>? lastSyncAtMillis,
    Expression<String>? lastResult,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localProfileId != null) 'local_profile_id': localProfileId,
      if (lastSyncAtMillis != null) 'last_sync_at_millis': lastSyncAtMillis,
      if (lastResult != null) 'last_result': lastResult,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetadataRowsCompanion copyWith({
    Value<String>? localProfileId,
    Value<int?>? lastSyncAtMillis,
    Value<String?>? lastResult,
    Value<int>? rowid,
  }) {
    return SyncMetadataRowsCompanion(
      localProfileId: localProfileId ?? this.localProfileId,
      lastSyncAtMillis: lastSyncAtMillis ?? this.lastSyncAtMillis,
      lastResult: lastResult ?? this.lastResult,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localProfileId.present) {
      map['local_profile_id'] = Variable<String>(localProfileId.value);
    }
    if (lastSyncAtMillis.present) {
      map['last_sync_at_millis'] = Variable<int>(lastSyncAtMillis.value);
    }
    if (lastResult.present) {
      map['last_result'] = Variable<String>(lastResult.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataRowsCompanion(')
          ..write('localProfileId: $localProfileId, ')
          ..write('lastSyncAtMillis: $lastSyncAtMillis, ')
          ..write('lastResult: $lastResult, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyProgressBaselinesTable extends LegacyProgressBaselines
    with TableInfo<$LegacyProgressBaselinesTable, LegacyProgressBaseline> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyProgressBaselinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localProfileIdMeta = const VerificationMeta(
    'localProfileId',
  );
  @override
  late final GeneratedColumn<String> localProfileId = GeneratedColumn<String>(
    'local_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _onboardingReachedMeta = const VerificationMeta(
    'onboardingReached',
  );
  @override
  late final GeneratedColumn<int> onboardingReached = GeneratedColumn<int>(
    'onboarding_reached',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _belajarReachedMeta = const VerificationMeta(
    'belajarReached',
  );
  @override
  late final GeneratedColumn<int> belajarReached = GeneratedColumn<int>(
    'belajar_reached',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _learningReachedMeta = const VerificationMeta(
    'learningReached',
  );
  @override
  late final GeneratedColumn<int> learningReached = GeneratedColumn<int>(
    'learning_reached',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _quizAnsweredMeta = const VerificationMeta(
    'quizAnswered',
  );
  @override
  late final GeneratedColumn<int> quizAnswered = GeneratedColumn<int>(
    'quiz_answered',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _quizAutoCorrectMeta = const VerificationMeta(
    'quizAutoCorrect',
  );
  @override
  late final GeneratedColumn<int> quizAutoCorrect = GeneratedColumn<int>(
    'quiz_auto_correct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _quizAutoTotalMeta = const VerificationMeta(
    'quizAutoTotal',
  );
  @override
  late final GeneratedColumn<int> quizAutoTotal = GeneratedColumn<int>(
    'quiz_auto_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _quizSessionsCompletedMeta =
      const VerificationMeta('quizSessionsCompleted');
  @override
  late final GeneratedColumn<int> quizSessionsCompleted = GeneratedColumn<int>(
    'quiz_sessions_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _gameStarsEarnedMeta = const VerificationMeta(
    'gameStarsEarned',
  );
  @override
  late final GeneratedColumn<int> gameStarsEarned = GeneratedColumn<int>(
    'game_stars_earned',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _gameStarsPossibleMeta = const VerificationMeta(
    'gameStarsPossible',
  );
  @override
  late final GeneratedColumn<int> gameStarsPossible = GeneratedColumn<int>(
    'game_stars_possible',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _gameSessionsCompletedMeta =
      const VerificationMeta('gameSessionsCompleted');
  @override
  late final GeneratedColumn<int> gameSessionsCompleted = GeneratedColumn<int>(
    'game_sessions_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _migratedAtMillisMeta = const VerificationMeta(
    'migratedAtMillis',
  );
  @override
  late final GeneratedColumn<int> migratedAtMillis = GeneratedColumn<int>(
    'migrated_at_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    localProfileId,
    onboardingReached,
    belajarReached,
    learningReached,
    quizAnswered,
    quizAutoCorrect,
    quizAutoTotal,
    quizSessionsCompleted,
    gameStarsEarned,
    gameStarsPossible,
    gameSessionsCompleted,
    migratedAtMillis,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'legacy_progress_baselines';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyProgressBaseline> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_profile_id')) {
      context.handle(
        _localProfileIdMeta,
        localProfileId.isAcceptableOrUnknown(
          data['local_profile_id']!,
          _localProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localProfileIdMeta);
    }
    if (data.containsKey('onboarding_reached')) {
      context.handle(
        _onboardingReachedMeta,
        onboardingReached.isAcceptableOrUnknown(
          data['onboarding_reached']!,
          _onboardingReachedMeta,
        ),
      );
    }
    if (data.containsKey('belajar_reached')) {
      context.handle(
        _belajarReachedMeta,
        belajarReached.isAcceptableOrUnknown(
          data['belajar_reached']!,
          _belajarReachedMeta,
        ),
      );
    }
    if (data.containsKey('learning_reached')) {
      context.handle(
        _learningReachedMeta,
        learningReached.isAcceptableOrUnknown(
          data['learning_reached']!,
          _learningReachedMeta,
        ),
      );
    }
    if (data.containsKey('quiz_answered')) {
      context.handle(
        _quizAnsweredMeta,
        quizAnswered.isAcceptableOrUnknown(
          data['quiz_answered']!,
          _quizAnsweredMeta,
        ),
      );
    }
    if (data.containsKey('quiz_auto_correct')) {
      context.handle(
        _quizAutoCorrectMeta,
        quizAutoCorrect.isAcceptableOrUnknown(
          data['quiz_auto_correct']!,
          _quizAutoCorrectMeta,
        ),
      );
    }
    if (data.containsKey('quiz_auto_total')) {
      context.handle(
        _quizAutoTotalMeta,
        quizAutoTotal.isAcceptableOrUnknown(
          data['quiz_auto_total']!,
          _quizAutoTotalMeta,
        ),
      );
    }
    if (data.containsKey('quiz_sessions_completed')) {
      context.handle(
        _quizSessionsCompletedMeta,
        quizSessionsCompleted.isAcceptableOrUnknown(
          data['quiz_sessions_completed']!,
          _quizSessionsCompletedMeta,
        ),
      );
    }
    if (data.containsKey('game_stars_earned')) {
      context.handle(
        _gameStarsEarnedMeta,
        gameStarsEarned.isAcceptableOrUnknown(
          data['game_stars_earned']!,
          _gameStarsEarnedMeta,
        ),
      );
    }
    if (data.containsKey('game_stars_possible')) {
      context.handle(
        _gameStarsPossibleMeta,
        gameStarsPossible.isAcceptableOrUnknown(
          data['game_stars_possible']!,
          _gameStarsPossibleMeta,
        ),
      );
    }
    if (data.containsKey('game_sessions_completed')) {
      context.handle(
        _gameSessionsCompletedMeta,
        gameSessionsCompleted.isAcceptableOrUnknown(
          data['game_sessions_completed']!,
          _gameSessionsCompletedMeta,
        ),
      );
    }
    if (data.containsKey('migrated_at_millis')) {
      context.handle(
        _migratedAtMillisMeta,
        migratedAtMillis.isAcceptableOrUnknown(
          data['migrated_at_millis']!,
          _migratedAtMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_migratedAtMillisMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localProfileId};
  @override
  LegacyProgressBaseline map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyProgressBaseline(
      localProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_profile_id'],
      )!,
      onboardingReached: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}onboarding_reached'],
      )!,
      belajarReached: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}belajar_reached'],
      )!,
      learningReached: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}learning_reached'],
      )!,
      quizAnswered: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quiz_answered'],
      )!,
      quizAutoCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quiz_auto_correct'],
      )!,
      quizAutoTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quiz_auto_total'],
      )!,
      quizSessionsCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quiz_sessions_completed'],
      )!,
      gameStarsEarned: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_stars_earned'],
      )!,
      gameStarsPossible: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_stars_possible'],
      )!,
      gameSessionsCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_sessions_completed'],
      )!,
      migratedAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}migrated_at_millis'],
      )!,
    );
  }

  @override
  $LegacyProgressBaselinesTable createAlias(String alias) {
    return $LegacyProgressBaselinesTable(attachedDatabase, alias);
  }
}

class LegacyProgressBaseline extends DataClass
    implements Insertable<LegacyProgressBaseline> {
  final String localProfileId;
  final int onboardingReached;
  final int belajarReached;
  final int learningReached;
  final int quizAnswered;
  final int quizAutoCorrect;
  final int quizAutoTotal;
  final int quizSessionsCompleted;
  final int gameStarsEarned;
  final int gameStarsPossible;
  final int gameSessionsCompleted;
  final int migratedAtMillis;
  const LegacyProgressBaseline({
    required this.localProfileId,
    required this.onboardingReached,
    required this.belajarReached,
    required this.learningReached,
    required this.quizAnswered,
    required this.quizAutoCorrect,
    required this.quizAutoTotal,
    required this.quizSessionsCompleted,
    required this.gameStarsEarned,
    required this.gameStarsPossible,
    required this.gameSessionsCompleted,
    required this.migratedAtMillis,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_profile_id'] = Variable<String>(localProfileId);
    map['onboarding_reached'] = Variable<int>(onboardingReached);
    map['belajar_reached'] = Variable<int>(belajarReached);
    map['learning_reached'] = Variable<int>(learningReached);
    map['quiz_answered'] = Variable<int>(quizAnswered);
    map['quiz_auto_correct'] = Variable<int>(quizAutoCorrect);
    map['quiz_auto_total'] = Variable<int>(quizAutoTotal);
    map['quiz_sessions_completed'] = Variable<int>(quizSessionsCompleted);
    map['game_stars_earned'] = Variable<int>(gameStarsEarned);
    map['game_stars_possible'] = Variable<int>(gameStarsPossible);
    map['game_sessions_completed'] = Variable<int>(gameSessionsCompleted);
    map['migrated_at_millis'] = Variable<int>(migratedAtMillis);
    return map;
  }

  LegacyProgressBaselinesCompanion toCompanion(bool nullToAbsent) {
    return LegacyProgressBaselinesCompanion(
      localProfileId: Value(localProfileId),
      onboardingReached: Value(onboardingReached),
      belajarReached: Value(belajarReached),
      learningReached: Value(learningReached),
      quizAnswered: Value(quizAnswered),
      quizAutoCorrect: Value(quizAutoCorrect),
      quizAutoTotal: Value(quizAutoTotal),
      quizSessionsCompleted: Value(quizSessionsCompleted),
      gameStarsEarned: Value(gameStarsEarned),
      gameStarsPossible: Value(gameStarsPossible),
      gameSessionsCompleted: Value(gameSessionsCompleted),
      migratedAtMillis: Value(migratedAtMillis),
    );
  }

  factory LegacyProgressBaseline.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyProgressBaseline(
      localProfileId: serializer.fromJson<String>(json['localProfileId']),
      onboardingReached: serializer.fromJson<int>(json['onboardingReached']),
      belajarReached: serializer.fromJson<int>(json['belajarReached']),
      learningReached: serializer.fromJson<int>(json['learningReached']),
      quizAnswered: serializer.fromJson<int>(json['quizAnswered']),
      quizAutoCorrect: serializer.fromJson<int>(json['quizAutoCorrect']),
      quizAutoTotal: serializer.fromJson<int>(json['quizAutoTotal']),
      quizSessionsCompleted: serializer.fromJson<int>(
        json['quizSessionsCompleted'],
      ),
      gameStarsEarned: serializer.fromJson<int>(json['gameStarsEarned']),
      gameStarsPossible: serializer.fromJson<int>(json['gameStarsPossible']),
      gameSessionsCompleted: serializer.fromJson<int>(
        json['gameSessionsCompleted'],
      ),
      migratedAtMillis: serializer.fromJson<int>(json['migratedAtMillis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localProfileId': serializer.toJson<String>(localProfileId),
      'onboardingReached': serializer.toJson<int>(onboardingReached),
      'belajarReached': serializer.toJson<int>(belajarReached),
      'learningReached': serializer.toJson<int>(learningReached),
      'quizAnswered': serializer.toJson<int>(quizAnswered),
      'quizAutoCorrect': serializer.toJson<int>(quizAutoCorrect),
      'quizAutoTotal': serializer.toJson<int>(quizAutoTotal),
      'quizSessionsCompleted': serializer.toJson<int>(quizSessionsCompleted),
      'gameStarsEarned': serializer.toJson<int>(gameStarsEarned),
      'gameStarsPossible': serializer.toJson<int>(gameStarsPossible),
      'gameSessionsCompleted': serializer.toJson<int>(gameSessionsCompleted),
      'migratedAtMillis': serializer.toJson<int>(migratedAtMillis),
    };
  }

  LegacyProgressBaseline copyWith({
    String? localProfileId,
    int? onboardingReached,
    int? belajarReached,
    int? learningReached,
    int? quizAnswered,
    int? quizAutoCorrect,
    int? quizAutoTotal,
    int? quizSessionsCompleted,
    int? gameStarsEarned,
    int? gameStarsPossible,
    int? gameSessionsCompleted,
    int? migratedAtMillis,
  }) => LegacyProgressBaseline(
    localProfileId: localProfileId ?? this.localProfileId,
    onboardingReached: onboardingReached ?? this.onboardingReached,
    belajarReached: belajarReached ?? this.belajarReached,
    learningReached: learningReached ?? this.learningReached,
    quizAnswered: quizAnswered ?? this.quizAnswered,
    quizAutoCorrect: quizAutoCorrect ?? this.quizAutoCorrect,
    quizAutoTotal: quizAutoTotal ?? this.quizAutoTotal,
    quizSessionsCompleted: quizSessionsCompleted ?? this.quizSessionsCompleted,
    gameStarsEarned: gameStarsEarned ?? this.gameStarsEarned,
    gameStarsPossible: gameStarsPossible ?? this.gameStarsPossible,
    gameSessionsCompleted: gameSessionsCompleted ?? this.gameSessionsCompleted,
    migratedAtMillis: migratedAtMillis ?? this.migratedAtMillis,
  );
  LegacyProgressBaseline copyWithCompanion(
    LegacyProgressBaselinesCompanion data,
  ) {
    return LegacyProgressBaseline(
      localProfileId: data.localProfileId.present
          ? data.localProfileId.value
          : this.localProfileId,
      onboardingReached: data.onboardingReached.present
          ? data.onboardingReached.value
          : this.onboardingReached,
      belajarReached: data.belajarReached.present
          ? data.belajarReached.value
          : this.belajarReached,
      learningReached: data.learningReached.present
          ? data.learningReached.value
          : this.learningReached,
      quizAnswered: data.quizAnswered.present
          ? data.quizAnswered.value
          : this.quizAnswered,
      quizAutoCorrect: data.quizAutoCorrect.present
          ? data.quizAutoCorrect.value
          : this.quizAutoCorrect,
      quizAutoTotal: data.quizAutoTotal.present
          ? data.quizAutoTotal.value
          : this.quizAutoTotal,
      quizSessionsCompleted: data.quizSessionsCompleted.present
          ? data.quizSessionsCompleted.value
          : this.quizSessionsCompleted,
      gameStarsEarned: data.gameStarsEarned.present
          ? data.gameStarsEarned.value
          : this.gameStarsEarned,
      gameStarsPossible: data.gameStarsPossible.present
          ? data.gameStarsPossible.value
          : this.gameStarsPossible,
      gameSessionsCompleted: data.gameSessionsCompleted.present
          ? data.gameSessionsCompleted.value
          : this.gameSessionsCompleted,
      migratedAtMillis: data.migratedAtMillis.present
          ? data.migratedAtMillis.value
          : this.migratedAtMillis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyProgressBaseline(')
          ..write('localProfileId: $localProfileId, ')
          ..write('onboardingReached: $onboardingReached, ')
          ..write('belajarReached: $belajarReached, ')
          ..write('learningReached: $learningReached, ')
          ..write('quizAnswered: $quizAnswered, ')
          ..write('quizAutoCorrect: $quizAutoCorrect, ')
          ..write('quizAutoTotal: $quizAutoTotal, ')
          ..write('quizSessionsCompleted: $quizSessionsCompleted, ')
          ..write('gameStarsEarned: $gameStarsEarned, ')
          ..write('gameStarsPossible: $gameStarsPossible, ')
          ..write('gameSessionsCompleted: $gameSessionsCompleted, ')
          ..write('migratedAtMillis: $migratedAtMillis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localProfileId,
    onboardingReached,
    belajarReached,
    learningReached,
    quizAnswered,
    quizAutoCorrect,
    quizAutoTotal,
    quizSessionsCompleted,
    gameStarsEarned,
    gameStarsPossible,
    gameSessionsCompleted,
    migratedAtMillis,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyProgressBaseline &&
          other.localProfileId == this.localProfileId &&
          other.onboardingReached == this.onboardingReached &&
          other.belajarReached == this.belajarReached &&
          other.learningReached == this.learningReached &&
          other.quizAnswered == this.quizAnswered &&
          other.quizAutoCorrect == this.quizAutoCorrect &&
          other.quizAutoTotal == this.quizAutoTotal &&
          other.quizSessionsCompleted == this.quizSessionsCompleted &&
          other.gameStarsEarned == this.gameStarsEarned &&
          other.gameStarsPossible == this.gameStarsPossible &&
          other.gameSessionsCompleted == this.gameSessionsCompleted &&
          other.migratedAtMillis == this.migratedAtMillis);
}

class LegacyProgressBaselinesCompanion
    extends UpdateCompanion<LegacyProgressBaseline> {
  final Value<String> localProfileId;
  final Value<int> onboardingReached;
  final Value<int> belajarReached;
  final Value<int> learningReached;
  final Value<int> quizAnswered;
  final Value<int> quizAutoCorrect;
  final Value<int> quizAutoTotal;
  final Value<int> quizSessionsCompleted;
  final Value<int> gameStarsEarned;
  final Value<int> gameStarsPossible;
  final Value<int> gameSessionsCompleted;
  final Value<int> migratedAtMillis;
  final Value<int> rowid;
  const LegacyProgressBaselinesCompanion({
    this.localProfileId = const Value.absent(),
    this.onboardingReached = const Value.absent(),
    this.belajarReached = const Value.absent(),
    this.learningReached = const Value.absent(),
    this.quizAnswered = const Value.absent(),
    this.quizAutoCorrect = const Value.absent(),
    this.quizAutoTotal = const Value.absent(),
    this.quizSessionsCompleted = const Value.absent(),
    this.gameStarsEarned = const Value.absent(),
    this.gameStarsPossible = const Value.absent(),
    this.gameSessionsCompleted = const Value.absent(),
    this.migratedAtMillis = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyProgressBaselinesCompanion.insert({
    required String localProfileId,
    this.onboardingReached = const Value.absent(),
    this.belajarReached = const Value.absent(),
    this.learningReached = const Value.absent(),
    this.quizAnswered = const Value.absent(),
    this.quizAutoCorrect = const Value.absent(),
    this.quizAutoTotal = const Value.absent(),
    this.quizSessionsCompleted = const Value.absent(),
    this.gameStarsEarned = const Value.absent(),
    this.gameStarsPossible = const Value.absent(),
    this.gameSessionsCompleted = const Value.absent(),
    required int migratedAtMillis,
    this.rowid = const Value.absent(),
  }) : localProfileId = Value(localProfileId),
       migratedAtMillis = Value(migratedAtMillis);
  static Insertable<LegacyProgressBaseline> custom({
    Expression<String>? localProfileId,
    Expression<int>? onboardingReached,
    Expression<int>? belajarReached,
    Expression<int>? learningReached,
    Expression<int>? quizAnswered,
    Expression<int>? quizAutoCorrect,
    Expression<int>? quizAutoTotal,
    Expression<int>? quizSessionsCompleted,
    Expression<int>? gameStarsEarned,
    Expression<int>? gameStarsPossible,
    Expression<int>? gameSessionsCompleted,
    Expression<int>? migratedAtMillis,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localProfileId != null) 'local_profile_id': localProfileId,
      if (onboardingReached != null) 'onboarding_reached': onboardingReached,
      if (belajarReached != null) 'belajar_reached': belajarReached,
      if (learningReached != null) 'learning_reached': learningReached,
      if (quizAnswered != null) 'quiz_answered': quizAnswered,
      if (quizAutoCorrect != null) 'quiz_auto_correct': quizAutoCorrect,
      if (quizAutoTotal != null) 'quiz_auto_total': quizAutoTotal,
      if (quizSessionsCompleted != null)
        'quiz_sessions_completed': quizSessionsCompleted,
      if (gameStarsEarned != null) 'game_stars_earned': gameStarsEarned,
      if (gameStarsPossible != null) 'game_stars_possible': gameStarsPossible,
      if (gameSessionsCompleted != null)
        'game_sessions_completed': gameSessionsCompleted,
      if (migratedAtMillis != null) 'migrated_at_millis': migratedAtMillis,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyProgressBaselinesCompanion copyWith({
    Value<String>? localProfileId,
    Value<int>? onboardingReached,
    Value<int>? belajarReached,
    Value<int>? learningReached,
    Value<int>? quizAnswered,
    Value<int>? quizAutoCorrect,
    Value<int>? quizAutoTotal,
    Value<int>? quizSessionsCompleted,
    Value<int>? gameStarsEarned,
    Value<int>? gameStarsPossible,
    Value<int>? gameSessionsCompleted,
    Value<int>? migratedAtMillis,
    Value<int>? rowid,
  }) {
    return LegacyProgressBaselinesCompanion(
      localProfileId: localProfileId ?? this.localProfileId,
      onboardingReached: onboardingReached ?? this.onboardingReached,
      belajarReached: belajarReached ?? this.belajarReached,
      learningReached: learningReached ?? this.learningReached,
      quizAnswered: quizAnswered ?? this.quizAnswered,
      quizAutoCorrect: quizAutoCorrect ?? this.quizAutoCorrect,
      quizAutoTotal: quizAutoTotal ?? this.quizAutoTotal,
      quizSessionsCompleted:
          quizSessionsCompleted ?? this.quizSessionsCompleted,
      gameStarsEarned: gameStarsEarned ?? this.gameStarsEarned,
      gameStarsPossible: gameStarsPossible ?? this.gameStarsPossible,
      gameSessionsCompleted:
          gameSessionsCompleted ?? this.gameSessionsCompleted,
      migratedAtMillis: migratedAtMillis ?? this.migratedAtMillis,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localProfileId.present) {
      map['local_profile_id'] = Variable<String>(localProfileId.value);
    }
    if (onboardingReached.present) {
      map['onboarding_reached'] = Variable<int>(onboardingReached.value);
    }
    if (belajarReached.present) {
      map['belajar_reached'] = Variable<int>(belajarReached.value);
    }
    if (learningReached.present) {
      map['learning_reached'] = Variable<int>(learningReached.value);
    }
    if (quizAnswered.present) {
      map['quiz_answered'] = Variable<int>(quizAnswered.value);
    }
    if (quizAutoCorrect.present) {
      map['quiz_auto_correct'] = Variable<int>(quizAutoCorrect.value);
    }
    if (quizAutoTotal.present) {
      map['quiz_auto_total'] = Variable<int>(quizAutoTotal.value);
    }
    if (quizSessionsCompleted.present) {
      map['quiz_sessions_completed'] = Variable<int>(
        quizSessionsCompleted.value,
      );
    }
    if (gameStarsEarned.present) {
      map['game_stars_earned'] = Variable<int>(gameStarsEarned.value);
    }
    if (gameStarsPossible.present) {
      map['game_stars_possible'] = Variable<int>(gameStarsPossible.value);
    }
    if (gameSessionsCompleted.present) {
      map['game_sessions_completed'] = Variable<int>(
        gameSessionsCompleted.value,
      );
    }
    if (migratedAtMillis.present) {
      map['migrated_at_millis'] = Variable<int>(migratedAtMillis.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyProgressBaselinesCompanion(')
          ..write('localProfileId: $localProfileId, ')
          ..write('onboardingReached: $onboardingReached, ')
          ..write('belajarReached: $belajarReached, ')
          ..write('learningReached: $learningReached, ')
          ..write('quizAnswered: $quizAnswered, ')
          ..write('quizAutoCorrect: $quizAutoCorrect, ')
          ..write('quizAutoTotal: $quizAutoTotal, ')
          ..write('quizSessionsCompleted: $quizSessionsCompleted, ')
          ..write('gameStarsEarned: $gameStarsEarned, ')
          ..write('gameStarsPossible: $gameStarsPossible, ')
          ..write('gameSessionsCompleted: $gameSessionsCompleted, ')
          ..write('migratedAtMillis: $migratedAtMillis, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ProgressDatabase extends GeneratedDatabase {
  _$ProgressDatabase(QueryExecutor e) : super(e);
  $ProgressDatabaseManager get managers => $ProgressDatabaseManager(this);
  late final $StudentProfilesTable studentProfiles = $StudentProfilesTable(
    this,
  );
  late final $InstallationsTable installations = $InstallationsTable(this);
  late final $LessonProgressRowsTable lessonProgressRows =
      $LessonProgressRowsTable(this);
  late final $QuizAttemptsTable quizAttempts = $QuizAttemptsTable(this);
  late final $QuizAnswersTable quizAnswers = $QuizAnswersTable(this);
  late final $GameSessionsTable gameSessions = $GameSessionsTable(this);
  late final $LearningSessionsTable learningSessions = $LearningSessionsTable(
    this,
  );
  late final $LearningEventsTable learningEvents = $LearningEventsTable(this);
  late final $SyncQueueItemsTable syncQueueItems = $SyncQueueItemsTable(this);
  late final $SyncMetadataRowsTable syncMetadataRows = $SyncMetadataRowsTable(
    this,
  );
  late final $LegacyProgressBaselinesTable legacyProgressBaselines =
      $LegacyProgressBaselinesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    studentProfiles,
    installations,
    lessonProgressRows,
    quizAttempts,
    quizAnswers,
    gameSessions,
    learningSessions,
    learningEvents,
    syncQueueItems,
    syncMetadataRows,
    legacyProgressBaselines,
  ];
}

typedef $$StudentProfilesTableCreateCompanionBuilder =
    StudentProfilesCompanion Function({
      required String localId,
      Value<String?> firebaseUid,
      required String publicStudentId,
      required String displayName,
      Value<String> authState,
      Value<String?> legacyUserId,
      required int createdAtMillis,
      required int updatedAtMillis,
      Value<int> rowid,
    });
typedef $$StudentProfilesTableUpdateCompanionBuilder =
    StudentProfilesCompanion Function({
      Value<String> localId,
      Value<String?> firebaseUid,
      Value<String> publicStudentId,
      Value<String> displayName,
      Value<String> authState,
      Value<String?> legacyUserId,
      Value<int> createdAtMillis,
      Value<int> updatedAtMillis,
      Value<int> rowid,
    });

class $$StudentProfilesTableFilterComposer
    extends Composer<_$ProgressDatabase, $StudentProfilesTable> {
  $$StudentProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firebaseUid => $composableBuilder(
    column: $table.firebaseUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publicStudentId => $composableBuilder(
    column: $table.publicStudentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authState => $composableBuilder(
    column: $table.authState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get legacyUserId => $composableBuilder(
    column: $table.legacyUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMillis => $composableBuilder(
    column: $table.createdAtMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMillis => $composableBuilder(
    column: $table.updatedAtMillis,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StudentProfilesTableOrderingComposer
    extends Composer<_$ProgressDatabase, $StudentProfilesTable> {
  $$StudentProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firebaseUid => $composableBuilder(
    column: $table.firebaseUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publicStudentId => $composableBuilder(
    column: $table.publicStudentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authState => $composableBuilder(
    column: $table.authState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get legacyUserId => $composableBuilder(
    column: $table.legacyUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMillis => $composableBuilder(
    column: $table.createdAtMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMillis => $composableBuilder(
    column: $table.updatedAtMillis,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudentProfilesTableAnnotationComposer
    extends Composer<_$ProgressDatabase, $StudentProfilesTable> {
  $$StudentProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get firebaseUid => $composableBuilder(
    column: $table.firebaseUid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get publicStudentId => $composableBuilder(
    column: $table.publicStudentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authState =>
      $composableBuilder(column: $table.authState, builder: (column) => column);

  GeneratedColumn<String> get legacyUserId => $composableBuilder(
    column: $table.legacyUserId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtMillis => $composableBuilder(
    column: $table.createdAtMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtMillis => $composableBuilder(
    column: $table.updatedAtMillis,
    builder: (column) => column,
  );
}

class $$StudentProfilesTableTableManager
    extends
        RootTableManager<
          _$ProgressDatabase,
          $StudentProfilesTable,
          StudentProfile,
          $$StudentProfilesTableFilterComposer,
          $$StudentProfilesTableOrderingComposer,
          $$StudentProfilesTableAnnotationComposer,
          $$StudentProfilesTableCreateCompanionBuilder,
          $$StudentProfilesTableUpdateCompanionBuilder,
          (
            StudentProfile,
            BaseReferences<
              _$ProgressDatabase,
              $StudentProfilesTable,
              StudentProfile
            >,
          ),
          StudentProfile,
          PrefetchHooks Function()
        > {
  $$StudentProfilesTableTableManager(
    _$ProgressDatabase db,
    $StudentProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> firebaseUid = const Value.absent(),
                Value<String> publicStudentId = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> authState = const Value.absent(),
                Value<String?> legacyUserId = const Value.absent(),
                Value<int> createdAtMillis = const Value.absent(),
                Value<int> updatedAtMillis = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentProfilesCompanion(
                localId: localId,
                firebaseUid: firebaseUid,
                publicStudentId: publicStudentId,
                displayName: displayName,
                authState: authState,
                legacyUserId: legacyUserId,
                createdAtMillis: createdAtMillis,
                updatedAtMillis: updatedAtMillis,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                Value<String?> firebaseUid = const Value.absent(),
                required String publicStudentId,
                required String displayName,
                Value<String> authState = const Value.absent(),
                Value<String?> legacyUserId = const Value.absent(),
                required int createdAtMillis,
                required int updatedAtMillis,
                Value<int> rowid = const Value.absent(),
              }) => StudentProfilesCompanion.insert(
                localId: localId,
                firebaseUid: firebaseUid,
                publicStudentId: publicStudentId,
                displayName: displayName,
                authState: authState,
                legacyUserId: legacyUserId,
                createdAtMillis: createdAtMillis,
                updatedAtMillis: updatedAtMillis,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StudentProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDatabase,
      $StudentProfilesTable,
      StudentProfile,
      $$StudentProfilesTableFilterComposer,
      $$StudentProfilesTableOrderingComposer,
      $$StudentProfilesTableAnnotationComposer,
      $$StudentProfilesTableCreateCompanionBuilder,
      $$StudentProfilesTableUpdateCompanionBuilder,
      (
        StudentProfile,
        BaseReferences<
          _$ProgressDatabase,
          $StudentProfilesTable,
          StudentProfile
        >,
      ),
      StudentProfile,
      PrefetchHooks Function()
    >;
typedef $$InstallationsTableCreateCompanionBuilder =
    InstallationsCompanion Function({
      required String installationId,
      required String localProfileId,
      required String platform,
      required String appVersion,
      required int firstSeenAtMillis,
      required int lastSeenAtMillis,
      Value<int?> lastSyncAtMillis,
      Value<int> rowid,
    });
typedef $$InstallationsTableUpdateCompanionBuilder =
    InstallationsCompanion Function({
      Value<String> installationId,
      Value<String> localProfileId,
      Value<String> platform,
      Value<String> appVersion,
      Value<int> firstSeenAtMillis,
      Value<int> lastSeenAtMillis,
      Value<int?> lastSyncAtMillis,
      Value<int> rowid,
    });

class $$InstallationsTableFilterComposer
    extends Composer<_$ProgressDatabase, $InstallationsTable> {
  $$InstallationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get installationId => $composableBuilder(
    column: $table.installationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get firstSeenAtMillis => $composableBuilder(
    column: $table.firstSeenAtMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSeenAtMillis => $composableBuilder(
    column: $table.lastSeenAtMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSyncAtMillis => $composableBuilder(
    column: $table.lastSyncAtMillis,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InstallationsTableOrderingComposer
    extends Composer<_$ProgressDatabase, $InstallationsTable> {
  $$InstallationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get installationId => $composableBuilder(
    column: $table.installationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get firstSeenAtMillis => $composableBuilder(
    column: $table.firstSeenAtMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSeenAtMillis => $composableBuilder(
    column: $table.lastSeenAtMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSyncAtMillis => $composableBuilder(
    column: $table.lastSyncAtMillis,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InstallationsTableAnnotationComposer
    extends Composer<_$ProgressDatabase, $InstallationsTable> {
  $$InstallationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get installationId => $composableBuilder(
    column: $table.installationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get firstSeenAtMillis => $composableBuilder(
    column: $table.firstSeenAtMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastSeenAtMillis => $composableBuilder(
    column: $table.lastSeenAtMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastSyncAtMillis => $composableBuilder(
    column: $table.lastSyncAtMillis,
    builder: (column) => column,
  );
}

class $$InstallationsTableTableManager
    extends
        RootTableManager<
          _$ProgressDatabase,
          $InstallationsTable,
          Installation,
          $$InstallationsTableFilterComposer,
          $$InstallationsTableOrderingComposer,
          $$InstallationsTableAnnotationComposer,
          $$InstallationsTableCreateCompanionBuilder,
          $$InstallationsTableUpdateCompanionBuilder,
          (
            Installation,
            BaseReferences<
              _$ProgressDatabase,
              $InstallationsTable,
              Installation
            >,
          ),
          Installation,
          PrefetchHooks Function()
        > {
  $$InstallationsTableTableManager(
    _$ProgressDatabase db,
    $InstallationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InstallationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InstallationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InstallationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> installationId = const Value.absent(),
                Value<String> localProfileId = const Value.absent(),
                Value<String> platform = const Value.absent(),
                Value<String> appVersion = const Value.absent(),
                Value<int> firstSeenAtMillis = const Value.absent(),
                Value<int> lastSeenAtMillis = const Value.absent(),
                Value<int?> lastSyncAtMillis = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InstallationsCompanion(
                installationId: installationId,
                localProfileId: localProfileId,
                platform: platform,
                appVersion: appVersion,
                firstSeenAtMillis: firstSeenAtMillis,
                lastSeenAtMillis: lastSeenAtMillis,
                lastSyncAtMillis: lastSyncAtMillis,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String installationId,
                required String localProfileId,
                required String platform,
                required String appVersion,
                required int firstSeenAtMillis,
                required int lastSeenAtMillis,
                Value<int?> lastSyncAtMillis = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InstallationsCompanion.insert(
                installationId: installationId,
                localProfileId: localProfileId,
                platform: platform,
                appVersion: appVersion,
                firstSeenAtMillis: firstSeenAtMillis,
                lastSeenAtMillis: lastSeenAtMillis,
                lastSyncAtMillis: lastSyncAtMillis,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InstallationsTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDatabase,
      $InstallationsTable,
      Installation,
      $$InstallationsTableFilterComposer,
      $$InstallationsTableOrderingComposer,
      $$InstallationsTableAnnotationComposer,
      $$InstallationsTableCreateCompanionBuilder,
      $$InstallationsTableUpdateCompanionBuilder,
      (
        Installation,
        BaseReferences<_$ProgressDatabase, $InstallationsTable, Installation>,
      ),
      Installation,
      PrefetchHooks Function()
    >;
typedef $$LessonProgressRowsTableCreateCompanionBuilder =
    LessonProgressRowsCompanion Function({
      required String localProfileId,
      required String lessonId,
      Value<String> status,
      required int startedAtMillis,
      Value<int?> completedAtMillis,
      Value<int> totalTimeSpentSeconds,
      Value<int> visitCount,
      required int updatedAtMillis,
      Value<int> rowid,
    });
typedef $$LessonProgressRowsTableUpdateCompanionBuilder =
    LessonProgressRowsCompanion Function({
      Value<String> localProfileId,
      Value<String> lessonId,
      Value<String> status,
      Value<int> startedAtMillis,
      Value<int?> completedAtMillis,
      Value<int> totalTimeSpentSeconds,
      Value<int> visitCount,
      Value<int> updatedAtMillis,
      Value<int> rowid,
    });

class $$LessonProgressRowsTableFilterComposer
    extends Composer<_$ProgressDatabase, $LessonProgressRowsTable> {
  $$LessonProgressRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAtMillis => $composableBuilder(
    column: $table.startedAtMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedAtMillis => $composableBuilder(
    column: $table.completedAtMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalTimeSpentSeconds => $composableBuilder(
    column: $table.totalTimeSpentSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get visitCount => $composableBuilder(
    column: $table.visitCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMillis => $composableBuilder(
    column: $table.updatedAtMillis,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LessonProgressRowsTableOrderingComposer
    extends Composer<_$ProgressDatabase, $LessonProgressRowsTable> {
  $$LessonProgressRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAtMillis => $composableBuilder(
    column: $table.startedAtMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedAtMillis => $composableBuilder(
    column: $table.completedAtMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalTimeSpentSeconds => $composableBuilder(
    column: $table.totalTimeSpentSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get visitCount => $composableBuilder(
    column: $table.visitCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMillis => $composableBuilder(
    column: $table.updatedAtMillis,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LessonProgressRowsTableAnnotationComposer
    extends Composer<_$ProgressDatabase, $LessonProgressRowsTable> {
  $$LessonProgressRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get startedAtMillis => $composableBuilder(
    column: $table.startedAtMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedAtMillis => $composableBuilder(
    column: $table.completedAtMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalTimeSpentSeconds => $composableBuilder(
    column: $table.totalTimeSpentSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get visitCount => $composableBuilder(
    column: $table.visitCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtMillis => $composableBuilder(
    column: $table.updatedAtMillis,
    builder: (column) => column,
  );
}

class $$LessonProgressRowsTableTableManager
    extends
        RootTableManager<
          _$ProgressDatabase,
          $LessonProgressRowsTable,
          LessonProgressRow,
          $$LessonProgressRowsTableFilterComposer,
          $$LessonProgressRowsTableOrderingComposer,
          $$LessonProgressRowsTableAnnotationComposer,
          $$LessonProgressRowsTableCreateCompanionBuilder,
          $$LessonProgressRowsTableUpdateCompanionBuilder,
          (
            LessonProgressRow,
            BaseReferences<
              _$ProgressDatabase,
              $LessonProgressRowsTable,
              LessonProgressRow
            >,
          ),
          LessonProgressRow,
          PrefetchHooks Function()
        > {
  $$LessonProgressRowsTableTableManager(
    _$ProgressDatabase db,
    $LessonProgressRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonProgressRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonProgressRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonProgressRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> localProfileId = const Value.absent(),
                Value<String> lessonId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> startedAtMillis = const Value.absent(),
                Value<int?> completedAtMillis = const Value.absent(),
                Value<int> totalTimeSpentSeconds = const Value.absent(),
                Value<int> visitCount = const Value.absent(),
                Value<int> updatedAtMillis = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonProgressRowsCompanion(
                localProfileId: localProfileId,
                lessonId: lessonId,
                status: status,
                startedAtMillis: startedAtMillis,
                completedAtMillis: completedAtMillis,
                totalTimeSpentSeconds: totalTimeSpentSeconds,
                visitCount: visitCount,
                updatedAtMillis: updatedAtMillis,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localProfileId,
                required String lessonId,
                Value<String> status = const Value.absent(),
                required int startedAtMillis,
                Value<int?> completedAtMillis = const Value.absent(),
                Value<int> totalTimeSpentSeconds = const Value.absent(),
                Value<int> visitCount = const Value.absent(),
                required int updatedAtMillis,
                Value<int> rowid = const Value.absent(),
              }) => LessonProgressRowsCompanion.insert(
                localProfileId: localProfileId,
                lessonId: lessonId,
                status: status,
                startedAtMillis: startedAtMillis,
                completedAtMillis: completedAtMillis,
                totalTimeSpentSeconds: totalTimeSpentSeconds,
                visitCount: visitCount,
                updatedAtMillis: updatedAtMillis,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LessonProgressRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDatabase,
      $LessonProgressRowsTable,
      LessonProgressRow,
      $$LessonProgressRowsTableFilterComposer,
      $$LessonProgressRowsTableOrderingComposer,
      $$LessonProgressRowsTableAnnotationComposer,
      $$LessonProgressRowsTableCreateCompanionBuilder,
      $$LessonProgressRowsTableUpdateCompanionBuilder,
      (
        LessonProgressRow,
        BaseReferences<
          _$ProgressDatabase,
          $LessonProgressRowsTable,
          LessonProgressRow
        >,
      ),
      LessonProgressRow,
      PrefetchHooks Function()
    >;
typedef $$QuizAttemptsTableCreateCompanionBuilder =
    QuizAttemptsCompanion Function({
      required String attemptId,
      required String localProfileId,
      required String quizId,
      required String quizLevel,
      Value<String> status,
      required int startedAtMillis,
      Value<int?> completedAtMillis,
      Value<int> normalQuestionsTotal,
      Value<int> bonusQuestionsTotal,
      Value<int> correctAnswers,
      Value<int> wrongAnswers,
      Value<int> bonusCorrect,
      Value<int> totalScore,
      Value<int> durationSeconds,
      Value<int> rowid,
    });
typedef $$QuizAttemptsTableUpdateCompanionBuilder =
    QuizAttemptsCompanion Function({
      Value<String> attemptId,
      Value<String> localProfileId,
      Value<String> quizId,
      Value<String> quizLevel,
      Value<String> status,
      Value<int> startedAtMillis,
      Value<int?> completedAtMillis,
      Value<int> normalQuestionsTotal,
      Value<int> bonusQuestionsTotal,
      Value<int> correctAnswers,
      Value<int> wrongAnswers,
      Value<int> bonusCorrect,
      Value<int> totalScore,
      Value<int> durationSeconds,
      Value<int> rowid,
    });

class $$QuizAttemptsTableFilterComposer
    extends Composer<_$ProgressDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get attemptId => $composableBuilder(
    column: $table.attemptId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quizId => $composableBuilder(
    column: $table.quizId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quizLevel => $composableBuilder(
    column: $table.quizLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAtMillis => $composableBuilder(
    column: $table.startedAtMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedAtMillis => $composableBuilder(
    column: $table.completedAtMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get normalQuestionsTotal => $composableBuilder(
    column: $table.normalQuestionsTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bonusQuestionsTotal => $composableBuilder(
    column: $table.bonusQuestionsTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctAnswers => $composableBuilder(
    column: $table.correctAnswers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wrongAnswers => $composableBuilder(
    column: $table.wrongAnswers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bonusCorrect => $composableBuilder(
    column: $table.bonusCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuizAttemptsTableOrderingComposer
    extends Composer<_$ProgressDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get attemptId => $composableBuilder(
    column: $table.attemptId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quizId => $composableBuilder(
    column: $table.quizId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quizLevel => $composableBuilder(
    column: $table.quizLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAtMillis => $composableBuilder(
    column: $table.startedAtMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedAtMillis => $composableBuilder(
    column: $table.completedAtMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get normalQuestionsTotal => $composableBuilder(
    column: $table.normalQuestionsTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bonusQuestionsTotal => $composableBuilder(
    column: $table.bonusQuestionsTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctAnswers => $composableBuilder(
    column: $table.correctAnswers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wrongAnswers => $composableBuilder(
    column: $table.wrongAnswers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bonusCorrect => $composableBuilder(
    column: $table.bonusCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuizAttemptsTableAnnotationComposer
    extends Composer<_$ProgressDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get attemptId =>
      $composableBuilder(column: $table.attemptId, builder: (column) => column);

  GeneratedColumn<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get quizId =>
      $composableBuilder(column: $table.quizId, builder: (column) => column);

  GeneratedColumn<String> get quizLevel =>
      $composableBuilder(column: $table.quizLevel, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get startedAtMillis => $composableBuilder(
    column: $table.startedAtMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedAtMillis => $composableBuilder(
    column: $table.completedAtMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get normalQuestionsTotal => $composableBuilder(
    column: $table.normalQuestionsTotal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bonusQuestionsTotal => $composableBuilder(
    column: $table.bonusQuestionsTotal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctAnswers => $composableBuilder(
    column: $table.correctAnswers,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wrongAnswers => $composableBuilder(
    column: $table.wrongAnswers,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bonusCorrect => $composableBuilder(
    column: $table.bonusCorrect,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );
}

class $$QuizAttemptsTableTableManager
    extends
        RootTableManager<
          _$ProgressDatabase,
          $QuizAttemptsTable,
          QuizAttempt,
          $$QuizAttemptsTableFilterComposer,
          $$QuizAttemptsTableOrderingComposer,
          $$QuizAttemptsTableAnnotationComposer,
          $$QuizAttemptsTableCreateCompanionBuilder,
          $$QuizAttemptsTableUpdateCompanionBuilder,
          (
            QuizAttempt,
            BaseReferences<_$ProgressDatabase, $QuizAttemptsTable, QuizAttempt>,
          ),
          QuizAttempt,
          PrefetchHooks Function()
        > {
  $$QuizAttemptsTableTableManager(
    _$ProgressDatabase db,
    $QuizAttemptsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> attemptId = const Value.absent(),
                Value<String> localProfileId = const Value.absent(),
                Value<String> quizId = const Value.absent(),
                Value<String> quizLevel = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> startedAtMillis = const Value.absent(),
                Value<int?> completedAtMillis = const Value.absent(),
                Value<int> normalQuestionsTotal = const Value.absent(),
                Value<int> bonusQuestionsTotal = const Value.absent(),
                Value<int> correctAnswers = const Value.absent(),
                Value<int> wrongAnswers = const Value.absent(),
                Value<int> bonusCorrect = const Value.absent(),
                Value<int> totalScore = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizAttemptsCompanion(
                attemptId: attemptId,
                localProfileId: localProfileId,
                quizId: quizId,
                quizLevel: quizLevel,
                status: status,
                startedAtMillis: startedAtMillis,
                completedAtMillis: completedAtMillis,
                normalQuestionsTotal: normalQuestionsTotal,
                bonusQuestionsTotal: bonusQuestionsTotal,
                correctAnswers: correctAnswers,
                wrongAnswers: wrongAnswers,
                bonusCorrect: bonusCorrect,
                totalScore: totalScore,
                durationSeconds: durationSeconds,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String attemptId,
                required String localProfileId,
                required String quizId,
                required String quizLevel,
                Value<String> status = const Value.absent(),
                required int startedAtMillis,
                Value<int?> completedAtMillis = const Value.absent(),
                Value<int> normalQuestionsTotal = const Value.absent(),
                Value<int> bonusQuestionsTotal = const Value.absent(),
                Value<int> correctAnswers = const Value.absent(),
                Value<int> wrongAnswers = const Value.absent(),
                Value<int> bonusCorrect = const Value.absent(),
                Value<int> totalScore = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizAttemptsCompanion.insert(
                attemptId: attemptId,
                localProfileId: localProfileId,
                quizId: quizId,
                quizLevel: quizLevel,
                status: status,
                startedAtMillis: startedAtMillis,
                completedAtMillis: completedAtMillis,
                normalQuestionsTotal: normalQuestionsTotal,
                bonusQuestionsTotal: bonusQuestionsTotal,
                correctAnswers: correctAnswers,
                wrongAnswers: wrongAnswers,
                bonusCorrect: bonusCorrect,
                totalScore: totalScore,
                durationSeconds: durationSeconds,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuizAttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDatabase,
      $QuizAttemptsTable,
      QuizAttempt,
      $$QuizAttemptsTableFilterComposer,
      $$QuizAttemptsTableOrderingComposer,
      $$QuizAttemptsTableAnnotationComposer,
      $$QuizAttemptsTableCreateCompanionBuilder,
      $$QuizAttemptsTableUpdateCompanionBuilder,
      (
        QuizAttempt,
        BaseReferences<_$ProgressDatabase, $QuizAttemptsTable, QuizAttempt>,
      ),
      QuizAttempt,
      PrefetchHooks Function()
    >;
typedef $$QuizAnswersTableCreateCompanionBuilder =
    QuizAnswersCompanion Function({
      required String answerId,
      required String attemptId,
      required String questionId,
      required String selectedAnswer,
      Value<bool> isAutoGraded,
      required bool isCorrect,
      required bool isBonusQuestion,
      required int responseTimeMilliseconds,
      Value<int> attemptNumber,
      Value<bool?> hintUsed,
      required int answeredAtMillis,
      Value<int> rowid,
    });
typedef $$QuizAnswersTableUpdateCompanionBuilder =
    QuizAnswersCompanion Function({
      Value<String> answerId,
      Value<String> attemptId,
      Value<String> questionId,
      Value<String> selectedAnswer,
      Value<bool> isAutoGraded,
      Value<bool> isCorrect,
      Value<bool> isBonusQuestion,
      Value<int> responseTimeMilliseconds,
      Value<int> attemptNumber,
      Value<bool?> hintUsed,
      Value<int> answeredAtMillis,
      Value<int> rowid,
    });

class $$QuizAnswersTableFilterComposer
    extends Composer<_$ProgressDatabase, $QuizAnswersTable> {
  $$QuizAnswersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get answerId => $composableBuilder(
    column: $table.answerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attemptId => $composableBuilder(
    column: $table.attemptId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedAnswer => $composableBuilder(
    column: $table.selectedAnswer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAutoGraded => $composableBuilder(
    column: $table.isAutoGraded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBonusQuestion => $composableBuilder(
    column: $table.isBonusQuestion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get responseTimeMilliseconds => $composableBuilder(
    column: $table.responseTimeMilliseconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptNumber => $composableBuilder(
    column: $table.attemptNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hintUsed => $composableBuilder(
    column: $table.hintUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get answeredAtMillis => $composableBuilder(
    column: $table.answeredAtMillis,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuizAnswersTableOrderingComposer
    extends Composer<_$ProgressDatabase, $QuizAnswersTable> {
  $$QuizAnswersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get answerId => $composableBuilder(
    column: $table.answerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attemptId => $composableBuilder(
    column: $table.attemptId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedAnswer => $composableBuilder(
    column: $table.selectedAnswer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAutoGraded => $composableBuilder(
    column: $table.isAutoGraded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBonusQuestion => $composableBuilder(
    column: $table.isBonusQuestion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get responseTimeMilliseconds => $composableBuilder(
    column: $table.responseTimeMilliseconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptNumber => $composableBuilder(
    column: $table.attemptNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hintUsed => $composableBuilder(
    column: $table.hintUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get answeredAtMillis => $composableBuilder(
    column: $table.answeredAtMillis,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuizAnswersTableAnnotationComposer
    extends Composer<_$ProgressDatabase, $QuizAnswersTable> {
  $$QuizAnswersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get answerId =>
      $composableBuilder(column: $table.answerId, builder: (column) => column);

  GeneratedColumn<String> get attemptId =>
      $composableBuilder(column: $table.attemptId, builder: (column) => column);

  GeneratedColumn<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selectedAnswer => $composableBuilder(
    column: $table.selectedAnswer,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAutoGraded => $composableBuilder(
    column: $table.isAutoGraded,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  GeneratedColumn<bool> get isBonusQuestion => $composableBuilder(
    column: $table.isBonusQuestion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get responseTimeMilliseconds => $composableBuilder(
    column: $table.responseTimeMilliseconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attemptNumber => $composableBuilder(
    column: $table.attemptNumber,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hintUsed =>
      $composableBuilder(column: $table.hintUsed, builder: (column) => column);

  GeneratedColumn<int> get answeredAtMillis => $composableBuilder(
    column: $table.answeredAtMillis,
    builder: (column) => column,
  );
}

class $$QuizAnswersTableTableManager
    extends
        RootTableManager<
          _$ProgressDatabase,
          $QuizAnswersTable,
          QuizAnswer,
          $$QuizAnswersTableFilterComposer,
          $$QuizAnswersTableOrderingComposer,
          $$QuizAnswersTableAnnotationComposer,
          $$QuizAnswersTableCreateCompanionBuilder,
          $$QuizAnswersTableUpdateCompanionBuilder,
          (
            QuizAnswer,
            BaseReferences<_$ProgressDatabase, $QuizAnswersTable, QuizAnswer>,
          ),
          QuizAnswer,
          PrefetchHooks Function()
        > {
  $$QuizAnswersTableTableManager(_$ProgressDatabase db, $QuizAnswersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizAnswersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizAnswersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizAnswersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> answerId = const Value.absent(),
                Value<String> attemptId = const Value.absent(),
                Value<String> questionId = const Value.absent(),
                Value<String> selectedAnswer = const Value.absent(),
                Value<bool> isAutoGraded = const Value.absent(),
                Value<bool> isCorrect = const Value.absent(),
                Value<bool> isBonusQuestion = const Value.absent(),
                Value<int> responseTimeMilliseconds = const Value.absent(),
                Value<int> attemptNumber = const Value.absent(),
                Value<bool?> hintUsed = const Value.absent(),
                Value<int> answeredAtMillis = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizAnswersCompanion(
                answerId: answerId,
                attemptId: attemptId,
                questionId: questionId,
                selectedAnswer: selectedAnswer,
                isAutoGraded: isAutoGraded,
                isCorrect: isCorrect,
                isBonusQuestion: isBonusQuestion,
                responseTimeMilliseconds: responseTimeMilliseconds,
                attemptNumber: attemptNumber,
                hintUsed: hintUsed,
                answeredAtMillis: answeredAtMillis,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String answerId,
                required String attemptId,
                required String questionId,
                required String selectedAnswer,
                Value<bool> isAutoGraded = const Value.absent(),
                required bool isCorrect,
                required bool isBonusQuestion,
                required int responseTimeMilliseconds,
                Value<int> attemptNumber = const Value.absent(),
                Value<bool?> hintUsed = const Value.absent(),
                required int answeredAtMillis,
                Value<int> rowid = const Value.absent(),
              }) => QuizAnswersCompanion.insert(
                answerId: answerId,
                attemptId: attemptId,
                questionId: questionId,
                selectedAnswer: selectedAnswer,
                isAutoGraded: isAutoGraded,
                isCorrect: isCorrect,
                isBonusQuestion: isBonusQuestion,
                responseTimeMilliseconds: responseTimeMilliseconds,
                attemptNumber: attemptNumber,
                hintUsed: hintUsed,
                answeredAtMillis: answeredAtMillis,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuizAnswersTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDatabase,
      $QuizAnswersTable,
      QuizAnswer,
      $$QuizAnswersTableFilterComposer,
      $$QuizAnswersTableOrderingComposer,
      $$QuizAnswersTableAnnotationComposer,
      $$QuizAnswersTableCreateCompanionBuilder,
      $$QuizAnswersTableUpdateCompanionBuilder,
      (
        QuizAnswer,
        BaseReferences<_$ProgressDatabase, $QuizAnswersTable, QuizAnswer>,
      ),
      QuizAnswer,
      PrefetchHooks Function()
    >;
typedef $$GameSessionsTableCreateCompanionBuilder =
    GameSessionsCompanion Function({
      required String gameSessionId,
      required String localProfileId,
      required String gameType,
      required String gameId,
      Value<String> status,
      required int startedAtMillis,
      Value<int?> completedAtMillis,
      Value<int> durationSeconds,
      Value<int?> score,
      Value<int?> correctCount,
      Value<int?> wrongCount,
      Value<int?> attemptCount,
      Value<int> rowid,
    });
typedef $$GameSessionsTableUpdateCompanionBuilder =
    GameSessionsCompanion Function({
      Value<String> gameSessionId,
      Value<String> localProfileId,
      Value<String> gameType,
      Value<String> gameId,
      Value<String> status,
      Value<int> startedAtMillis,
      Value<int?> completedAtMillis,
      Value<int> durationSeconds,
      Value<int?> score,
      Value<int?> correctCount,
      Value<int?> wrongCount,
      Value<int?> attemptCount,
      Value<int> rowid,
    });

class $$GameSessionsTableFilterComposer
    extends Composer<_$ProgressDatabase, $GameSessionsTable> {
  $$GameSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get gameSessionId => $composableBuilder(
    column: $table.gameSessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gameType => $composableBuilder(
    column: $table.gameType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gameId => $composableBuilder(
    column: $table.gameId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAtMillis => $composableBuilder(
    column: $table.startedAtMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedAtMillis => $composableBuilder(
    column: $table.completedAtMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wrongCount => $composableBuilder(
    column: $table.wrongCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GameSessionsTableOrderingComposer
    extends Composer<_$ProgressDatabase, $GameSessionsTable> {
  $$GameSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get gameSessionId => $composableBuilder(
    column: $table.gameSessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gameType => $composableBuilder(
    column: $table.gameType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gameId => $composableBuilder(
    column: $table.gameId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAtMillis => $composableBuilder(
    column: $table.startedAtMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedAtMillis => $composableBuilder(
    column: $table.completedAtMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wrongCount => $composableBuilder(
    column: $table.wrongCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GameSessionsTableAnnotationComposer
    extends Composer<_$ProgressDatabase, $GameSessionsTable> {
  $$GameSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get gameSessionId => $composableBuilder(
    column: $table.gameSessionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gameType =>
      $composableBuilder(column: $table.gameType, builder: (column) => column);

  GeneratedColumn<String> get gameId =>
      $composableBuilder(column: $table.gameId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get startedAtMillis => $composableBuilder(
    column: $table.startedAtMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedAtMillis => $composableBuilder(
    column: $table.completedAtMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wrongCount => $composableBuilder(
    column: $table.wrongCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );
}

class $$GameSessionsTableTableManager
    extends
        RootTableManager<
          _$ProgressDatabase,
          $GameSessionsTable,
          GameSession,
          $$GameSessionsTableFilterComposer,
          $$GameSessionsTableOrderingComposer,
          $$GameSessionsTableAnnotationComposer,
          $$GameSessionsTableCreateCompanionBuilder,
          $$GameSessionsTableUpdateCompanionBuilder,
          (
            GameSession,
            BaseReferences<_$ProgressDatabase, $GameSessionsTable, GameSession>,
          ),
          GameSession,
          PrefetchHooks Function()
        > {
  $$GameSessionsTableTableManager(
    _$ProgressDatabase db,
    $GameSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> gameSessionId = const Value.absent(),
                Value<String> localProfileId = const Value.absent(),
                Value<String> gameType = const Value.absent(),
                Value<String> gameId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> startedAtMillis = const Value.absent(),
                Value<int?> completedAtMillis = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<int?> score = const Value.absent(),
                Value<int?> correctCount = const Value.absent(),
                Value<int?> wrongCount = const Value.absent(),
                Value<int?> attemptCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GameSessionsCompanion(
                gameSessionId: gameSessionId,
                localProfileId: localProfileId,
                gameType: gameType,
                gameId: gameId,
                status: status,
                startedAtMillis: startedAtMillis,
                completedAtMillis: completedAtMillis,
                durationSeconds: durationSeconds,
                score: score,
                correctCount: correctCount,
                wrongCount: wrongCount,
                attemptCount: attemptCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String gameSessionId,
                required String localProfileId,
                required String gameType,
                required String gameId,
                Value<String> status = const Value.absent(),
                required int startedAtMillis,
                Value<int?> completedAtMillis = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<int?> score = const Value.absent(),
                Value<int?> correctCount = const Value.absent(),
                Value<int?> wrongCount = const Value.absent(),
                Value<int?> attemptCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GameSessionsCompanion.insert(
                gameSessionId: gameSessionId,
                localProfileId: localProfileId,
                gameType: gameType,
                gameId: gameId,
                status: status,
                startedAtMillis: startedAtMillis,
                completedAtMillis: completedAtMillis,
                durationSeconds: durationSeconds,
                score: score,
                correctCount: correctCount,
                wrongCount: wrongCount,
                attemptCount: attemptCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GameSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDatabase,
      $GameSessionsTable,
      GameSession,
      $$GameSessionsTableFilterComposer,
      $$GameSessionsTableOrderingComposer,
      $$GameSessionsTableAnnotationComposer,
      $$GameSessionsTableCreateCompanionBuilder,
      $$GameSessionsTableUpdateCompanionBuilder,
      (
        GameSession,
        BaseReferences<_$ProgressDatabase, $GameSessionsTable, GameSession>,
      ),
      GameSession,
      PrefetchHooks Function()
    >;
typedef $$LearningSessionsTableCreateCompanionBuilder =
    LearningSessionsCompanion Function({
      required String sessionId,
      required String localProfileId,
      required int startedAtMillis,
      Value<int?> endedAtMillis,
      Value<int> activeLearningSeconds,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$LearningSessionsTableUpdateCompanionBuilder =
    LearningSessionsCompanion Function({
      Value<String> sessionId,
      Value<String> localProfileId,
      Value<int> startedAtMillis,
      Value<int?> endedAtMillis,
      Value<int> activeLearningSeconds,
      Value<String> status,
      Value<int> rowid,
    });

class $$LearningSessionsTableFilterComposer
    extends Composer<_$ProgressDatabase, $LearningSessionsTable> {
  $$LearningSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAtMillis => $composableBuilder(
    column: $table.startedAtMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endedAtMillis => $composableBuilder(
    column: $table.endedAtMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activeLearningSeconds => $composableBuilder(
    column: $table.activeLearningSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LearningSessionsTableOrderingComposer
    extends Composer<_$ProgressDatabase, $LearningSessionsTable> {
  $$LearningSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAtMillis => $composableBuilder(
    column: $table.startedAtMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endedAtMillis => $composableBuilder(
    column: $table.endedAtMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activeLearningSeconds => $composableBuilder(
    column: $table.activeLearningSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LearningSessionsTableAnnotationComposer
    extends Composer<_$ProgressDatabase, $LearningSessionsTable> {
  $$LearningSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startedAtMillis => $composableBuilder(
    column: $table.startedAtMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endedAtMillis => $composableBuilder(
    column: $table.endedAtMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get activeLearningSeconds => $composableBuilder(
    column: $table.activeLearningSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$LearningSessionsTableTableManager
    extends
        RootTableManager<
          _$ProgressDatabase,
          $LearningSessionsTable,
          LearningSession,
          $$LearningSessionsTableFilterComposer,
          $$LearningSessionsTableOrderingComposer,
          $$LearningSessionsTableAnnotationComposer,
          $$LearningSessionsTableCreateCompanionBuilder,
          $$LearningSessionsTableUpdateCompanionBuilder,
          (
            LearningSession,
            BaseReferences<
              _$ProgressDatabase,
              $LearningSessionsTable,
              LearningSession
            >,
          ),
          LearningSession,
          PrefetchHooks Function()
        > {
  $$LearningSessionsTableTableManager(
    _$ProgressDatabase db,
    $LearningSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LearningSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LearningSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LearningSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> sessionId = const Value.absent(),
                Value<String> localProfileId = const Value.absent(),
                Value<int> startedAtMillis = const Value.absent(),
                Value<int?> endedAtMillis = const Value.absent(),
                Value<int> activeLearningSeconds = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LearningSessionsCompanion(
                sessionId: sessionId,
                localProfileId: localProfileId,
                startedAtMillis: startedAtMillis,
                endedAtMillis: endedAtMillis,
                activeLearningSeconds: activeLearningSeconds,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionId,
                required String localProfileId,
                required int startedAtMillis,
                Value<int?> endedAtMillis = const Value.absent(),
                Value<int> activeLearningSeconds = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LearningSessionsCompanion.insert(
                sessionId: sessionId,
                localProfileId: localProfileId,
                startedAtMillis: startedAtMillis,
                endedAtMillis: endedAtMillis,
                activeLearningSeconds: activeLearningSeconds,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LearningSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDatabase,
      $LearningSessionsTable,
      LearningSession,
      $$LearningSessionsTableFilterComposer,
      $$LearningSessionsTableOrderingComposer,
      $$LearningSessionsTableAnnotationComposer,
      $$LearningSessionsTableCreateCompanionBuilder,
      $$LearningSessionsTableUpdateCompanionBuilder,
      (
        LearningSession,
        BaseReferences<
          _$ProgressDatabase,
          $LearningSessionsTable,
          LearningSession
        >,
      ),
      LearningSession,
      PrefetchHooks Function()
    >;
typedef $$LearningEventsTableCreateCompanionBuilder =
    LearningEventsCompanion Function({
      required String eventId,
      required String localProfileId,
      Value<String?> firebaseUid,
      required String installationId,
      required String eventType,
      required String entityType,
      required String entityId,
      required int timestampMillis,
      required String payloadJson,
      Value<String> syncStatus,
      required int createdAtMillis,
      Value<int?> syncedAtMillis,
      Value<int> rowid,
    });
typedef $$LearningEventsTableUpdateCompanionBuilder =
    LearningEventsCompanion Function({
      Value<String> eventId,
      Value<String> localProfileId,
      Value<String?> firebaseUid,
      Value<String> installationId,
      Value<String> eventType,
      Value<String> entityType,
      Value<String> entityId,
      Value<int> timestampMillis,
      Value<String> payloadJson,
      Value<String> syncStatus,
      Value<int> createdAtMillis,
      Value<int?> syncedAtMillis,
      Value<int> rowid,
    });

class $$LearningEventsTableFilterComposer
    extends Composer<_$ProgressDatabase, $LearningEventsTable> {
  $$LearningEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firebaseUid => $composableBuilder(
    column: $table.firebaseUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get installationId => $composableBuilder(
    column: $table.installationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timestampMillis => $composableBuilder(
    column: $table.timestampMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMillis => $composableBuilder(
    column: $table.createdAtMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncedAtMillis => $composableBuilder(
    column: $table.syncedAtMillis,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LearningEventsTableOrderingComposer
    extends Composer<_$ProgressDatabase, $LearningEventsTable> {
  $$LearningEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firebaseUid => $composableBuilder(
    column: $table.firebaseUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get installationId => $composableBuilder(
    column: $table.installationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timestampMillis => $composableBuilder(
    column: $table.timestampMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMillis => $composableBuilder(
    column: $table.createdAtMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncedAtMillis => $composableBuilder(
    column: $table.syncedAtMillis,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LearningEventsTableAnnotationComposer
    extends Composer<_$ProgressDatabase, $LearningEventsTable> {
  $$LearningEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get firebaseUid => $composableBuilder(
    column: $table.firebaseUid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get installationId => $composableBuilder(
    column: $table.installationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<int> get timestampMillis => $composableBuilder(
    column: $table.timestampMillis,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtMillis => $composableBuilder(
    column: $table.createdAtMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncedAtMillis => $composableBuilder(
    column: $table.syncedAtMillis,
    builder: (column) => column,
  );
}

class $$LearningEventsTableTableManager
    extends
        RootTableManager<
          _$ProgressDatabase,
          $LearningEventsTable,
          LearningEvent,
          $$LearningEventsTableFilterComposer,
          $$LearningEventsTableOrderingComposer,
          $$LearningEventsTableAnnotationComposer,
          $$LearningEventsTableCreateCompanionBuilder,
          $$LearningEventsTableUpdateCompanionBuilder,
          (
            LearningEvent,
            BaseReferences<
              _$ProgressDatabase,
              $LearningEventsTable,
              LearningEvent
            >,
          ),
          LearningEvent,
          PrefetchHooks Function()
        > {
  $$LearningEventsTableTableManager(
    _$ProgressDatabase db,
    $LearningEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LearningEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LearningEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LearningEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> eventId = const Value.absent(),
                Value<String> localProfileId = const Value.absent(),
                Value<String?> firebaseUid = const Value.absent(),
                Value<String> installationId = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<int> timestampMillis = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> createdAtMillis = const Value.absent(),
                Value<int?> syncedAtMillis = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LearningEventsCompanion(
                eventId: eventId,
                localProfileId: localProfileId,
                firebaseUid: firebaseUid,
                installationId: installationId,
                eventType: eventType,
                entityType: entityType,
                entityId: entityId,
                timestampMillis: timestampMillis,
                payloadJson: payloadJson,
                syncStatus: syncStatus,
                createdAtMillis: createdAtMillis,
                syncedAtMillis: syncedAtMillis,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String eventId,
                required String localProfileId,
                Value<String?> firebaseUid = const Value.absent(),
                required String installationId,
                required String eventType,
                required String entityType,
                required String entityId,
                required int timestampMillis,
                required String payloadJson,
                Value<String> syncStatus = const Value.absent(),
                required int createdAtMillis,
                Value<int?> syncedAtMillis = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LearningEventsCompanion.insert(
                eventId: eventId,
                localProfileId: localProfileId,
                firebaseUid: firebaseUid,
                installationId: installationId,
                eventType: eventType,
                entityType: entityType,
                entityId: entityId,
                timestampMillis: timestampMillis,
                payloadJson: payloadJson,
                syncStatus: syncStatus,
                createdAtMillis: createdAtMillis,
                syncedAtMillis: syncedAtMillis,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LearningEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDatabase,
      $LearningEventsTable,
      LearningEvent,
      $$LearningEventsTableFilterComposer,
      $$LearningEventsTableOrderingComposer,
      $$LearningEventsTableAnnotationComposer,
      $$LearningEventsTableCreateCompanionBuilder,
      $$LearningEventsTableUpdateCompanionBuilder,
      (
        LearningEvent,
        BaseReferences<_$ProgressDatabase, $LearningEventsTable, LearningEvent>,
      ),
      LearningEvent,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueItemsTableCreateCompanionBuilder =
    SyncQueueItemsCompanion Function({
      required String queueId,
      required String localProfileId,
      required String documentPath,
      required String documentId,
      required String payloadJson,
      Value<int> payloadVersion,
      Value<String> status,
      Value<int> attemptCount,
      Value<int?> nextAttemptAtMillis,
      Value<String?> lastError,
      required int createdAtMillis,
      required int updatedAtMillis,
      Value<int> rowid,
    });
typedef $$SyncQueueItemsTableUpdateCompanionBuilder =
    SyncQueueItemsCompanion Function({
      Value<String> queueId,
      Value<String> localProfileId,
      Value<String> documentPath,
      Value<String> documentId,
      Value<String> payloadJson,
      Value<int> payloadVersion,
      Value<String> status,
      Value<int> attemptCount,
      Value<int?> nextAttemptAtMillis,
      Value<String?> lastError,
      Value<int> createdAtMillis,
      Value<int> updatedAtMillis,
      Value<int> rowid,
    });

class $$SyncQueueItemsTableFilterComposer
    extends Composer<_$ProgressDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get queueId => $composableBuilder(
    column: $table.queueId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get documentPath => $composableBuilder(
    column: $table.documentPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextAttemptAtMillis => $composableBuilder(
    column: $table.nextAttemptAtMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMillis => $composableBuilder(
    column: $table.createdAtMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMillis => $composableBuilder(
    column: $table.updatedAtMillis,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueItemsTableOrderingComposer
    extends Composer<_$ProgressDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get queueId => $composableBuilder(
    column: $table.queueId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get documentPath => $composableBuilder(
    column: $table.documentPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextAttemptAtMillis => $composableBuilder(
    column: $table.nextAttemptAtMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMillis => $composableBuilder(
    column: $table.createdAtMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMillis => $composableBuilder(
    column: $table.updatedAtMillis,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueItemsTableAnnotationComposer
    extends Composer<_$ProgressDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get queueId =>
      $composableBuilder(column: $table.queueId, builder: (column) => column);

  GeneratedColumn<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get documentPath => $composableBuilder(
    column: $table.documentPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nextAttemptAtMillis => $composableBuilder(
    column: $table.nextAttemptAtMillis,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<int> get createdAtMillis => $composableBuilder(
    column: $table.createdAtMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtMillis => $composableBuilder(
    column: $table.updatedAtMillis,
    builder: (column) => column,
  );
}

class $$SyncQueueItemsTableTableManager
    extends
        RootTableManager<
          _$ProgressDatabase,
          $SyncQueueItemsTable,
          SyncQueueItem,
          $$SyncQueueItemsTableFilterComposer,
          $$SyncQueueItemsTableOrderingComposer,
          $$SyncQueueItemsTableAnnotationComposer,
          $$SyncQueueItemsTableCreateCompanionBuilder,
          $$SyncQueueItemsTableUpdateCompanionBuilder,
          (
            SyncQueueItem,
            BaseReferences<
              _$ProgressDatabase,
              $SyncQueueItemsTable,
              SyncQueueItem
            >,
          ),
          SyncQueueItem,
          PrefetchHooks Function()
        > {
  $$SyncQueueItemsTableTableManager(
    _$ProgressDatabase db,
    $SyncQueueItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> queueId = const Value.absent(),
                Value<String> localProfileId = const Value.absent(),
                Value<String> documentPath = const Value.absent(),
                Value<String> documentId = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> payloadVersion = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<int?> nextAttemptAtMillis = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> createdAtMillis = const Value.absent(),
                Value<int> updatedAtMillis = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueItemsCompanion(
                queueId: queueId,
                localProfileId: localProfileId,
                documentPath: documentPath,
                documentId: documentId,
                payloadJson: payloadJson,
                payloadVersion: payloadVersion,
                status: status,
                attemptCount: attemptCount,
                nextAttemptAtMillis: nextAttemptAtMillis,
                lastError: lastError,
                createdAtMillis: createdAtMillis,
                updatedAtMillis: updatedAtMillis,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String queueId,
                required String localProfileId,
                required String documentPath,
                required String documentId,
                required String payloadJson,
                Value<int> payloadVersion = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<int?> nextAttemptAtMillis = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required int createdAtMillis,
                required int updatedAtMillis,
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueItemsCompanion.insert(
                queueId: queueId,
                localProfileId: localProfileId,
                documentPath: documentPath,
                documentId: documentId,
                payloadJson: payloadJson,
                payloadVersion: payloadVersion,
                status: status,
                attemptCount: attemptCount,
                nextAttemptAtMillis: nextAttemptAtMillis,
                lastError: lastError,
                createdAtMillis: createdAtMillis,
                updatedAtMillis: updatedAtMillis,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDatabase,
      $SyncQueueItemsTable,
      SyncQueueItem,
      $$SyncQueueItemsTableFilterComposer,
      $$SyncQueueItemsTableOrderingComposer,
      $$SyncQueueItemsTableAnnotationComposer,
      $$SyncQueueItemsTableCreateCompanionBuilder,
      $$SyncQueueItemsTableUpdateCompanionBuilder,
      (
        SyncQueueItem,
        BaseReferences<_$ProgressDatabase, $SyncQueueItemsTable, SyncQueueItem>,
      ),
      SyncQueueItem,
      PrefetchHooks Function()
    >;
typedef $$SyncMetadataRowsTableCreateCompanionBuilder =
    SyncMetadataRowsCompanion Function({
      required String localProfileId,
      Value<int?> lastSyncAtMillis,
      Value<String?> lastResult,
      Value<int> rowid,
    });
typedef $$SyncMetadataRowsTableUpdateCompanionBuilder =
    SyncMetadataRowsCompanion Function({
      Value<String> localProfileId,
      Value<int?> lastSyncAtMillis,
      Value<String?> lastResult,
      Value<int> rowid,
    });

class $$SyncMetadataRowsTableFilterComposer
    extends Composer<_$ProgressDatabase, $SyncMetadataRowsTable> {
  $$SyncMetadataRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSyncAtMillis => $composableBuilder(
    column: $table.lastSyncAtMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastResult => $composableBuilder(
    column: $table.lastResult,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetadataRowsTableOrderingComposer
    extends Composer<_$ProgressDatabase, $SyncMetadataRowsTable> {
  $$SyncMetadataRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSyncAtMillis => $composableBuilder(
    column: $table.lastSyncAtMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastResult => $composableBuilder(
    column: $table.lastResult,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetadataRowsTableAnnotationComposer
    extends Composer<_$ProgressDatabase, $SyncMetadataRowsTable> {
  $$SyncMetadataRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastSyncAtMillis => $composableBuilder(
    column: $table.lastSyncAtMillis,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastResult => $composableBuilder(
    column: $table.lastResult,
    builder: (column) => column,
  );
}

class $$SyncMetadataRowsTableTableManager
    extends
        RootTableManager<
          _$ProgressDatabase,
          $SyncMetadataRowsTable,
          SyncMetadataRow,
          $$SyncMetadataRowsTableFilterComposer,
          $$SyncMetadataRowsTableOrderingComposer,
          $$SyncMetadataRowsTableAnnotationComposer,
          $$SyncMetadataRowsTableCreateCompanionBuilder,
          $$SyncMetadataRowsTableUpdateCompanionBuilder,
          (
            SyncMetadataRow,
            BaseReferences<
              _$ProgressDatabase,
              $SyncMetadataRowsTable,
              SyncMetadataRow
            >,
          ),
          SyncMetadataRow,
          PrefetchHooks Function()
        > {
  $$SyncMetadataRowsTableTableManager(
    _$ProgressDatabase db,
    $SyncMetadataRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetadataRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetadataRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetadataRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localProfileId = const Value.absent(),
                Value<int?> lastSyncAtMillis = const Value.absent(),
                Value<String?> lastResult = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataRowsCompanion(
                localProfileId: localProfileId,
                lastSyncAtMillis: lastSyncAtMillis,
                lastResult: lastResult,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localProfileId,
                Value<int?> lastSyncAtMillis = const Value.absent(),
                Value<String?> lastResult = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataRowsCompanion.insert(
                localProfileId: localProfileId,
                lastSyncAtMillis: lastSyncAtMillis,
                lastResult: lastResult,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetadataRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDatabase,
      $SyncMetadataRowsTable,
      SyncMetadataRow,
      $$SyncMetadataRowsTableFilterComposer,
      $$SyncMetadataRowsTableOrderingComposer,
      $$SyncMetadataRowsTableAnnotationComposer,
      $$SyncMetadataRowsTableCreateCompanionBuilder,
      $$SyncMetadataRowsTableUpdateCompanionBuilder,
      (
        SyncMetadataRow,
        BaseReferences<
          _$ProgressDatabase,
          $SyncMetadataRowsTable,
          SyncMetadataRow
        >,
      ),
      SyncMetadataRow,
      PrefetchHooks Function()
    >;
typedef $$LegacyProgressBaselinesTableCreateCompanionBuilder =
    LegacyProgressBaselinesCompanion Function({
      required String localProfileId,
      Value<int> onboardingReached,
      Value<int> belajarReached,
      Value<int> learningReached,
      Value<int> quizAnswered,
      Value<int> quizAutoCorrect,
      Value<int> quizAutoTotal,
      Value<int> quizSessionsCompleted,
      Value<int> gameStarsEarned,
      Value<int> gameStarsPossible,
      Value<int> gameSessionsCompleted,
      required int migratedAtMillis,
      Value<int> rowid,
    });
typedef $$LegacyProgressBaselinesTableUpdateCompanionBuilder =
    LegacyProgressBaselinesCompanion Function({
      Value<String> localProfileId,
      Value<int> onboardingReached,
      Value<int> belajarReached,
      Value<int> learningReached,
      Value<int> quizAnswered,
      Value<int> quizAutoCorrect,
      Value<int> quizAutoTotal,
      Value<int> quizSessionsCompleted,
      Value<int> gameStarsEarned,
      Value<int> gameStarsPossible,
      Value<int> gameSessionsCompleted,
      Value<int> migratedAtMillis,
      Value<int> rowid,
    });

class $$LegacyProgressBaselinesTableFilterComposer
    extends Composer<_$ProgressDatabase, $LegacyProgressBaselinesTable> {
  $$LegacyProgressBaselinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get onboardingReached => $composableBuilder(
    column: $table.onboardingReached,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get belajarReached => $composableBuilder(
    column: $table.belajarReached,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get learningReached => $composableBuilder(
    column: $table.learningReached,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quizAnswered => $composableBuilder(
    column: $table.quizAnswered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quizAutoCorrect => $composableBuilder(
    column: $table.quizAutoCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quizAutoTotal => $composableBuilder(
    column: $table.quizAutoTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quizSessionsCompleted => $composableBuilder(
    column: $table.quizSessionsCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gameStarsEarned => $composableBuilder(
    column: $table.gameStarsEarned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gameStarsPossible => $composableBuilder(
    column: $table.gameStarsPossible,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gameSessionsCompleted => $composableBuilder(
    column: $table.gameSessionsCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get migratedAtMillis => $composableBuilder(
    column: $table.migratedAtMillis,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LegacyProgressBaselinesTableOrderingComposer
    extends Composer<_$ProgressDatabase, $LegacyProgressBaselinesTable> {
  $$LegacyProgressBaselinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get onboardingReached => $composableBuilder(
    column: $table.onboardingReached,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get belajarReached => $composableBuilder(
    column: $table.belajarReached,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get learningReached => $composableBuilder(
    column: $table.learningReached,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quizAnswered => $composableBuilder(
    column: $table.quizAnswered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quizAutoCorrect => $composableBuilder(
    column: $table.quizAutoCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quizAutoTotal => $composableBuilder(
    column: $table.quizAutoTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quizSessionsCompleted => $composableBuilder(
    column: $table.quizSessionsCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gameStarsEarned => $composableBuilder(
    column: $table.gameStarsEarned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gameStarsPossible => $composableBuilder(
    column: $table.gameStarsPossible,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gameSessionsCompleted => $composableBuilder(
    column: $table.gameSessionsCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get migratedAtMillis => $composableBuilder(
    column: $table.migratedAtMillis,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegacyProgressBaselinesTableAnnotationComposer
    extends Composer<_$ProgressDatabase, $LegacyProgressBaselinesTable> {
  $$LegacyProgressBaselinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localProfileId => $composableBuilder(
    column: $table.localProfileId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get onboardingReached => $composableBuilder(
    column: $table.onboardingReached,
    builder: (column) => column,
  );

  GeneratedColumn<int> get belajarReached => $composableBuilder(
    column: $table.belajarReached,
    builder: (column) => column,
  );

  GeneratedColumn<int> get learningReached => $composableBuilder(
    column: $table.learningReached,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quizAnswered => $composableBuilder(
    column: $table.quizAnswered,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quizAutoCorrect => $composableBuilder(
    column: $table.quizAutoCorrect,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quizAutoTotal => $composableBuilder(
    column: $table.quizAutoTotal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quizSessionsCompleted => $composableBuilder(
    column: $table.quizSessionsCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get gameStarsEarned => $composableBuilder(
    column: $table.gameStarsEarned,
    builder: (column) => column,
  );

  GeneratedColumn<int> get gameStarsPossible => $composableBuilder(
    column: $table.gameStarsPossible,
    builder: (column) => column,
  );

  GeneratedColumn<int> get gameSessionsCompleted => $composableBuilder(
    column: $table.gameSessionsCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get migratedAtMillis => $composableBuilder(
    column: $table.migratedAtMillis,
    builder: (column) => column,
  );
}

class $$LegacyProgressBaselinesTableTableManager
    extends
        RootTableManager<
          _$ProgressDatabase,
          $LegacyProgressBaselinesTable,
          LegacyProgressBaseline,
          $$LegacyProgressBaselinesTableFilterComposer,
          $$LegacyProgressBaselinesTableOrderingComposer,
          $$LegacyProgressBaselinesTableAnnotationComposer,
          $$LegacyProgressBaselinesTableCreateCompanionBuilder,
          $$LegacyProgressBaselinesTableUpdateCompanionBuilder,
          (
            LegacyProgressBaseline,
            BaseReferences<
              _$ProgressDatabase,
              $LegacyProgressBaselinesTable,
              LegacyProgressBaseline
            >,
          ),
          LegacyProgressBaseline,
          PrefetchHooks Function()
        > {
  $$LegacyProgressBaselinesTableTableManager(
    _$ProgressDatabase db,
    $LegacyProgressBaselinesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyProgressBaselinesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LegacyProgressBaselinesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LegacyProgressBaselinesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> localProfileId = const Value.absent(),
                Value<int> onboardingReached = const Value.absent(),
                Value<int> belajarReached = const Value.absent(),
                Value<int> learningReached = const Value.absent(),
                Value<int> quizAnswered = const Value.absent(),
                Value<int> quizAutoCorrect = const Value.absent(),
                Value<int> quizAutoTotal = const Value.absent(),
                Value<int> quizSessionsCompleted = const Value.absent(),
                Value<int> gameStarsEarned = const Value.absent(),
                Value<int> gameStarsPossible = const Value.absent(),
                Value<int> gameSessionsCompleted = const Value.absent(),
                Value<int> migratedAtMillis = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyProgressBaselinesCompanion(
                localProfileId: localProfileId,
                onboardingReached: onboardingReached,
                belajarReached: belajarReached,
                learningReached: learningReached,
                quizAnswered: quizAnswered,
                quizAutoCorrect: quizAutoCorrect,
                quizAutoTotal: quizAutoTotal,
                quizSessionsCompleted: quizSessionsCompleted,
                gameStarsEarned: gameStarsEarned,
                gameStarsPossible: gameStarsPossible,
                gameSessionsCompleted: gameSessionsCompleted,
                migratedAtMillis: migratedAtMillis,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localProfileId,
                Value<int> onboardingReached = const Value.absent(),
                Value<int> belajarReached = const Value.absent(),
                Value<int> learningReached = const Value.absent(),
                Value<int> quizAnswered = const Value.absent(),
                Value<int> quizAutoCorrect = const Value.absent(),
                Value<int> quizAutoTotal = const Value.absent(),
                Value<int> quizSessionsCompleted = const Value.absent(),
                Value<int> gameStarsEarned = const Value.absent(),
                Value<int> gameStarsPossible = const Value.absent(),
                Value<int> gameSessionsCompleted = const Value.absent(),
                required int migratedAtMillis,
                Value<int> rowid = const Value.absent(),
              }) => LegacyProgressBaselinesCompanion.insert(
                localProfileId: localProfileId,
                onboardingReached: onboardingReached,
                belajarReached: belajarReached,
                learningReached: learningReached,
                quizAnswered: quizAnswered,
                quizAutoCorrect: quizAutoCorrect,
                quizAutoTotal: quizAutoTotal,
                quizSessionsCompleted: quizSessionsCompleted,
                gameStarsEarned: gameStarsEarned,
                gameStarsPossible: gameStarsPossible,
                gameSessionsCompleted: gameSessionsCompleted,
                migratedAtMillis: migratedAtMillis,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LegacyProgressBaselinesTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDatabase,
      $LegacyProgressBaselinesTable,
      LegacyProgressBaseline,
      $$LegacyProgressBaselinesTableFilterComposer,
      $$LegacyProgressBaselinesTableOrderingComposer,
      $$LegacyProgressBaselinesTableAnnotationComposer,
      $$LegacyProgressBaselinesTableCreateCompanionBuilder,
      $$LegacyProgressBaselinesTableUpdateCompanionBuilder,
      (
        LegacyProgressBaseline,
        BaseReferences<
          _$ProgressDatabase,
          $LegacyProgressBaselinesTable,
          LegacyProgressBaseline
        >,
      ),
      LegacyProgressBaseline,
      PrefetchHooks Function()
    >;

class $ProgressDatabaseManager {
  final _$ProgressDatabase _db;
  $ProgressDatabaseManager(this._db);
  $$StudentProfilesTableTableManager get studentProfiles =>
      $$StudentProfilesTableTableManager(_db, _db.studentProfiles);
  $$InstallationsTableTableManager get installations =>
      $$InstallationsTableTableManager(_db, _db.installations);
  $$LessonProgressRowsTableTableManager get lessonProgressRows =>
      $$LessonProgressRowsTableTableManager(_db, _db.lessonProgressRows);
  $$QuizAttemptsTableTableManager get quizAttempts =>
      $$QuizAttemptsTableTableManager(_db, _db.quizAttempts);
  $$QuizAnswersTableTableManager get quizAnswers =>
      $$QuizAnswersTableTableManager(_db, _db.quizAnswers);
  $$GameSessionsTableTableManager get gameSessions =>
      $$GameSessionsTableTableManager(_db, _db.gameSessions);
  $$LearningSessionsTableTableManager get learningSessions =>
      $$LearningSessionsTableTableManager(_db, _db.learningSessions);
  $$LearningEventsTableTableManager get learningEvents =>
      $$LearningEventsTableTableManager(_db, _db.learningEvents);
  $$SyncQueueItemsTableTableManager get syncQueueItems =>
      $$SyncQueueItemsTableTableManager(_db, _db.syncQueueItems);
  $$SyncMetadataRowsTableTableManager get syncMetadataRows =>
      $$SyncMetadataRowsTableTableManager(_db, _db.syncMetadataRows);
  $$LegacyProgressBaselinesTableTableManager get legacyProgressBaselines =>
      $$LegacyProgressBaselinesTableTableManager(
        _db,
        _db.legacyProgressBaselines,
      );
}
