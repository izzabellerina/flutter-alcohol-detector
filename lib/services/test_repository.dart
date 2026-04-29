import '../models/test_models.dart';

abstract class TestRepository {
  Future<void> save(TestSession session);
  Future<List<TestSession>> getAll();
}

/// Mock — เก็บใน memory (Phase 5+ จะเชื่อม API/SQLite จริง)
class InMemoryTestRepository implements TestRepository {
  final List<TestSession> _sessions = [];

  @override
  Future<void> save(TestSession session) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _sessions.add(session);
  }

  @override
  Future<List<TestSession>> getAll() async {
    return List.unmodifiable(_sessions);
  }
}
