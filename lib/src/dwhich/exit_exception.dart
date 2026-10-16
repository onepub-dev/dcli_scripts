class ExitException implements Exception {
  final int exitCode;

  final String message;

  static const success = 0;

  static const foundExecutableBadPath = 1;

  static const foundNotExecutableGoodPath = 2;

  static const foundNotExecutableBadPath = 3;

  static const notFoundGoodPath = 4;

  static const notFoundBadPath = 5;

  static const invalidArgs = 6;

  ExitException(this.exitCode, this.message);

  static int mapExitCode(
      {required bool found, required bool exectuable, required bool goodPath}) {
    if (found && exectuable && goodPath) {
      return success;
    }

    if (found && exectuable && !goodPath) {
      return foundExecutableBadPath;
    }

    if (found && !exectuable && goodPath) {
      return foundNotExecutableGoodPath;
    }

    if (found && !exectuable && !goodPath) {
      return foundNotExecutableBadPath;
    }

    if (!found && goodPath) {
      return notFoundGoodPath;
    }

    if (!found && !goodPath) {
      return notFoundBadPath;
    }

    // we should never get here.
    return invalidArgs;
  }
}
