abstract interface class StudentRemoteDataSource {
  Future<void> upsertStudent(String uid, Map<String, Object?> data);
  Future<Map<String, dynamic>?> fetchStudent(String uid);
  Future<void> upsertInstallation(
    String uid,
    String installationId,
    Map<String, Object?> data,
  );
}

abstract interface class ProgressRemoteDataSource {
  Future<Map<String, dynamic>> fetchRecoveryState(String uid);
}

abstract interface class SyncRemoteDataSource {
  Future<void> writeBatch(List<RemoteWrite> writes);
}

class RemoteWrite {
  const RemoteWrite({required this.path, required this.data});

  final String path;
  final Map<String, dynamic> data;
}

