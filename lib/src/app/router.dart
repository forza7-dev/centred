import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/dashboard/dashboard_page.dart';
import '../features/document/document_page.dart';
import '../features/fill_wizard/fill_wizard_page.dart';
import '../features/gdpr_confirmation/gdpr_confirmation_page.dart';

/// Central router — mirrors the sailgenius/shipshape convention of one
/// `Provider<GoRouter>`, named + kebab-case routes.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/fill/:entryId',
        name: 'fillWizard',
        builder: (context, state) => FillWizardPage(
          entryId: state.pathParameters['entryId']!,
          initialStep: state.uri.queryParameters['step'],
        ),
      ),
      GoRoute(
        path: '/view/:entryId',
        name: 'document',
        builder: (context, state) => DocumentPage(entryId: state.pathParameters['entryId']!),
      ),
      GoRoute(
        path: '/gdpr-confirmation',
        name: 'gdprConfirmation',
        builder: (context, state) => const GdprConfirmationPage(),
      ),
    ],
  );
});
