enum NavigationRoute {
  mainRoute("/"),
  detailRoute("/detail"),
  favoritesRoute("/favorites"),
  searchRoute("/search");

  const NavigationRoute(this.name);
  final String name;
}
