import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart'; // Untuk WidgetsBindingObserver
import 'package:aplikasi_desa/services/auth_service.dart'; // Sesuaikan dengan path AuthService Anda
class ActivityTracker extends StatefulWidget {
  final Widget child;
  
  ActivityTracker({required this.child});

  @override
  _ActivityTrackerState createState() => _ActivityTrackerState();
}

class _ActivityTrackerState extends State<ActivityTracker> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateActivity();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkSession();
    }
  }

  Future<void> _updateActivity() async {
    await AuthService.updateLastActivity();
  }

  Future<void> _checkSession() async {
    final isValid = await AuthService.isSessionValid();
    if (!isValid) {
      await AuthService.logout();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _updateActivity(),
      child: widget.child,
    );
  }
}