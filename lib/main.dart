import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const DartMainApp());
}

class DartMainApp extends StatelessWidget {
  const DartMainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF126E5A),
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'Dart-main',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF4F0E8),
        useMaterial3: true,
      ),
      home: const DartMainHomePage(),
    );
  }
}

class DartMainHomePage extends StatefulWidget {
  const DartMainHomePage({super.key});

  @override
  State<DartMainHomePage> createState() => _DartMainHomePageState();
}

class _DartMainHomePageState extends State<DartMainHomePage> {
  static const List<DartExample> _examples = [
    DartExample('Practical no.1', 'lib/Dart-main/Practical no.1.dart'),
    DartExample('Practical no.2a', 'lib/Dart-main/Practical no.2a.dart'),
    DartExample('Practical no.2b', 'lib/Dart-main/Practical no.2b.dart'),
    DartExample('Practical no.2c', 'lib/Dart-main/Practical no.2c.dart'),
    DartExample('Practical no.3a', 'lib/Dart-main/Practical no.3a.dart'),
    DartExample('Practical no.3b', 'lib/Dart-main/Practical no.3b.dart'),
    DartExample('Practical no.4a', 'lib/Dart-main/Practical no.4a.dart'),
    DartExample('Practical no.4b', 'lib/Dart-main/Practical no.4b.dart'),
    DartExample('Practical no.5a', 'lib/Dart-main/Practical no.5a.dart'),
    DartExample('Practical no.5b', 'lib/Dart-main/Practical no.5b.dart'),
    DartExample('Practical no.5c', 'lib/Dart-main/Practical no.5c.dart'),
    DartExample('Practical no.5d', 'lib/Dart-main/Practical no.5d.dart'),
    DartExample('Practical no.5e', 'lib/Dart-main/Practical no.5e.dart'),
    DartExample('Practical no.5f', 'lib/Dart-main/Practical no.5f.dart'),
    DartExample('Practical no.6', 'lib/Dart-main/Practical no.6.dart'),
    DartExample('Practical no.7', 'lib/Dart-main/Practical no.7.dart'),
    DartExample('Practical no.8a', 'lib/Dart-main/Practical no.8a.dart'),
    DartExample('Practical no.8b', 'lib/Dart-main/Practical no.8b.dart'),
    DartExample('Practical no.8c', 'lib/Dart-main/Practical no.8c.dart'),
    DartExample('Practical no.8d', 'lib/Dart-main/Practical no.8d.dart'),
    DartExample('Practical no 9c', 'lib/Dart-main/Practical no 9c.dart'),
    DartExample('Practical no.9a', 'lib/Dart-main/Practical no.9a.dart'),
    DartExample('Practical no.9b', 'lib/Dart-main/Practical no.9b.dart'),
    DartExample('Practical no.10', 'lib/Dart-main/Practical no.10.dart'),
    DartExample('Practical no 11', 'lib/Dart-main/Practical no 11.dart'),
  ];

  late DartExample _selectedExample;
  late Future<String> _selectedSource;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selectedExample = _examples.first;
    _selectedSource = _loadExample(_selectedExample);
  }

  Future<String> _loadExample(DartExample example) {
    return rootBundle.loadString(example.assetPath);
  }

  void _selectExample(DartExample example) {
    if (_selectedExample == example) {
      return;
    }

    setState(() {
      _selectedExample = example;
      _selectedSource = _loadExample(example);
    });
  }

  void _updateQuery(String value) {
    final filteredExamples = _examples
        .where((example) => example.title.toLowerCase().contains(value.toLowerCase()))
        .toList();

    setState(() {
      _query = value;
      if (filteredExamples.isNotEmpty && !filteredExamples.contains(_selectedExample)) {
        _selectedExample = filteredExamples.first;
        _selectedSource = _loadExample(_selectedExample);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.toLowerCase();
    final filteredExamples = _examples
        .where((example) => example.title.toLowerCase().contains(query))
        .toList();

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF4F0E8),
              Color(0xFFE6F1EC),
              Color(0xFFF4F0E8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HeroHeader(),
                const SizedBox(height: 20),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 980;
                      final sidebar = _ExampleSidebar(
                        examples: filteredExamples,
                        selectedExample: _selectedExample,
                        onQueryChanged: _updateQuery,
                        onExampleSelected: _selectExample,
                      );
                      final viewer = _CodeViewer(
                        example: _selectedExample,
                        sourceFuture: _selectedSource,
                      );

                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 320, child: sidebar),
                            const SizedBox(width: 20),
                            Expanded(child: viewer),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          SizedBox(height: 320, child: sidebar),
                          const SizedBox(height: 16),
                          Expanded(child: viewer),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF153B35),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Wrap(
        runSpacing: 16,
        spacing: 16,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B6F62),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'DEPLOYED FOLDER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Dart-main practical files, published as a browseable web collection.',
                  style: textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Open any practical file from the folder, read the source code online, and share one deploy link for the whole set.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFFD8E8E2),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFEEE3C8),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '25 files',
                  style: TextStyle(
                    color: Color(0xFF153B35),
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Bundled from lib/Dart-main',
                  style: TextStyle(
                    color: Color(0xFF355952),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleSidebar extends StatelessWidget {
  const _ExampleSidebar({
    required this.examples,
    required this.selectedExample,
    required this.onQueryChanged,
    required this.onExampleSelected,
  });

  final List<DartExample> examples;
  final DartExample selectedExample;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<DartExample> onExampleSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xDBFFFFFF),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFCEE1D9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Folder Index',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF173E37),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Search and open any practice file from the deployed folder.',
            style: TextStyle(
              color: Color(0xFF56736B),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: onQueryChanged,
            decoration: InputDecoration(
              hintText: 'Search practical file',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFF6FAF8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: examples.isEmpty
                ? const Center(
                    child: Text(
                      'No files match this search.',
                      style: TextStyle(
                        color: Color(0xFF56736B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: examples.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final example = examples[index];
                      final isSelected = example == selectedExample;

                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => onExampleSelected(example),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF153B35)
                                : const Color(0xFFF7F3EA),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF2B6F62)
                                      : const Color(0xFFE1E8DD),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.description_outlined,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF27554B),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  example.title,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF173E37),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CodeViewer extends StatelessWidget {
  const _CodeViewer({
    required this.example,
    required this.sourceFuture,
  });

  final DartExample example;
  final Future<String> sourceFuture;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF121A19),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            runSpacing: 10,
            spacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF203432),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'SOURCE VIEW',
                  style: TextStyle(
                    color: Color(0xFFA2C2B9),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                example.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            example.assetPath,
            style: const TextStyle(
              color: Color(0xFF7FA59A),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<String>(
              future: sourceFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFE4C78E),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Unable to load this file.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFE6B9B9),
                        height: 1.5,
                      ),
                    ),
                  );
                }

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2423),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF294140)),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      snapshot.data ?? '',
                      style: const TextStyle(
                        color: Color(0xFFF2F2EC),
                        height: 1.55,
                        fontSize: 14,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DartExample {
  const DartExample(this.title, this.assetPath);

  final String title;
  final String assetPath;
}
