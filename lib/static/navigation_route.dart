enum NavigationRoute {
  mainRoute("/"),
  detailRoute("/detail"),
  favoritesRoute("/favorites"),
  settingRoute("/setting"),
  searchRoute("/search");

  const NavigationRoute(this.name);
  final String name;
}
