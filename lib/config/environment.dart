enum AppEnv { dev, prod }

abstract class Environment {
  String name;
  String baseUrl;

  Environment({required this.baseUrl, required this.name});

  factory Environment.fromEnv(AppEnv appEnv) {
    if (appEnv == AppEnv.dev) {
      return DevEnvironment();
    } else {
      return ProdEnvironment();
    }
  }

  Future<void> map({
    required Future<void> Function() prod,
    required Future<void> Function() dev,
  }) async {
    if (this is ProdEnvironment) {
      await prod();
    } else if (this is DevEnvironment) {
      await dev();
    }
  }
}

// Create a development environment class.
class DevEnvironment extends Environment {
  DevEnvironment()
      : super(
    name: 'Dev',
    // baseUrl: 'http://psykee.cyberasol.com/api',
    // baseUrl: 'http://172.16.23.168/psykee/public/api',
    baseUrl: 'http://203.175.74.162/api',
  );
}

// Create a production environment class.
class ProdEnvironment extends Environment {
  ProdEnvironment()
      : super(
    name: 'Prod',
    // baseUrl: 'http://psykee.cyberasol.com/api',
    // baseUrl: 'http://172.16.23.168/psykee/public/api',
    baseUrl: 'http://203.175.74.162/api',
  );
}