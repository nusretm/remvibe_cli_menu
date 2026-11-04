import 'package:remvibe_cli_menu/remvibe_cli_menu.dart';

final class _DemoProject {
  _DemoProject(
    this.code,
    this.name, {
    required this.hasUpdate,
    required this.packageReady,
  });

  final String code;
  final String name;
  bool hasUpdate;
  bool packageReady;
}

Future<void> main() async {
  final projects = <_DemoProject>[
    _DemoProject(
      'avukatpro',
      'AvukatPro',
      hasUpdate: true,
      packageReady: true,
    ),
    _DemoProject(
      'mtn_launcher',
      'MTN Launcher',
      hasUpdate: true,
      packageReady: false,
    ),
  ];

  RemVibeCliMenu publishMenu(_DemoProject project) => RemVibeCliMenu(
        title: '${project.name} — Yayınlama',
        items: (context) => [
          for (final target in ['Windows', 'Linux', 'macOS'])
            RemVibeCliMenuItem(
              id: 'publish-${target.toLowerCase()}',
              label: target,
              onSelected: (context) {
                context.writeLine(
                  'DEMO: $target seçildi. Gerçek yayınlama yapılmadı.',
                );
                context.back();
              },
            ),
          RemVibeCliMenuItem(
            id: 'publish-all',
            label: 'Tümünü yayınla',
            shortcut: 'A',
            onSelected: (context) {
              context.writeLine(
                'DEMO: Tüm hedefler seçildi. Gerçek yayınlama yapılmadı.',
              );
              context.back();
            },
          ),
        ],
      );

  RemVibeCliMenu projectMenu(_DemoProject project) => RemVibeCliMenu(
        title: project.name,
        details: (_) => [
          'Proje kodu : ${project.code}',
          'İşletim sistemleri : Windows, Linux, macOS',
          'Yayınlanan son sürüm : demo veri (GitHub bağlantısı yok)',
          'Yayın tarihi : demo veri (GitHub bağlantısı yok)',
        ],
        items: (_) => [
          if (project.hasUpdate && !project.packageReady)
            RemVibeCliMenuItem(
              id: 'prepare',
              label: 'Güncelleme paketi hazırla',
              shortcut: 'U',
              onSelected: (context) {
                project.packageReady = true;
                context.writeLine('DEMO: Paket hazır durumu işaretlendi.');
              },
            ),
          if (project.packageReady)
            RemVibeCliMenuItem(
              id: 'publish',
              label: 'Güncelleme paketini yayınla',
              shortcut: 'R',
              onSelected: (context) => context.open(publishMenu(project)),
            ),
          RemVibeCliMenuItem(
            id: 'history',
            label: 'Sürüm geçmişi',
            shortcut: 'S',
            onSelected: (context) => context.writeLine(
              'DEMO: Sürüm geçmişi servisi henüz bağlanmadı.',
            ),
          ),
        ],
      );

  final root = RemVibeCliMenu(
    title: 'RemVibe Update Center (CLI Menu Demo)',
    items: (_) => [
      for (final project in projects)
        RemVibeCliMenuItem(
          id: project.code,
          label: project.name,
          marker: project.packageReady ? '*' : null,
          onSelected: (context) => context.open(projectMenu(project)),
        ),
      RemVibeCliMenuItem(
        id: 'add-project',
        label: 'Proje Ekle',
        onSelected: (context) async {
          final name = (await context.ask('Proje adı: '))?.trim();
          if (name == null || name.isEmpty) {
            context.writeLine('Proje eklenmedi.');
            return;
          }
          projects.add(
            _DemoProject(
              'demo-${projects.length + 1}',
              name,
              hasUpdate: false,
              packageReady: false,
            ),
          );
          context.writeLine('DEMO: Proje yerel listeye eklendi.');
        },
      ),
    ],
  );

  await RemVibeCliRunner().run(root);
}
