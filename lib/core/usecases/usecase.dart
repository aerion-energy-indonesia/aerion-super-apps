// ignore_for_file: avoid_types_as_parameter_names
// ignore_for_file: unintended_html_in_doc_comment

// Base UseCase type for domain layer
// Example: class GetSomething extends UseCase<List<Thing>, Params> { ... }
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// Use when no params are required for a usecase
class NoParams {}
