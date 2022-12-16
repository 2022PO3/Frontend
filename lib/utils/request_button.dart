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
                'The action failed: ${snapshot.error}',
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
    return ElevatedButton(
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
        child: Text(text));
  }
}

class RequestButtonIcon<T> extends StatefulWidget {
  /// Same as RequestButton but with Icon instead of text
  const RequestButtonIcon(
      {Key? key, required this.makeRequest, required this.icon})
      : super(key: key);

  @override
  State<RequestButtonIcon> createState() => _RequestButtonIconState<T>();

  final Future<T> Function() makeRequest;
  final Icon icon;
}

class _RequestButtonIconState<T> extends State<RequestButtonIcon> {
  Future<T>? future;

  @override
  Widget build(BuildContext context) {
    if (future == null) {
      return _buildButton(context, widget.icon);
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
                'The action failed: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
              _buildButton(context, widget.icon)
            ],
          );
        } else {
          return _buildButton(context, widget.icon);
        }
      },
    );
  }

  Widget _buildButton(BuildContext context, Icon icon) {
    return IconButton(
      icon: icon,
      onPressed: () {
        setState(() {
          future = widget.makeRequest() as Future<T>?;
        });
      },
    );
  }
}
