import 'package:flutter/material.dart';

class RequestButton<T> extends StatefulWidget {
  /// Button that makes a request to the backend, the makeRequest parameter
  /// should be a function that returns a future of T. While the future is
  /// loading, the button shows a progress indicator, when the future throws an
  /// error, the error is shown with a 'retry' button.
  const RequestButton({Key? key, required this.makeRequest, required this.text})
      : super(key: key);

  @override
  State<RequestButton> createState() => _RequestButtonState<T>();

  final Future<T> Function() makeRequest;
  final String text;
}

class _RequestButtonState<T> extends State<RequestButton> {
  Future<T>? future;

  @override
  Widget build(BuildContext context) {
    if (future == null) {
      return _buildButton(context, widget.text);
    }

    return FutureBuilder<void>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'The request to our servers failed: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
              _buildButton(context, 'Retry')
            ],
          );
        } else {
          return _buildButton(context, widget.text);
        }
      },
    );
  }

  Widget _buildButton(BuildContext context, String text) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              const StadiumBorder(),
            ),
          ),
          onPressed: () {
            setState(() {
              future = widget.makeRequest() as Future<T>?;
            });
          },
          child: Text(text)),
    );
  }
}
