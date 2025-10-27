import 'package:flutter/material.dart';

class CitySearchBar extends StatefulWidget {
  final void Function(String) onSubmitted;
  const CitySearchBar({super.key, required this.onSubmitted});

  @override
  State<CitySearchBar> createState() => _CitySearchBarState();
}

class _CitySearchBarState extends State<CitySearchBar> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        decoration: const InputDecoration(
          hintText: 'Search a city…',
          prefixIcon: Icon(Icons.search_rounded),
        ),
        onSubmitted: widget.onSubmitted,
      ),
    );
  }
}
