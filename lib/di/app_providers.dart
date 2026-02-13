import 'package:provider/single_child_widget.dart';

import 'package:expensetracker/di/core_providers.dart';
import 'package:expensetracker/di/repo_providers.dart';
import 'package:expensetracker/di/usecase_providers.dart';
import 'package:expensetracker/di/bloc_providers.dart';

List<SingleChildWidget> get appProviders {
  return [
    // Order matters! Core services first, then repos, then use cases, then blocs.
    // If a provider depends on another, the dependency must appear first in the list.
    ...coreProviders,
    ...repoProviders,
    ...useCaseProviders,
    ...blocProviders,
  ];
}
