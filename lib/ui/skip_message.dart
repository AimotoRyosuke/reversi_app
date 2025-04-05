import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SkipMessage extends HookWidget {
  const SkipMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final opacity = useState(1.0);

    useEffect(() {
      Future.delayed(const Duration(milliseconds: 100), () {
        opacity.value = 0.0;
      });
      return null;
    }, []);

    return AnimatedOpacity(
      opacity: opacity.value,
      duration: const Duration(seconds: 1),
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.black87,
        child: const Text(
          'スキップ',
          style: TextStyle(fontSize: 32, color: Colors.white),
        ),
      ),
    );
  }
}
