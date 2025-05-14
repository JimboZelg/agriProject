import 'package:postgres/postgres.dart';
import 'package:dotenv/dotenv.dart';

late Connection db;

Future<void> connectToDatabase() async {
  final env = DotEnv()..load();

  db = await Connection.open(
    Endpoint(
      host: env['DB_HOST']!,
      port: int.parse(env['DB_PORT']!),
      database: env['DB_NAME']!,
      username: env['DB_USERNAME']!,
      password: env['DB_PASSWORD']!,
    ),
    settings: const ConnectionSettings(
      sslMode: SslMode.disable,
    ),
  );
}